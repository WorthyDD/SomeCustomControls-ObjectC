//
//  NSString+Calculate.h
//  EmployeeAssistant
//
//  Created by LiHaomiao on 16/9/22.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Calculate)


/**
 *  计算字符串在给定行宽的情况下的高度
 *
 *  @param str        需计算的字符串
 *  @param font       计算的字体大小
 *  @param maxWidth   最大行宽
 *
 *  @return 给定行宽下的高度
 */
+ (CGFloat)calculateHeightWithStr:(NSString *)str withFont:(CGFloat)font maxWidth:(CGFloat)maxWidth;

/**
 *  计算字符串在一行中的宽度
 *
 *  @param str  需计算的字符串
 *  @param font 计算的字体大小
 *
 *  @return 一行的宽度
 */
+ (CGFloat)calculateWidthWithString:(NSString *)str font:(CGFloat)font;

/**
 *  计算字符串在给定行宽的情况下的高度 类型是：NSAttributedString
 *
 *  @param str        需计算的字符串  NSAttributedString
 *  @param width   最大行宽
 *
 *  @return 给定行宽下的高度
 */
+ (CGFloat)calculateHeightWithAttributeStr:(NSAttributedString *)str width:(CGFloat)width;


/**
 *  计算一组字符串的所占的高度
 *
 *  @param strings          一组字符串
 *  @param stringFont       字符串的字体
 *  @param eachStringGap    每个字符串的自身间隔
 *  @param eachStringHeight 每一个string所占有的高度
 *  @param horizontalGap    每两组字符串的水平间距
 *  @param verticalGap      每行的垂直间距
 *  @param width            总空间的宽度
 *
 *  @return 一组字符串的所占的高度
 */
+ (CGFloat)calculateHeightWithStrings:(NSArray *)strings stringFont:(CGFloat)stringFont eachStringGap:(CGFloat)eachStringGap eachStringHeight:(CGFloat)eachStringHeight horizontalGap:(CGFloat)horizontalGap verticalGap:(CGFloat)verticalGap width:(CGFloat)width ;


- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size;

+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font  andMaxSize:(CGSize)size;
@end
