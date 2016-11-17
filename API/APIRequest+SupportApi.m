//
//  APIRequest+SupportApi.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/12.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "APIRequest+SupportApi.h"
#import "SessionManager.h"
#import "Tookit.h"

@implementation APIRequest (SupportApis)

+ (APIRequest *)senRigisterCode:(NSString *)phone
{
    APIRequest *request = [[APIRequest alloc]initWithApiPath:[NSString stringWithFormat:@"sendRegistVerifyCode.do?phone=%@", phone] method:APIRequestMethodGet];
    return request;
}

+ (APIRequest *)checkPhoneVertify:(NSString *)phone code:(NSString *)code
{
    APIRequest *request = [[APIRequest alloc]initWithApiPath:@"checkPhoneVerify.do" method:APIRequestMethodGet];
    request.params = @{@"phone" : phone,
                       @"code" : code};
    return request; 
}

+(APIRequest *)loginWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password
{
    APIRequest *request = [[APIRequest alloc]initWithApiPath:@"regist.do" method:APIRequestMethodGet];
    request.params = @{@"phone" : phone,
                       @"code" : code,
                       @"password" : password};
    request.resultObjectClass = [LoginResponseInfo class];
    return request;
}

+ (APIRequest *)loginWithID:(NSString *)phone password:(NSString *)password
{
    APIRequest *request = [[APIRequest alloc]initWithApiPath:@"login.do" method:APIRequestMethodGet];
    request.params = @{@"phone" : phone,
                       @"password" : password};
    request.resultObjectClass = [LoginResponseInfo class];
    return request;
}

+(APIRequest *)indexInfo
{
    APIRequest *request = [[APIRequest alloc]initWithApiPath:@"indexInfo.do" method:APIRequestMethodGet];
    request.resultObjectClass = [IndexInfo class];
    return request;
}

+ (APIRequest *)creditCardStatus
{
    APIRequest *request = [[APIRequest alloc]initWithApiPath:@"applyCredit.do" method:APIRequestMethodGet];
    request.params = @{@"token" : [SessionManager shareManager].loginInfo.token.token};
    request.resultObjectClass = [CreditCardInfo class];
    return request;
}

+ (APIRequest *)uploadMeinfo:(NSDictionary *)params
{
    APIRequest *request = [[APIRequest alloc]initWithApiPath:@"savePersonalInfo.do" method:APIRequestMethodGet];
    request.params = params;
    return request;
}

+ (APIRequest *)uploadContactsInfo:(NSDictionary *)params
{
    APIRequest *request = [[APIRequest alloc]initWithApiPath:@"saveLinkmanInfo.do?" method:APIRequestMethodGet];
    request.params = params;
    return request;
}

+ (APIRequest *)uploadBankCardInfoWithBankName:(NSString *)bankName cardNo:(NSString *)cardNo
{
    APIRequest *request = [[APIRequest alloc]initWithApiPath:@"saveBankCardInfo.do?" method:APIRequestMethodGet];
    request.params = @{@"token" : [SessionManager shareManager].loginInfo.token.token,
                       @"openingBank" : bankName,
                       @"cardNo" : cardNo};
    return request;
}

@end
