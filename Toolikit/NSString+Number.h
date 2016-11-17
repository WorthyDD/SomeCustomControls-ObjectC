//
//  NSString+Number.h
//  EmployeeAssistant
//
//  Created by LiHaomiao on 16/9/22.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Number)

/**
 *  是否是数字string
 *
 *
 *  @return 是否是数字
 */
+ (BOOL)isNumber:(NSString *)string;

+ (NSString *)isNumber:(NSString *)string maxNumber:(NSInteger)maxNumber;
+ (NSString *)resultWithNumberString:(NSString *)string maxNumber:(NSInteger)maxNumber view:(UIView *)view units:(NSString *)units;
+ (NSString *)removeSuffixWithString:(NSString *)string removeString:(NSString *)removeString;

+ (NSString *)cutWithString:(NSString *)string length:(NSInteger)length;

@end
