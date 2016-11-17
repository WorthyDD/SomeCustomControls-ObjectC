//
//  MineType.h
//  TurboUDisk
//
//  Created by Hale Chan on 15/1/8.
//  Copyright (c) 2015年 Tips4app Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineType : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *subType;
@property (nonatomic, readonly) NSArray *extensions;

+ (NSArray *)supportedMineTypes;
+ (instancetype)mineTypeForExtension:(NSString *)ext;

@end

extern NSString *const kMineTypeApplication;
extern NSString *const kMineTypeAudio;
extern NSString *const kMineTypeChemical;
extern NSString *const kMineTypeImage;
extern NSString *const kMineTypeMessage;
extern NSString *const kMineTypeModel;
extern NSString *const kMineTypeText;
extern NSString *const kMineTypeVideo;
extern NSString *const kMineTypeXConference;
