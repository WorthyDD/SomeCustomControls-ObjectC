//
//  NSString+Number.m
//  EmployeeAssistant
//
//  Created by LiHaomiao on 16/9/22.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "NSString+Number.h"
#import "UIView+Toast.h"

@implementation NSString (Number)

+ (NSString *)isNumber:(NSString *)string maxNumber:(NSInteger)maxNumber
{
    if( ![self isNumber:string] ) {
        return nil;
    }
    
    return [self comparingWithString:string maxnNumber:maxNumber];
}

+ (NSString *)comparingWithString:(NSString *)string maxnNumber:(NSInteger)maxNumber
{
    NSMutableString *numberStr = [NSMutableString stringWithString:string];
    NSInteger number = 0;
    for ( int i = 0; i < numberStr.length; ++i ){
        NSString *temp = [numberStr substringWithRange:NSMakeRange(i, 1)];
        number = number * 10 + [temp integerValue];
    }
    
    
    if ( number > maxNumber ){
        return @"";
    }
    return [NSString stringWithFormat:@"%d",(int)number];
}

+ (BOOL)isNumber:(NSString *)string{
    
    //判断是不是纯数字
    [NSCharacterSet decimalDigitCharacterSet];
    if ([[string stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]] trimming].length >0) {
        NSLog(@"不是的纯数字！");
        return NO;
    }else{
        NSLog(@"纯数字！");
    }
    
    return YES;
}

- (NSString *) trimming {
    
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}


+ (NSString *)resultWithNumberString:(NSString *)string maxNumber:(NSInteger)maxNumber view:(id)view units:(NSString *)units
{
    NSString *showStr = [self isNumber:string maxNumber:maxNumber];
    if ( !showStr ){
        [view makeToast:@"输入不合法"];
        return @"";
    }else if ( [showStr isEqualToString:@""] ){
        [view makeToast:@"填写数字过大"];
        return @"";
    }else{
        return [self addUnitsWithString:showStr units:units];
    }
    
}

//把单位拼接到后边
+ (NSString *)addUnitsWithString:(NSString *)string units:(NSString *)units
{
    return [NSString stringWithFormat:@"%@%@",string,units];
}

+ (NSString *)removeSuffixWithString:(NSString *)string removeString:(NSString *)removeString
{
    if ( string.length > 0 && removeString ){
        NSString *temp = @"";
        if ( [string hasSuffix:removeString] ){
            temp = [string substringToIndex:string.length - removeString.length];
            
            return temp;
        }
    }
    return string;
}


+(NSString *)cutWithString:(NSString *)string length:(NSInteger)length
{
    if ( string.length > length ){
        NSString *str = [string substringToIndex:length];
        return str;
    }
    return string;
}

@end
