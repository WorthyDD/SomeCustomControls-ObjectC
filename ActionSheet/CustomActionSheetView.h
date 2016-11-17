//
//  CustomActionSheetView.h
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/18.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//  可以滑动
//

#import <UIKit/UIKit.h>

//点击事件
typedef void(^tapHandler) (NSInteger itemIndex);

@interface CustomActionSheetView : UIView


@property (nonatomic, copy) tapHandler handler; //点击事件
@property (nonatomic, assign) NSInteger selectedIndex;      //当前选择的序号

- (instancetype) initWithTitle : (NSString *) title items : (NSArray *)items;
- (void) show;

@end
