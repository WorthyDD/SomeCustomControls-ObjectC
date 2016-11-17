//
//  APIRequest+SupportApi.h
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/12.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "APIRequest.h"
#import "APIObjects.h"

@interface APIRequest (SupportApis)

/**
 *  发送短信验证码
 */
+ (APIRequest *) senRigisterCode : (NSString *)phone;

/**
 *  注册验证
 */
+ (APIRequest *) checkPhoneVertify : (NSString *)phone code : (NSString *)code;

/**
 *  注册登录
 */
+ (APIRequest*) loginWithPhone : (NSString *)phone code : (NSString *)code password : (NSString *)password;

/**
 *  登录
 */

+ (APIRequest *) loginWithID : (NSString *)phone password : (NSString *)password;

/**
 *  首页信息
 */
+ (APIRequest *)indexInfo;

/**
 *  授权信息查询
 */
+ (APIRequest *)creditCardStatus;

/**
 *  身份信息提交接口
 */
+ (APIRequest *)uploadMeinfo : (NSDictionary *)params;

/**
 *  上传联系人资料
 */
+(APIRequest *)uploadContactsInfo : (NSDictionary *)params;

/**
 *   银行卡提交接口
 */
+ (APIRequest *) uploadBankCardInfoWithBankName : (NSString *)bankName cardNo : (NSString *)cardNo;

@end
