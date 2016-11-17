//
//  SessionManager.h
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/10/10.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIFramework.h"

@interface SessionManager : NSObject


@property (nonatomic, assign) BOOL isLogin;     //登录状态
@property (nonatomic) LoginResponseInfo *loginInfo;
@property (nonatomic) ConstantsModel *constantModel;    //常量数组
@property (nonatomic) CreditCardInfo *creditCardInfo;   //申请授信状态

+ (instancetype) shareManager;

/**
 *  用户名 密码 登录
 */
- (void) loginWithPhone : (NSString *)phone password : (NSString *)password code : (NSString *)code completion : (void(^)(BOOL success, NSString *msg)) callback;

/**
 *  二次登录  电话密码
 */
- (void) loginWithID : (NSString *)phone password : (NSString *)password completion :(void(^)(BOOL success, NSString *msg)) callback;

/**
 *  退出登录
 */
- (void) logoutCurrentUserWithcompletion : (void(^)(BOOL success, NSError *error)) completion;

/**
 *  清除本地cookie
 */
- (void) clearSession;

/**
 *  上传图片
 */
- (void) uploadPhotos : (NSMutableDictionary<NSString *, NSMutableArray*> *) imgs completion : (void(^)(BOOL success, NSString *msg)) callback;

- (void) reloadCreditCard : (void(^)(BOOL success, NSString *msg))completion;

@end
