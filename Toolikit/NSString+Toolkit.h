//
//  NSString+Toolkit.h
//  card
//
//  Created by Hale Chan on 15/3/31.
//  Copyright (c) 2015年 Tips4app Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (JSON)

/**
 *  作为JSON文本解析
 *
 *  @notice 相当于 NSString => NSData => JSON对象
 *
 *  @return 一个JSON对象
 */
- (id)parseAsJSONObject;

/**
 *  清除首尾的空白字符
 *
 *  @return 清除首尾的空白字符的串
 */
- (NSString *)trim;

/**
 *  判断是不是一个有效的手机号码
 *
 *  @notice 支持400/800号码
 *
 *  @return YES表示是个有效的手机号码，否则为NO
 */
- (BOOL)isValidPhoneNumber;

/**
 *  让电话号码中的数字分组（在合适的地方添加空格）
 *
 *  例如，13800138000  =>  138 0013 8000
 *
 *  @return 格式化之后的电话号码
 */
- (NSString *)phoneNumberByAddingSpaces;

/**
 *  清除电话号码中除数字以外的其它字符
 *
 *  @return 一个'干净'的电话号码
 */
- (NSString *)cleanPhoneNumber;

/**
 *  删除指定字符
 *
 *  @param str 一个样本串
 *
 *  @return 删除在str中出现的字符后的串
 */
- (NSString *)ta_stringByDeleteCharactersInString:(NSString *)str;

/**
 *  将数字转换为汉字表示
 *
 *  @param number 一个32位整数，但不支持-2147483648
 *
 *  @return 一个NSString实例
 */
+ (NSString *)stringWithChineseNumber:(int)number;

/**
 *  将数字的汉字表示转换为数字
 *
 *  @return 一个整数，如果不是有效的数字，则返回kInvalidChineseNumber
 */
- (int)chineseNumber;

/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */
-(CGSize)sizeWithFont:(UIFont *)font;
-(CGSize)sizeWithFont:(UIFont *)font width : (CGFloat)width height : (CGFloat)height;

@end

extern int const kInvalidChineseNumber;
