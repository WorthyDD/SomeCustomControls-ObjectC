//
//  APIRequest.h
//  wybxg
//
//  Created by Hale Chan on 15/3/13.
//  Copyright (c) 2015年 Tips4app Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

typedef NS_ENUM(NSInteger, APIRequestMethod) {
    APIRequestMethodGet,
    //APIRequestMethodHead,
    APIRequestMethodPost,
    APIRequestMethodPut,
    //APIRequestMethodPatch,
    //APIRequestMethodDelete
};


/**
 *  API参数构造器
 */
@interface APIRequest : NSObject

/**
 *  请求方式
 */
@property (nonatomic) APIRequestMethod method;

/**
 *  API路径
 */
@property (nonatomic, copy) NSString *apiPath;


/**
 *  放到URL里的参数
 */
@property (nonatomic, copy) NSDictionary *params;

/**
 *  API请求完成后，需要将返回数据解析成的对象类型
 */
@property (nonatomic, strong) Class<BaseObject> resultObjectClass;


/**
 *  初始化一个APIRequest
 *
 *  @param apiPath api路径
 *  @param method  HTTP请求方法
 *
 *  @return 一个初始化的APIRequest
 */
- (instancetype)initWithApiPath:(NSString *)apiPath method:(APIRequestMethod)method NS_DESIGNATED_INITIALIZER;

@end


/**
 *  上传文件
 */
@interface APIUploadFile : NSObject

/**
 *  表单中的名字
 */
@property (nonatomic, copy) NSString *name;

/**
 *  上传的文件数据
 */
@property (nonatomic) NSData *data;

/**
 *  上传的文件路径  跟文件数据二者选其一  data优先
 */
@property (nonatomic, copy) NSString *filePath;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *fileName;
/**
 *  MINE类型，如果不指定，则根据fileName和fileURL推断
 */
@property (nonatomic, copy) NSString *mineType;

- (instancetype)initWithFilePath:(NSString *)filePath;
- (instancetype)initWithName:(NSString *)name fileName:(NSString *)fileName data:(NSData *)data mineType:(NSString *)mineType;

@end
