//
//  MineType.m
//  TurboUDisk
//
//  Created by Hale Chan on 15/1/8.
//  Copyright (c) 2015年 Tips4app Inc. All rights reserved.
//

#import "MineType.h"

static NSMutableDictionary *_ext2MineTypeMap;
static NSArray *_mineTypes;

@implementation MineType

- (instancetype)initWithType:(NSString *)type subType:(NSString *)subType extensions:(NSArray *)extensions
{
    self = [super init];
    if (self) {
        if ([type isEqualToString:kMineTypeApplication]) {
            _type = kMineTypeApplication;
        }
        else if([type isEqualToString:kMineTypeAudio]) {
            _type = kMineTypeAudio;
        }
        else if([type isEqualToString:kMineTypeChemical]){
            _type = kMineTypeChemical;
        }
        else if([type isEqualToString:kMineTypeImage]){
            _type = kMineTypeImage;
        }
        else if([type isEqualToString:kMineTypeMessage]){
            _type = kMineTypeMessage;
        }
        else if([type isEqualToString:kMineTypeModel]){
            _type = kMineTypeModel;
        }
        else if([type isEqualToString:kMineTypeText]){
            _type = kMineTypeText;
        }
        else if([type isEqualToString:kMineTypeVideo]){
            _type = kMineTypeAudio;
        }
        else if([type isEqualToString:kMineTypeXConference]){
            _type = kMineTypeXConference;
        }
        else {
            _type = [type copy];
        }
        
        _subType = [subType copy];
        _extensions = [extensions copy];
    }
    return self;
}

+ (NSArray *)supportedMineTypes
{
    NSMutableArray *mineTypes = [[NSMutableArray alloc]init];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ext2MineTypeMap = [NSMutableDictionary dictionary];
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"mineType" ofType:@"txt"];
        NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray *components = [str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        for (NSString *line in components) {
            NSArray *cols = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (cols.count > 1) {
                NSString *fullType = cols[0];
                NSMutableArray *exts = [[NSMutableArray alloc]init];
                for (NSInteger i=1; i<cols.count; i++) {
                    NSString *ext = cols[i];
                    if ([ext isEqualToString:@" "] || ext.length == 0) {
                        continue;
                    }
                    [exts addObject:ext];
                }
                
                NSRange range = [fullType rangeOfString:@"/"];
                if (range.location != NSNotFound) {
                    NSString *type = [fullType substringToIndex:range.location];
                    NSString *subType = [fullType substringFromIndex:range.location+1];
                    MineType *mineType = [[MineType alloc]initWithType:type subType:subType extensions:exts];
                    [mineTypes addObject:mineType];
                    
                    for (NSString *ext in exts) {
                        _ext2MineTypeMap[ext] = mineType;
                    }
                }
            }
        }
        
        _mineTypes = [NSArray arrayWithArray:mineTypes];
    });
    return _mineTypes;
}

+ (instancetype)mineTypeForExtension:(NSString *)ext
{
    if (_ext2MineTypeMap.count) {
        [self supportedMineTypes];
    }
    
    NSString *realExt = [ext lowercaseString];
    return realExt.length ? _ext2MineTypeMap[realExt] : nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (_type.length) {
        [aCoder encodeObject:_type forKey:@"type"];
    }
    if (_subType.length) {
        [aCoder encodeObject:_subType forKey:@"subType"];
    }
    if (_extensions.count) {
        [aCoder encodeObject:_extensions forKey:@"extensions"];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _type = [aDecoder decodeObjectForKey:@"type"];
        _subType = [aDecoder decodeObjectForKey:@"subType"];
        _extensions = [aDecoder decodeObjectForKey:@"extensions"];
    }
    return self;
}

- (NSString *)description
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@/%@\t", _type, _subType];
    
    BOOL isFirstExt = YES;
    for (NSString *ext in _extensions) {
        if (isFirstExt) {
            [str appendFormat:@"%@", ext];
            isFirstExt = NO;
        }
        else {
            [str appendFormat:@" %@", ext];
        }
    }
    return [NSString stringWithString:str];
}

@end

NSString *const kMineTypeApplication    = @"application";
NSString *const kMineTypeAudio          = @"audio";
NSString *const kMineTypeChemical       = @"chemical";
NSString *const kMineTypeImage          = @"image";
NSString *const kMineTypeMessage        = @"message";
NSString *const kMineTypeModel          = @"model";
NSString *const kMineTypeText           = @"text";
NSString *const kMineTypeVideo          = @"video";
NSString *const kMineTypeXConference    = @"x-conference";
