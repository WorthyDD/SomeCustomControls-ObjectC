//
//  CacheManager.m
//  card
//
//  Created by Hale Chan on 15/3/24.
//  Copyright (c) 2015年 Tips4app Inc. All rights reserved.
//

#import "CacheManager.h"
#import <UIKit/UIKit.h>
#import "APIManager.h"


@implementation CacheManager

+ (instancetype)sharedCacheManager
{
    static CacheManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CacheManager alloc]initWithMemoryCapacity:4*1024*1024 diskCapacity:512*1024*1024 diskPath:@"com.tips.cache"];
        BOOL justWifi = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.tips4app.setting.onlyLoadImageWithWifi"];
        manager.onlyLoadImageWithWifi = justWifi;
        
    });
    
    return manager;
}

- (void)setOnlyLoadImageWithWifi:(BOOL)onlyLoadImageWithWifi
{
    _onlyLoadImageWithWifi = onlyLoadImageWithWifi;
    [[NSUserDefaults standardUserDefaults] setBool:onlyLoadImageWithWifi forKey:@"com.tips4app.setting.onlyLoadImageWithWifi"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)restoreImageLoadingSetting
{
    _onlyLoadImageWithWifi = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.tips4app.setting.onlyLoadImageWithWifi"];
}

- (NSInteger)currentCacheBytes
{
    return self.currentDiskUsage;
}

- (NSString *)currentCacheBytesString
{
    NSInteger bytes = [self currentCacheBytes];
    
    NSString *result;
    if (bytes >= 1024 * 1024) {
        CGFloat mb = bytes / (1024.0 * 1024.0);
        result = [NSString stringWithFormat:@"%.1fMB", mb];
    }
    else if(bytes >= 1024) {
        CGFloat kb = bytes / 1024.0;
        result = [NSString stringWithFormat:@"%.1fKB", kb];
    }
    else {
        result = [NSString stringWithFormat:@"%dB", (int)bytes];
    }
    
    return result;
}

- (NSString *)currentCacheBytesMBString
{
    NSInteger bytes = [self currentCacheBytes];
    CGFloat mb = bytes/(1024.0*1024.0);
    NSString *result = [NSString stringWithFormat:@"%.1fMB",mb];
    return result;
}

- (void)clearAllCache
{
    [self removeAllCachedResponses];
}

- (void)addImageBlockException:(NSURL *)imageURL
{
    if (!_blockExceiptions) {
        _blockExceiptions = [[NSMutableArray alloc]init];
    }
    if (imageURL) {
        [_blockExceiptions addObject:imageURL];
    }
}

- (void)clearImageBlockExceiptions
{
    [_blockExceiptions removeAllObjects];
}

- (void)removeImageBlockException:(NSURL *)imageURL
{
    [_blockExceiptions removeObject:imageURL];
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];
    if (!cachedResponse) {
        if (self.onlyLoadImageWithWifi &&
            ![APIManager shareManager].reachabilityManager.reachableViaWiFi &&
            ![_blockExceiptions containsObject:request.URL]) {
            NSString *mineType = [self mineTypeForImageRequest:request];
            NSString *accept = request.allHTTPHeaderFields[@"Accept"];
            
            //屏蔽图片
            if ([mineType hasPrefix:@"image/"] ||
                [accept hasPrefix:@"image/"]) {
                
                UIImage *image = [UIImage imageNamed:@"placeholder-big"];
                NSData *data;
                if ([mineType isEqualToString:@"image/png"]) {
                    data = UIImagePNGRepresentation(image);
                }
                else {
                    data = UIImageJPEGRepresentation(image, 1.0);
                    mineType = @"image/jpg";
                }
                
                NSURLResponse *response = [[NSURLResponse alloc]initWithURL:[request URL] MIMEType:mineType expectedContentLength:[data length] textEncodingName:nil];
                cachedResponse = [[NSCachedURLResponse alloc]initWithResponse:response data:data];
            }
        }
    }
    
    return cachedResponse;
}

#pragma mark - 

- (NSString *)mineTypeForImageRequest:(NSURLRequest *)request
{
    NSString *path = [[[request URL] absoluteString] lowercaseString];
    NSString *ext = [path pathExtension];
    NSString *result;
    
    if (!ext.length) {
        result = nil;
    }
    else if ([ext isEqualToString:@"png"] ||
             [ext isEqualToString:@"jpg"] ||
             [ext isEqualToString:@"jpeg"] ||
             [ext isEqualToString:@"gif"]) {
        result = [NSString stringWithFormat:@"image/%@", ext];
    }
    else {
        result = nil;
    }
    
    return result;
}

- (id)cachedImageForRequest:(NSURLRequest *)request
{

    NSCachedURLResponse *cachedResponse = [self cachedResponseForRequest:request];
    NSString *mineType = cachedResponse.response.MIMEType;
    UIImage *image;
    if ([mineType isEqualToString:@"image/png"] ||
        [mineType isEqualToString:@"image/jpg"] ||
        [mineType isEqualToString:@"image/jpeg"]) {
        image = [UIImage imageWithData:cachedResponse.data];
    }else if ([mineType isEqualToString:@"image/gif"]){
        return cachedResponse.data;
    }
    return image;
}


- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    //TODO  this save func could resave the data to the save File
//    NSData *data;
//    NSString *mineType = [self mineTypeForImageRequest:request];
//    NSLog(@"yyyyyyyyy cacheImage type %@ %@", image,request.URL);
//    //暂时只支持png与jpg，gif可能会出问题
//    if ([mineType isEqualToString:@"image/gif"]) {
//        return;
//    }else
//    if ([mineType isEqualToString:@"image/png"]) {
//        data = UIImagePNGRepresentation(image);
//    }
//    else {
//        mineType = @"image/jpg";
//        data = UIImageJPEGRepresentation(image, 1.0);
//    }
//    
//    NSURLResponse *response = [[NSURLResponse alloc]initWithURL:request.URL MIMEType:mineType expectedContentLength:[data length]textEncodingName:nil];
//    NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc]initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
//    [self storeCachedResponse:cachedResponse forRequest:request];
}

- (id)cachedImageForURL:(NSURL *)imageURL
{
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    return [self cachedImageForRequest:request];
}

@end
