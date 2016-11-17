//
//  NSString+Calculate.m
//  EmployeeAssistant
//
//  Created by LiHaomiao on 16/9/22.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "NSString+Calculate.h"

@implementation NSString (Calculate)

+ (CGFloat)calculateHeightWithStr:(NSString *)str withFont:(CGFloat)font maxWidth:(CGFloat)maxWidth
{
    CGFloat contentWidth = maxWidth;
    UIFont *uiFont = [UIFont systemFontOfSize:font];
    if ( str == nil ){
        str = @"";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [str boundingRectWithSize:CGSizeMake(contentWidth, 10000.0f) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : uiFont, NSParagraphStyleAttributeName : paragraphStyle.copy} context:nil].size;
    return size.height;
}

+ (CGFloat)calculateWidthWithString:(NSString *)str font:(CGFloat)font
{
    UIFont *uiFont = [UIFont systemFontOfSize:font];
    return [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : uiFont} context:nil].size.width;
}

+ (CGFloat)calculateHeightWithAttributeStr:(NSAttributedString *)str width:(CGFloat)width
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)  options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    return size.height;
}

+ (CGFloat)calculateHeightWithStrings:(NSArray *)strings stringFont:(CGFloat)stringFont eachStringGap:(CGFloat)eachStringGap eachStringHeight:(CGFloat)eachStringHeight horizontalGap:(CGFloat)horizontalGap verticalGap:(CGFloat)verticalGap width:(CGFloat)width
{
    CGFloat height = eachStringHeight;
    CGFloat onelineWidth = 0.0f;
    for ( NSString *str in strings ){
        CGFloat strWidth = [self calculateWidthWithString:str font:stringFont] + eachStringGap;
        //换行
        if ( onelineWidth + strWidth > width ){
            height += (eachStringHeight + verticalGap);
            onelineWidth = strWidth;
        }else{
            onelineWidth += (strWidth + horizontalGap);
        }
    }
    
    return height;
}

- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size
{
    //特殊的格式要求都写在属性字典中
    NSDictionary*attrs =@{NSFontAttributeName: font};
    //返回一个矩形，大小等于文本绘制完占据的宽和高。
    return  [self  boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs   context:nil].size;
}

+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font  andMaxSize:(CGSize)size
{
    NSDictionary*attrs =@{NSFontAttributeName: font};
    return  [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs  context:nil].size;
}
@end
