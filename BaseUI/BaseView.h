//
//  BaseView.h
//  card
//
//  Created by Hale Chan on 15/4/8.
//  Copyright (c) 2015年 Papaya Mobile Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface BaseView : UIView

+ (instancetype)viewFromDefaultNib;

+ (instancetype)viewFromDefaultNibWithNibName:(NSString *)nibName;

- (void)commonInit;

- (void)baseRemoveAllSubViews;

@end
