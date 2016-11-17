//
//  UITextField+Config.h
//  EmployeeAssistant
//
//  Created by LiHaomiao on 16/9/22.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITextField (Config)

- (void)configWithTextColor:(UIColor *)textColor textFont:(CGFloat)textFont placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor keyboardType:(UIKeyboardType)keyboardType minFontSize:(CGFloat)minFontSize;

@end
