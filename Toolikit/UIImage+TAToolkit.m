//
//  UIImage+TAToolkit.m
//  TAToolkit
//
//  Created by Hale Chan on 14-6-30.
//  Copyright (c) 2014年 Tips4app Inc. All rights reserved.
//

#import "UIImage+TAToolkit.h"
#import "CGGeometry+TAUIToolkit.h"

@implementation UIImage (TAToolkit)
+ (UIImage *)gradientImageWithColors:(NSArray *)colors locations:(NSArray *)imageLocations size:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, size.width * scale, size.height * scale, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    
    NSUInteger count = colors.count;
    
    CGFloat locations[count];
    int i = 0;
    for (NSNumber *location in imageLocations) locations[i++] = [location floatValue];
    
    CFMutableArrayRef colorArray = CFArrayCreateMutable(kCFAllocatorDefault, count, &kCFTypeArrayCallBacks);
    for (UIColor *color in colors) CFArrayAppendValue(colorArray, color.CGColor);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorArray, locations);
    
    CFRelease(colorArray);
    
    startPoint.x *= size.width;
    startPoint.y *= -1.0 * size.height;
    
    endPoint.x *= size.width;
    endPoint.y *= -1.0 * size.height;
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(context);
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    
    return image;
    
}

+ (UIImage*)imagewithLayeredImages:(NSArray*) imageArrays size:(CGSize)size{
    //    CGFloat scale = [[UIScreen mainScreen] scale];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    for(UIImage* image in imageArrays){
        CGContextDrawImage(context, rect, image.CGImage);
    }
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(context);
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    return image;
}

// add the methods to change the image color by GM

