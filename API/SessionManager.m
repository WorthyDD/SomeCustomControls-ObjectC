//
//  SessionManager.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/10/10.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "SessionManager.h"
#import "constant.h"
#import <MBProgressHUD.h>
#import <SVProgressHUD.h>

@implementation SessionManager

+ (instancetype)shareManager
{
    static SessionManager *shareManager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareManager = [[SessionManager alloc]init];
        shareManager.isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kloginStatusBOOLKey];
        [shareManager readUserInfo];
        shareManager.constantModel = [[ConstantsModel alloc]init];
    });
    return shareManager;
}


- (void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:kloginStatusBOOLKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (void)clearSession
{
    self.isLogin = NO;
    self.loginInfo = nil;
    NSURL *url = [NSURL URLWithString:baseURL];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

- (void)loginWithPhone:(NSString *)phone password:(NSString *)password code:(NSString *)code completion:(void (^)(BOOL, NSString *))callback
{
    WEAK_OBJ_REF(self);
    APIRequest *request = [APIRequest loginWithPhone:phone code:code password:password];
    [[APIManager shareManager] requestWithAPI:request completion:^(NSInteger code, id result, NSString *msg) {
        
        if(result){
            LoginResponseInfo *info = result;
            weak_self.loginInfo = info;
            weak_self.isLogin = YES;
            [weak_self saveUserInfo];
            callback(YES, msg);
        }
        else{
            callback(NO, msg);
        }
    }];
}

- (void)loginWithID:(NSString *)phone password:(NSString *)password completion:(void (^)(BOOL, NSString *))callback
{
    WEAK_OBJ_REF(self);
    
    APIRequest *request = [APIRequest loginWithID:phone password:password];
    [[APIManager shareManager] requestWithAPI:request completion:^(NSInteger code, id result, NSString *msg) {
        
        if(result){
            LoginResponseInfo *info = result;
            weak_self.loginInfo = info;
            weak_self.isLogin = YES;
            [weak_self saveUserInfo];
            callback(YES, msg);
            
            [weak_self reloadCreditCard:nil];
        }
        else{
            callback(NO, msg);
        }
    }];

}

- (void)logoutCurrentUserWithcompletion:(void (^)(BOOL, NSError *))completion
{
    
    self.isLogin = NO;
}

- (void) saveUserInfo
{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingString:@"/login_info"];
    [NSKeyedArchiver archiveRootObject:_loginInfo toFile:path];
}

- (void) readUserInfo{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingString:@"/login_info"];
    self.loginInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (void)uploadPhotos:(NSMutableDictionary<NSString *,NSMutableArray *> *)imgs completion:(void (^)(BOOL, NSString *))callback
{
    __block int index = 1;
    
    for(NSString *key in imgs){
        
        NSMutableArray *arr = imgs[key];
        for(UIImage *img in arr){
            
            if(![img isKindOfClass:[UIImage class]]){
                continue;
            }
            NSData *data = UIImageJPEGRepresentation(img, 1.0);
            APIUploadFile *file = [[APIUploadFile alloc]initWithName:@"picFile" fileName:@"image" data:data mineType:@"jpeg"];
            NSDictionary *params = @{@"token" : [SessionManager shareManager].loginInfo.token.token,
                                     @"type" : key,
                                     @"relId" : @([SessionManager shareManager].loginInfo.user.identifier)};
            
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showWithStatus: [NSString stringWithFormat:@"正在上传照片 %d/%ld", (int)index, imgs.allValues.count]];

            
            [[APIManager shareManager] UploadFileWithAPIWithPath:@"uploadPic.do" params:params files:@[file] progress:^(NSInteger progress) {
                
            } completion:^(NSInteger code, id result, NSString *msg) {
                
                if(code == 1){
                    index++;
                }
                if(code < 0){
                    
                    [SVProgressHUD showErrorWithStatus:msg];
                    callback(NO, msg);
                    return;
                }
                if(index>=imgs.allValues.count){
                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    callback(YES, msg);
                    return;
                }
                
                
            }];
        }
    }
}

- (void)reloadCreditCard:(void (^)(BOOL, NSString *))completion
{
    if(![SessionManager shareManager].loginInfo){
        return;
    }
    
    [SVProgressHUD show];
    WEAK_OBJ_REF(self);
    APIRequest *request = [APIRequest creditCardStatus];
    [[APIManager shareManager] requestWithAPI:request completion:^(NSInteger code, id result, NSString *msg) {
        
        if(code == 1){
            
            [SVProgressHUD dismiss];
            weak_self.creditCardInfo = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoadCreditCardInfoSuccessNiti object:nil];
            if(completion){
                completion(YES, msg);
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:msg];
            if(completion){
                completion(NO, msg);
            }
        }
    }];

}

@end
