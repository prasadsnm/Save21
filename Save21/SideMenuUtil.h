//
//  SideMenuUtil.h
//  StoryboardSideMenu
//
//  Created by zyl910 on 13-6-8.
//  Copyright (c) 2013年 zyl910. All rights reserved.
//

/**
 * @file	SideMenuUtil.h
 * @brief	侧开菜单工具. 是一个静态类，提供侧开菜单的一些辅助方法.
 * @author	[zyl910](http://www.cnblogs.com/zyl910/)
 * @version	1.0
 * @date	2013-06-14
 *
 * ## Change history (变更日志)
 *
 * [2013-06-14] <zyl910> v1.0
 *
 * + v1.0版发布.
 *
 */

#import <Foundation/Foundation.h>
#import "IRevealControllerProperty.h"

/// 侧开菜单工具. 是一个静态类，提供侧开菜单的一些辅助方法.
@interface SideMenuUtil : NSObject

#pragma mark - property



#pragma mark - method

/**
 *	@brief	设置revealController属性.
 *
 * - 若有IRevealControllerProperty接口，便用该接口赋值.
 * - 若是UINavigationController，则自动为其中的页面赋值.
 *
 *	@param 	obj 	需要设置revealController属性的对象.
 *	@param 	revealController 	侧开菜单控制器.
 *
 *	@return	若设置成功（或部分成功）时，则返回原obj。若全部失败，返回nil;
 */
+ (id)setRevealControllerProperty:(id)obj revealController:(GHRevealViewController*)revealController;


/**
 *	@brief	添加导航手势.
 *
 *	@param 	navigationController 	导航控制器.
 *	@param 	revealController 	侧开菜单控制器.
 *
 *	@return	成功时返回YES，失败时返回NO.
 */
+ (BOOL)addNavigationGesture:(UINavigationController*)navigationController revealController:(GHRevealViewController*)revealController;


@end
