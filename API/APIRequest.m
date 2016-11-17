//
//  APIRequest.m
//  wybxg
//
//  Created by Hale Chan on 15/3/13.
//  Copyright (c) 2015年 Tips4app Inc. All rights reserved.
//

#import "APIRequest.h"
#import "MineType.h"

@implementation APIRequest


- (instancetype)initWithApiPath:(NSString *)apiPath method:(APIRequestMethod)method
{
    self = [super init];
    if (self) {
        _method = method;
        _apiPath = [apiPath copy];
    }
    return self;
}

@end

@implementation APIUploadFile

- (NSString *)mineType
{
    if (!_mineType.length) {
        NSString *ext;
        if (_filePath.length) {
            ext = [_filePath pathExtension];
        }
        if (!ext.length) {
            ext = [_fileName pathExtension];
        }
        if (ext.length) {
            MineType *mineType = [MineType mineTypeForExtension:ext];
            if (mineType) {
                _mineType = [NSString stringWithFormat:@"%@/%@", mineType.type, mineType.subType];
            }
        }
    }
    return _mineType;
}

- (NSString *)name
{
    if (!_name.length) {
        if (_filePath.length) {
            _name = [[_filePath lastPathComponent] stringByDeletingPathExtension];
        }
        else {
            _name = [_fileName stringByDeletingPathExtension];
        }
    }
    return _name;
}

- (NSString *)fileName
{
    if (!_fileName.length) {
        if (_filePath.length) {
            _fileName = [_filePath lastPathComponent];
        }
    }
    return _fileName;
}

- (instancetype)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        _filePath = filePath;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name fileName:(NSString *)fileName data:(NSData *)data mineType:(NSString *)mineType
{
    self = [super init];
    if (self) {
        _name = name;
        _fileName = fileName;
        _data = data;
        _mineType = mineType;
    }
    return self;
}

@end
