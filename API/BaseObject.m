//
//  BaseObject.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/8/30.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "BaseObject.h"
#import "Tookit.h"

@implementation BaseObject


+ (instancetype)objectWithJson:(id)jsonObject
{
    if([jsonObject isKindOfClass:[NSDictionary class]]){
        NSDictionary *info = jsonObject;
        if([info count]){
            return [[self alloc]initWithJsonObject:info];
        }
    }
    return nil;
}

+ (NSDictionary *)JSONMap
{
    return nil;
}

+ (NSDictionary *)arrayElementMap
{
    return nil;
}

+ (NSDictionary *)classMap
{
    return nil;
}

- (instancetype) initWithJsonObject:(NSDictionary *)jsonObject
{
    self = [self init];
    if(self){
        NSDictionary *map = [[self class] JSONMap];
        NSDictionary *classMap = [[self class] classMap];
        NSDictionary *arrayMap = [[self class] arrayElementMap];
        
        for(NSString *key in map.allKeys){
            
            id value = [jsonObject objectForKey:key];
            if ([value isKindOfClass:[NSNull class]]) {
                continue;
            }
            
            NSString *localKey = [map objectForKey:key];
            if(localKey == nil || !value){
                continue;
            }
            
            //数组
            if([value isKindOfClass:[NSArray class]]){
                NSString *className = [arrayMap objectForKey:key];
                if(className){
                    NSMutableArray *arr = [NSMutableArray new];
                    
                    Class class = NSClassFromString(className);
                    for(id elementValue in value){
//                        id elementObj = [[class alloc]initWithJsonObject:elementValue];
                        id elementObj = [class objectWithJson:elementValue];
                        [arr addObject:elementObj];
                    }
                    [self setValue:arr.copy forKey:localKey];
                    
                }
                else{
                    [self setValue:value forKey:localKey];
                }
            }
            else if(value){
                
                //class
                NSString *className = [classMap objectForKey:key];
                if(className){
                    Class class = NSClassFromString(className);
//                    id obj = [[class alloc]initWithJsonObject:value];
                    id obj = [class objectWithJson:value];
                    [self setValue:obj forKey:localKey];
                }
                else{
                    [self setValue:value forKey:localKey];
                }
            }
            
        }

    }
    
    return self;
}

@end


@implementation PageInfo

+ (NSDictionary *)JSONMap
{
    static NSDictionary *config;
    if ( !config ){
        config = @{@"current_page" : @"currentPage",
                   @"page_size" : @"pageSize",
                   @"total_count" : @"totalCount",
                   @"total_page" : @"totalPage"};
    }
    return config;
}

- (BOOL)hasMore
{
    if(self.currentPage < self.totalPage){
        return YES;
    }
    else{
        return NO;
    }
}

@end


@implementation NSDate (BaseObject)

+(instancetype)objectWithJson:(id)jsonObject
{
    if ([jsonObject isKindOfClass:[NSNumber class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)jsonObject doubleValue]];
    }
    else if([jsonObject isKindOfClass:[NSString class]]){
        return [NSDate dateFromRFC3339String:jsonObject];
    }
    return nil;
}


+ (NSDate *)dateFromRFC3339String:(NSString *)RFC3339String
{
    NSString *dateString = [RFC3339String ta_stringByDeleteCharactersInString:@"Tt "];
    
    static NSString *dateFormat = @"yyyy-MM-dd";
    static NSString *timeFormat = @"HH:mm:ss";
    static NSString *dateTimeFormat = @"yyyy-MM-ddHH:mm:ss";
    
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc]init];
    }
    
    NSInteger length = dateString.length;
    if (length == dateFormat.length) {
        [formatter setDateFormat:dateFormat];
    }
    else if(timeFormat.length == length) {
        [formatter setDateFormat:timeFormat];
    }
    else if(dateTimeFormat.length == length){
        [formatter setDateFormat:dateTimeFormat];
    }
    else {
        return nil;
    }
    
    return [formatter dateFromString:dateString];
}

@end
