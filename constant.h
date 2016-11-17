//
//  constant.h
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/5.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tookit.h"

#ifndef constant_h
#define constant_h

#define WEAK_OBJ_REF(obj) __weak typeof(obj) weak_##obj = obj
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define KEY_WINDOW [UIApplication sharedApplication].keyWindow
#define THEME_COLOR [UIColor colorWithRGB:0x30c9c2]
#define default_avatar_img [UIImage imageNamed : @"default-img"]


//通知变量定义区
#define kLoginSuccessNotification @"login_success"
#define kLogoutSuccessNotification @"logout_success"
#define kNeedLoginNotification @"need_login_notification"
#define kloginStatusBOOLKey @"login_status_bool_key"
#define kLoadCreditCardInfoSuccessNiti @"load_creditCard_success_noti"


#define COLOR_666666 [UIColor colorWithRGB:0x666666]
#define COLOR_333333 [UIColor colorWithRGB:0x333333]
#define COLOR_999999 [UIColor colorWithRGB:0x999999]
#define COLOR_F1F1F1 [UIColor colorWithRGB:0xf1f1f1]
#define COLOR_C7C7C7 [UIColor colorWithRGB:0xc7c7c7]
#define COLOR_DDDDDD [UIColor colorWithRGB:0xdddddd]
#define COLOR_BBBBBB [UIColor colorWithRGB:0xbbbbbb]
#define COLOR_F4F4F4 [UIColor colorWithRGB:0xf4f4f4]

#define SUCCESS_STATUS  1
#define ERROR_STATUS -1
#define NEED_LOGIN_STATUS -2


#endif /* constant_h */