- (UIImage *) imageWithTintColor:(UIColor *)tintColor {
    
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor {
    
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

- (UIImage *)resizeToSize:(CGSize)size
{
    return [self resizeToSize:size contentFillMode:TAImageContentFillModeScaleToFill scale:self.scale];
}

//- (UIImage *)resizeToMaxSize:(CGFloat)maxSize
//{
//    CGFloat width  = self.size.width;
//    CGFloat height = self.size.height;
//    CGFloat newWidth, newHeight;
//    if (width > maxSize || height > maxSize) {
//        if (width > height) {
//            newWidth = maxSize;
//            newHeight = height * newWidth / width;
//        }else{
//            newHeight = maxSize;
//            newWidth = width * newHeight / height;
//        }
//        return [self resizeToSize:CGSizeMake(newWidth, newHeight)];
//    }else{
//        return self;
//    }
//    
//}

- (UIImage *)resizeToSize:(CGSize)size contentFillMode:(TAImageContentFillMode)fillMode
{
    return [self resizeToSize:size contentFillMode:fillMode scale:self.scale];
}

- (UIImage *)resizeToSize:(CGSize)size contentFillMode:(TAImageContentFillMode)fillMode scale:(CGFloat)scale
{
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGRect imageRect = {.origin = CGPointZero, .size = size};
    [self drawInRect:imageRect contentFillMode:fillMode clipToBounds:YES];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)grayscaleImage
{
    UIImage *sourceImage = self;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil,width,height,8,0,colorSpace,kCGBitmapByteOrderDefault);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return grayImage;
}

+ (UIImage *)imageWithSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius color:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [color set];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
    [path fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageWithMaxSize:(CGFloat)maxSize
{
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat originMaxSize = w > h ? w : h;
    if(originMaxSize > maxSize){

        CGFloat newW = maxSize;
        CGFloat newH = newW * h / w;
        if(newH > maxSize){
            newH = maxSize;
            newW = newH * w / h;
        }
        CGSize size = CGSizeMake(newW, newH);
        float scale = newH / h;
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        transform = CGAffineTransformScale(transform, scale, scale);
        CGContextConcatCTM(context, transform);
        
        // Draw the image into the transformed context and return the image
        [self drawAtPoint:CGPointMake(0.0f, 0.0f)];
        UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newimg;
    }else{
        return  self;
    }
}

- (void)drawInRect:(CGRect)rect contentFillMode:(TAImageContentFillMode)mode clipToBounds:(BOOL)clip
{
    if (self.size.width <= 0 || self.size.height <=0 || rect.size.width <= 0 || rect.size.height <=0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return;
    }
    
    CGContextSaveGState(context);
    
    if (clip) {
        CGContextClipToRect(context, rect);
    }
    
    CGRect targetRect;
    switch (mode) {
        case TAImageContentFillModeScaleToFill:{
            targetRect = rect;
        }
            break;
            
        case TAImageContentFillModeScaleAspectFit:{
            CGSize s0 = self.size;
            CGFloat h1 = rect.size.width / s0.width * s0.height;
            if (h1 > rect.size.height) {
                targetRect.size.height = rect.size.height;
                targetRect.size.width = rect.size.height * s0.width / s0.height;
                targetRect.origin.y = rect.origin.y;
                CGRectRefSetCenterX(&targetRect, CGRectGetMidX(rect));//centerX
            }
            else{
                targetRect.size.width = rect.size.width;
                targetRect.size.height = h1;
                targetRect.origin.x = rect.origin.x;
                CGRectRefSetCenterY(&targetRect, CGRectGetMidY(rect));//centerY
            }
        }
            break;
        case TAImageContentFillModeScaleAspectFill:{
            CGSize s0 = self.size;
            CGFloat h1 = rect.size.width / s0.width * s0.height;
            if (h1 >= rect.size.height) {
                targetRect.size.width = rect.size.width;
                targetRect.size.height = h1;
                targetRect.origin.x = rect.origin.x;
                CGRectRefSetCenterY(&targetRect, CGRectGetMidY(rect));//centerY
            }
            else{
                targetRect.size.height = rect.size.height;
                targetRect.size.width = rect.size.height * s0.width / s0.height;
                targetRect.origin.y = rect.origin.y;
                CGRectRefSetCenterX(&targetRect, CGRectGetMidX(rect));//centerX
            }
        }
            break;
        case TAImageContentFillModeRedraw:{
            targetRect = rect;
        }
            break;
        case TAImageContentFillModeCenter:{
            targetRect.size = self.size;
            CGRectRefSetCenter(&targetRect, CGRectGetCenter(rect));
        }
            break;
        case TAImageContentFillModeTop:{
            targetRect.size = self.size;
            CGRectRefSetCenterX(&targetRect, CGRectGetMidX(rect));//centerX
            targetRect.origin.y = rect.origin.y;//top
        }
            break;
        case TAImageContentFillModeBottom:{
            targetRect.size = self.size;
            CGRectRefSetCenterX(&targetRect, CGRectGetMidX(rect));//centerX
            CGRectRefSetMaxY(&targetRect, CGRectGetMaxY(rect));//bottom
        }
            break;
        case TAImageContentFillModeLeft:{
            targetRect.size = self.size;
            targetRect.origin.x = rect.origin.x;//left
            CGRectRefSetCenterY(&targetRect, CGRectGetMidY(rect));//centerY
        }
            break;
        case TAImageContentFillModeRight:{
            targetRect.size = self.size;
            CGRectRefSetMaxX(&targetRect, CGRectGetMaxX(rect));//right
            CGRectRefSetCenterY(&targetRect, CGRectGetMidY(rect));//centerY
        }
            break;
        case TAImageContentFillModeTopLeft:{
            targetRect.size = self.size;
            targetRect.origin = rect.origin;
        }
            break;
        case TAImageContentFillModeTopRight:{
            targetRect.size = self.size;
            CGRectRefSetMaxX(&targetRect, CGRectGetMaxX(rect));//right
            targetRect.origin.y = rect.origin.y;//top
        }
            break;
        case TAImageContentFillModeBottomLeft:{
            targetRect.size = self.size;
            CGRectRefSetX(&targetRect, rect.origin.x);//left
            CGRectRefSetMaxY(&targetRect, CGRectGetMaxY(rect));//bottom
        }
            break;
        case TAImageContentFillModeBottomRight:{
            targetRect.size = self.size;
            CGRectRefSetMaxX(&targetRect, CGRectGetMaxX(rect));//right
            CGRectRefSetMaxY(&targetRect, CGRectGetMaxY(rect));//bottom
        }
            break;
            
        default:
            break;
    }
    
    [self drawInRect:targetRect];
    
    CGContextRestoreGState(context);
}

- (UIImage *)roundImageWithRadius:(CGFloat)radius contentFillMode:(TAImageContentFillMode)mode borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIImage *resultImage;
    CGRect rect = CGRectZero;
    rect.size.width = radius * 2;
    rect.size.height = radius * 2;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(radius*2, radius*2), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, YES);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [self drawInRect:rect contentFillMode:mode clipToBounds:YES];
    
    if (borderWidth > 0 && borderColor) {
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, borderWidth+0.5);
        CGContextStrokeEllipseInRect(context, rect);
    }
    
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage *)generateBarcodeImageWithString:(NSString *)string width:(CGFloat)width
{
    UIImage *image = [[UIImage alloc] init];
    if( string == nil ) return image;

    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
   
    //默认生成的图片非常模糊
    image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:width];
    return image;

}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
