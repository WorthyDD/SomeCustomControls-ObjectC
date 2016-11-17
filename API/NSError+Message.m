//
//  NSError+Message.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/10/10.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "NSError+Message.h"

@implementation NSError (Message)

- (NSString *)errorMsg
{
    return self.userInfo[@"msg"];
}
@end
