//
//  ImageScanController.h
//  EmployeeAssistant
//
//  Created by 武淅 段 on 2016/10/31.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScanController : UIViewController

@property (nonatomic) NSMutableArray *imgs;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic,copy) void(^dismissHandler)();

@end
