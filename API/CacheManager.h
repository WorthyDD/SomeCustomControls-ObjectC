//
//  CacheManager.h
//  card
//
//  Created by Hale Chan on 15/3/24.
//  Copyright (c) 2015年 Tips4app Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"


@interface CacheManager : NSURLCache{
    NSMutableArray *_blockExceiptions;
}

/**
 *  只在wifi下加载图片
 */
@property (nonatomic) BOOL onlyLoadImageWithWifi;
- (void)addImageBlockException:(NSURL *)imageURL;
- (void)clearImageBlockExceiptions;
- (void)removeImageBlockException:(NSURL *)imageURL;

+ (instancetype)sharedCacheManager;

- (void)clearAllCache;
- (NSInteger)currentCacheBytes;
- (NSString *)currentCacheBytesString;
- (NSString *)currentCacheBytesMBString;
- (id)cachedImageForURL:(NSURL *)imageURL;
/**
 *
 *If is gif return the NSData object, otherwise return UIImage object
 */
- (id)cachedImageForRequest:(NSURLRequest *)request;
@end

