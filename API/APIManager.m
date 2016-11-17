//
//  APIManager.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/8/30.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "APIManager.h"
#import "SessionManager.h"
#import "constant.h"

NSString *const baseURL = @"http://115.28.128.169:8080/";
NSString *const kAPIRequestOperationManagerErrorInfoMessageKey = @"message";
NSString *const kAPIRequestOperationManagerErrorInfoServerCodeKey = @"serverCode";
NSString *const kAPIRequestOperationManagerErrorInfoServerDataKey = @"serverData";

@implementation APIManager

+ (instancetype)shareManager
{
    static APIManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[APIManager alloc]initWithBaseURL:[NSURL URLWithString:baseURL]];

        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//        [manager.requestSerializer setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"content-type"];
        //监测网络状态
        NSOperationQueue *operationQueue = manager.operationQueue;
        [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    [operationQueue setSuspended:YES];
                    break;
            }
        }];
        [manager.reachabilityManager startMonitoring];
        
    });
    return manager;
}

- (BOOL)isOffline
{
    return self.operationQueue.isSuspended;
}


- (NSURLSessionDataTask *) requestWithAPI : (APIRequest *)request completion : (void(^)(NSInteger code, id result, NSString *msg))completion
{
    NSURLSessionDataTask *task = nil;
    if(self.isOffline) {
        NSString *msg = @"网络故障或服务器故障";
        completion(-1, nil, msg);
        return task;
    }
    
    void (^success)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if(code == -2){
            [[SessionManager shareManager] clearSession];
            [SessionManager shareManager].isLogin = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNeedLoginNotification object:nil];
            completion(-2, nil, msg);
        }
        else if(code == -1){
            completion(-1, nil, msg);
        }
        else if(code == 1){
            
            id data = [responseObject objectForKey:@"data"];
            id result = data;
            
            //如果json是数组
            if([result isKindOfClass:[NSArray class]]){
                NSArray *jsonArr = result;
                NSMutableArray *arr = [NSMutableArray new];
                for(id element in jsonArr){
                    id item = [request.resultObjectClass objectWithJson:element];
                    if(item){
                        [arr addObject:item];
                    }
                }
                result = [NSArray arrayWithArray:arr];
            }
            else if(request.resultObjectClass){
                result = [request.resultObjectClass objectWithJson : result];
            }
            completion(1, result, msg);
        }
        
    };
    
    void (^failure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"err--%@", error.description);
        completion(-1, nil, @"网络故障或服务器故障");
    };
    
    switch(request.method){
        case APIRequestMethodGet:{
            task = [self GET:request.apiPath parameters:request.params progress:nil success:success failure:failure];

            break;
        }
        case APIRequestMethodPost:{
            task = [self POST:request.apiPath parameters:request.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:nil success:success
            failure:failure];

            break;
        }
        case APIRequestMethodPut:{
            task = [self PUT:request.apiPath parameters:request.params success:success failure:failure];
            break;
        }
    }
    return task;
}


- (NSURLSessionDataTask *) UploadFileWithAPIWithPath : (NSString *)apiPath params : (NSDictionary *)params files : (NSArray<APIUploadFile *> *) files progress: (void(^)(NSInteger progress))progress completion:(void (^)(NSInteger, id, NSString *))completion{
    NSURLSessionDataTask *task = nil;
    if(self.isOffline) {
        completion(-1, nil, @"网络故障或服务器故障");
        return task;
    }
    
    task = [self POST:apiPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for(APIUploadFile *uploadFile in files){
            NSData *data = uploadFile.data;
            if (!data) {
                if (uploadFile.filePath) {
                    data = [NSData dataWithContentsOfFile:uploadFile.filePath];
                }
            }
            if (data) {
                [formData appendPartWithFileData:data name:uploadFile.name fileName:uploadFile.fileName mimeType:uploadFile.mineType];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSInteger percentage = uploadProgress.completedUnitCount/((double)uploadProgress.totalUnitCount)*100;
        progress(percentage);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if(code == -2){
            [[SessionManager shareManager] clearSession];
            [SessionManager shareManager].isLogin = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNeedLoginNotification object:nil];
            completion(-2, nil, msg);
        }
        else if(code == -1){
            completion(-1, nil, msg);
        }
        else if(code == 1){
            
            id data = [responseObject objectForKey:@"data"];
            completion(1, data, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(-1, nil, @"网络故障或服务器故障");
    }];
    return task;
}

@end

