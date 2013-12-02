/*
 * Copyright (c) 2010-2012 Matthijs Hollemans
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHImageCache.h"
#import <CommonCrypto/CommonDigest.h>


@implementation UIImageView (MHImageCache)

- (void)mh_loadImageFromURL:(NSURL *)url
{
	__weak UIImageView *weakSelf = self;
	[[MHImageCache sharedInstance] imageFromURL:url usingBlock:^(UIImage *theImage)
	{
		if (theImage != nil && weakSelf != nil)
		{
			weakSelf.image = theImage;
		}
	}];
}

@end

@implementation MHImageCache
{
	NSMutableDictionary *_images;         // images that are loaded into memory
	NSMutableDictionary *_loadingImages;  // images that are currently being downloaded
	NSString *_cacheDirectory;            // where we will cache image files
}

+ (instancetype)sharedInstance
{
	static dispatch_once_t pred;
	static MHImageCache *sharedInstance;
	dispatch_once(&pred, ^{ sharedInstance = [[[self class] alloc] init]; });
	return sharedInstance;
}

- (NSMutableDictionary *)images
{
	if (_images == nil)
	{
		_images = [NSMutableDictionary dictionaryWithCapacity:10];
	}
	return _images;
}

- (NSMutableDictionary *)loadingImages
{
	if (_loadingImages == nil)
	{
		_loadingImages = [NSMutableDictionary dictionaryWithCapacity:5];
	}
	return _loadingImages;
}

- (NSString *)cacheDirectory
{
	if (_cacheDirectory == nil)
	{
		NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

		NSString* libraryDirectory = paths[0];

		_cacheDirectory = [libraryDirectory stringByAppendingString:@"/thumb_cache"];

		NSFileManager* fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:_cacheDirectory])
		{
			NSError* error = nil;
            NSLog(@"Creating directory: %@", _cacheDirectory);
			if (![fileManager createDirectoryAtPath:_cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error])
				NSLog(@"Error creating directory: %@", [error description]);
		}
	}
	return _cacheDirectory;
}

- (NSString *)keyForURL:(NSURL *)url
{
	return [url absoluteString];
}

- (void)notifyBlocksForKey:(NSString *)key
{
	NSMutableArray *blocks = (self.loadingImages)[key];

	for (MHImageCacheBlock block in blocks)
	{
		// It is possible for the block to replace the image with another one;
		// for example, it may do post-processing and put the processed image
		// back into the cache under the same key. Because the image may be
		// changed out from under us, we must look it up anew on every loop.
		block((self.images)[key]);
	}

	[self.loadingImages removeObjectForKey:key];
}

- (void)imageFromURL:(NSURL *)url usingBlock:(MHImageCacheBlock)block
{
	[self imageFromURL:url cacheInFile:YES usingBlock:block];
}

- (void)imageFromURL:(NSURL *)url cacheInFile:(BOOL)cacheInFile usingBlock:(MHImageCacheBlock)block
{
	NSString *originalURL = [self keyForURL:url];
    const char *str = [originalURL UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *key = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
	// 1) If we have the image in memory, use it.
    NSLog(@"If we have the image in memory, use it.");
	UIImage *image = (self.images)[key];
	if (image != nil)
	{
		block(image);
		return;
	}

	// 2) If we have the file locally stored, then load into memory and use it.
    NSLog(@"If we have the file locally stored, then load into memory and use it.");
	NSString *path = nil;
	if (cacheInFile)
	{
		path = [[self cacheDirectory] stringByAppendingPathComponent:key];
		image = [UIImage imageWithContentsOfFile:path];
        NSLog(@"Load image from %@", path);
		if (image != nil)
		{
			(self.images)[key] = image;
			block(image);
			return;
		}
	}

	// 3) If a download for this image is already pending, then add the block 
	//    to the list of blocks that will be invoked when the download is done.
    NSLog(@"If a download for this image is already pending, then add the block to the list of blocks that will be invoked when the download is done.");
	block = [block copy];  // move to heap!

	NSMutableArray *array = (self.loadingImages)[key];
	if (array != nil)
	{
		[array addObject:block];
		return;
	}

	// 4) Download the image, store it in a local file (if allowed), and use it.
    NSLog(@"Download the image, store it in a local file (if allowed), and use it.");
	array = [NSMutableArray arrayWithCapacity:3];
	[array addObject:block];
	(self.loadingImages)[key] = array;

	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

	[NSURLConnection sendAsynchronousRequest:request
		queue:[NSOperationQueue mainQueue]
		completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
		{
			NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

			UIImage *image = nil;
            
            if (error == nil && [httpResponse statusCode] == 200)
			{
				image = [[UIImage alloc] initWithData:data];
				if (image != nil)
				{
					if (cacheInFile) {
                        NSString *path = [[self cacheDirectory] stringByAppendingPathComponent:key];
                        NSLog(@"Write to :%@",path);
                        
						[data writeToFile:path atomically:NO];
                    }
					(self.images)[key] = image;
				}
			}

			[self notifyBlocksForKey:key];
		}];
}

- (UIImage *)cachedImageWithURL:(NSURL *)url
{
	return (self.images)[[self keyForURL:url]];
}

- (void)cacheImage:(UIImage *)image withURL:(NSURL *)url
{
	(self.images)[[self keyForURL:url]] = image;
}

- (void)flushMemory
{
	[_images removeAllObjects];
}

@end
