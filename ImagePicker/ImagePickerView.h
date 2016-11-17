//
//  ImagePickerView.h
//  EmployeeAssistant
//
//  Created by 武淅 段 on 2016/10/27.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface ImagePickerView : BaseView

typedef void(^finishPick)(CGFloat height);

@property (nonatomic) NSMutableArray *imgArr;
@property (nonatomic, copy) finishPick pickImgHandler;
@property (nonatomic, weak) UIViewController *ownerController;

@end
