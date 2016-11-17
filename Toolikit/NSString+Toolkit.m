//
//  NSString+Toolkit.m
//  card
//
//  Created by Hale Chan on 15/3/31.
//  Copyright (c) 2015年 Tips4app Inc. All rights reserved.
//

#import "NSString+Toolkit.h"

@implementation NSString (JSON)

- (id)parseAsJSONObject
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data.length) {
        id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        return obj;
    }
    return nil;
}

- (NSString *)trim
{
    NSInteger start = 0;
    NSInteger end = self.length - 1;
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    
    for (; start <= end; start++) {
        unichar strChar = [self characterAtIndex:start];
        if (![set characterIsMember:strChar]) {
            break;
        }
    }
    
    for (; start < end; end--) {
        unichar strChar = [self characterAtIndex:end];
        if (![set characterIsMember:strChar]) {
            break;
        }
    }
    
    if (start > end) {
        return @"";
    }
    
    NSRange range;
    range.location = start;
    range.length = end - start + 1;
    
    return [self substringWithRange:range];
}

- (NSString *)ta_stringByDeleteCharactersInString:(NSString *)str;
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:str];
    NSMutableString *result = [[NSMutableString alloc]initWithCapacity:str.length];
    for (int i=0; i<self.length; i++) {
        unichar strChar = [self characterAtIndex:i];
        if (![set characterIsMember:strChar]) {
            [result appendFormat:@"%C", strChar];
        }
    }
    return [NSString stringWithString:result];
}

- (NSString *)ta_stringByDeletePrefixs:(NSArray *)patterns
{
    for (NSString *prefix in patterns) {
        if ([self hasPrefix:prefix]) {
            return [self substringFromIndex:prefix.length];
        }
    }
    return self;
}

- (NSString *)cleanPhoneNumber
{
    NSMutableString *numbers = [[NSMutableString alloc]init];
    for (NSInteger i=0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (c >= '0' && c<='9') {
            [numbers appendFormat:@"%C", c];
        }
    }
    
    NSString *str = [numbers ta_stringByDeletePrefixs:@[@"86", @"0086"]];
    return str;
}

- (NSString *)phoneNumberByAddingSpaces
{
    NSString *text = [self cleanPhoneNumber];
    NSMutableString *result = [[NSMutableString alloc]initWithCapacity:13];
    if (text.length > 3) {
        [result appendString:[text substringToIndex:3]];
        [result appendString:@" "];
        if (text.length > 7) {
            NSRange range;
            range.location = 3;
            range.length = 4;
            [result appendString:[text substringWithRange:range]];
            [result appendString:@" "];
            range.location = 7;
            range.length = text.length - 7;
            
            if (range.length > 4) {
                range.length = 4;
            }
            [result appendString:[text substringWithRange:range]];
        }
        else {
            [result appendString:[text substringFromIndex:3]];
        }
        return [NSString stringWithString:result];
    }
    else {
        return text;
    }
}

