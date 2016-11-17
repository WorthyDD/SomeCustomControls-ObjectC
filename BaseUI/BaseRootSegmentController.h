//
//  BaseRootSegmentController.h
//  EmployeeAssistant
//  通过segmentControl控制的根控制器
//  Created by 武淅 段 on 16/9/21.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseRootSegmentController : BaseViewController

@property (nonatomic) UISegmentedControl *segment;

- (instancetype) initWithSegmentItems : (NSArray *)items defaultIndex : (NSInteger)index;

//添加子控制器
- (void) addChildrenControllers : (NSArray<UIViewController*> *) controllers;

@end
