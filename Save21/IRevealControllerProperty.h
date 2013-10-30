//
//  IRevealControllerProperty.h
//  StoryboardSideMenu
//
//  Created by zyl910 on 13-6-8.
//  Copyright (c) 2013年 zyl910. All rights reserved.
//

/**
 * @file	IRevealControllerProperty.h
 * @brief	具有revealController(侧开菜单控制器)属性的接口.
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
#import "GHRevealViewController.h"

/// 具有revealController(侧开菜单控制器)属性的接口.
@protocol IRevealControllerProperty <NSObject>

#pragma mark - property
@required

/// 侧开菜单控制器.
@property (nonatomic,weak) GHRevealViewController* revealController;

#pragma mark - method


@end