- (BOOL)isValidPhoneNumber
{
    //目前只支持中国号码
//    NSString *str = [self ta_stringByDeleteCharactersInString:@"+-\t "];
//    
//    NSMutableString *numbers = [[NSMutableString alloc]init];
//    for (NSInteger i=0; i<self.length; i++) {
//        unichar c = [self characterAtIndex:i];
//        if (c >= '0' && c<='9') {
//            [numbers appendFormat:@"%C", c];
//        }
//    }
    
    NSString *str = [self cleanPhoneNumber];
    
    if (str.length != 11) {
        return NO;
    }
    
    if ([str hasPrefix:@"13"] ||
        [str hasPrefix:@"15"] ||
        [str hasPrefix:@"17"] ||
        [str hasPrefix:@"18"] ||
        [str hasPrefix:@"800"] ||
        [str hasPrefix:@"400"] ||
        [str hasPrefix:@"1"] ) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)stringWithChineseNumber:(int)number
{    
    if (kInvalidChineseNumber == number) {
        return nil;
    }
    
    //-2147483648 ~ 2147483647
    NSArray *oneDigits = @[@"零", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九"];
    NSArray *smallUnits = @[@"", @"十", @"百", @"千"];
    NSArray *bigUnits = @[@"", @"万", @"亿"];
    
    int quotient, remainder;
    remainder = 0;
    
    NSString *prefix;
    if (number < 0) {
        prefix = @"负";
        quotient = ABS(number);
    }
    else {
        quotient = number;
        prefix = @"";
    }
    
    if (0 == quotient) {
        return oneDigits[0];
    }
    
    NSString *(^stringFor4Digits)(int num) = ^(int num){
        BOOL lowerIsZero = NO;
        BOOL allLowerIsZero = YES;
        
        int quotient = num;
        int remainder = 0;
        NSInteger index = 0;
        
        NSMutableString *result = [[NSMutableString alloc]initWithCapacity:9];
        while (quotient) {
            remainder = quotient % 10;
            quotient = quotient / 10;
            
            if (0 == remainder) {
                lowerIsZero = YES;
            }
            else {
                //低位不全是0时，需要插入一个零
                if (lowerIsZero && !allLowerIsZero) {
                    [result insertString:oneDigits[0] atIndex:0];
                }
                
                //插入当前位的单位和数字
                [result insertString:smallUnits[index] atIndex:0];
                [result insertString:oneDigits[remainder] atIndex:0];
                
                lowerIsZero = NO;
                allLowerIsZero = NO;
            }
            
            index++;
        }
        
        if ([result hasPrefix:@"一十"]) {
            NSRange range;
            range.location = 0;
            range.length = 1;
            [result deleteCharactersInRange:range];
        }
        
        return [NSString stringWithString:result];
    };
    
    NSMutableString *result = [[NSMutableString alloc]initWithCapacity:20];
    NSInteger bigIndex = 0;
    BOOL lowerIsZero = NO;
    BOOL allLowerIsZero = YES;
    while (quotient) {
        remainder = quotient % 10000;
        quotient = quotient / 10000;
        
        NSString *lowBits = stringFor4Digits(remainder);
        if (lowBits.length) {
            //低位不全是0, 但右边的一组/多组数是0，那么补一个零
            if (lowerIsZero && !allLowerIsZero) {
                [result insertString:oneDigits[0] atIndex:0];
            }
            
            [result insertString:bigUnits[bigIndex] atIndex:0];
            [result insertString:lowBits atIndex:0];
            
            allLowerIsZero = NO;
            lowerIsZero = NO;
            
            if (remainder < 1000) {
                lowerIsZero = YES;
            }
        }
        else {
            lowerIsZero = YES;
        }
        bigIndex++;
    }
    
    return [NSString stringWithFormat:@"%@%@", prefix, result];
}

- (int)chineseNumber
{
    NSString *empty = [self ta_stringByDeleteCharactersInString:@"零一二三四五六七八九十百千万亿"];
    if (empty.length) {
        return kInvalidChineseNumber;
    }
    
    NSArray *oneDigits = @[@"零", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九"];
    NSArray *smallUnits = @[@"十", @"百", @"千"];
    NSArray *bigUnits = @[@"万", @"亿"];
    
    NSString *str;
    BOOL isNegtive = NO;
    if ([self hasPrefix:@"负"]) {
        isNegtive = YES;
        str = [self substringFromIndex:1];
    }
    else {
        str = self;
    }
    
    int result = 0;
    int smallNumber = 0;
    int digit = 0;
    while (str.length) {
        NSString *prefix = [str substringToIndex:1];
        NSInteger index = [bigUnits indexOfObject:prefix];
        str = [str substringFromIndex:1];
        
        //遇到亿或万了
        if (index != NSNotFound) {
            if (0 == smallNumber) {
                smallNumber = digit;
            }
            else {
                smallNumber += digit;
            }
            
            if (0 == index) {
                smallNumber *= 10000;
            }
            else if(1 == index){
                smallNumber *= 100000000;
            }
            
            result += smallNumber;
            smallNumber = 0;
            digit = 0;
            continue;
        }
        
        //遇到数字了
        index = [oneDigits indexOfObject:prefix];
        if (index != NSNotFound) {
            digit = (int)index;
            continue;
        }
        
        //遇到十，百，千了
        index = [smallUnits indexOfObject:prefix];
        if (index != NSNotFound) {
            if (0 == digit) {
                digit = 1;
            }
            
            if (0 == index) {
                smallNumber += digit*10;
            }
            else if(1 == index){
                smallNumber += digit*100;
            }
            else {
                smallNumber += digit*1000;
            }
            
            digit = 0;
            
            continue;
        }
    }
    
    result += smallNumber + digit;
    if (isNegtive) {
        result *= -1;
    }
    
    return result;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font width:(CGFloat)width height:(CGFloat)height
{
    CGSize maxSize = CGSizeMake(width, height);
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end

int const kInvalidChineseNumber = -2147483648;
