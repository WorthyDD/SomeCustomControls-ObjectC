//
//  UITextField+Config.m
//  EmployeeAssistant
//
//  Created by LiHaomiao on 16/9/22.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "UITextField+Config.h"

@implementation UITextField (Config)

- (void)configWithTextColor:(UIColor *)textColor textFont:(CGFloat)textFont placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor keyboardType:(UIKeyboardType)keyboardType minFontSize:(CGFloat)minFontSize
{
    [self setTextColor:textColor];
    [self setFont:[UIFont systemFontOfSize:textFont]];
    [self setPlaceholder:placeholder];
//    [self.placeholder setValue:placeholderColor forKey:@"_placeholderLabel.textColor"];
    [self setMinimumFontSize:minFontSize];
    [self setAdjustsFontSizeToFitWidth:YES];
    [self setKeyboardType:keyboardType];
}

@end
