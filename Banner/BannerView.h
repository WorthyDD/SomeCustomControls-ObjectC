//
//  BannerView.h
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/9.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerView : UIView

@property (nonatomic) NSArray<NSString *> *imgUrls; //图片地址
@property (nonatomic, weak) UIViewController *owner;

@end
