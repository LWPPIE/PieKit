//
//  LKUIHelper.m
//  Live
//
//  Created by RoyLei on 2017/5/26.
//  Copyright © 2017年 LaKa. All rights reserved.
//

#import "LKUIHelper.h"
#import "LKCacheManager.h"
#import "LVUIUtils.h"
#import "UIImage+ImageEffects.h"
#import "YYWebImageManager.h"
#import "UIColor+YYAdd.h"
#import "UIImage+YYAdd.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"

NSString *const LKAvatarPlacehodlerBlurImage =  @"LKAvatarPlacehodlerBlurImage"; //头像默认图模糊化图片

@implementation LKUIHelper

+ (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, image.scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)compressByImage:(UIImage *)image
{
    CGSize compareSize = CGSizeMake(720.0, 1280.0);
    if (image.scale <= 1) {
        compareSize = CGSizeMake(720.0, 1280.0);
    }else if (image.scale == 2) {
        compareSize = CGSizeMake(480.0, 640.0);
    }else if (image.scale >= 3) {
        compareSize = CGSizeMake(320.0, 480.0);
    }
    
    return [self compressByImage:image containerSize:compareSize compressRate:0.75];
}

+ (UIImage *)compressForBlurByImage:(UIImage *)image
{
    return [self compressByImage:image containerSize:CGSizeMake(320.0, 568.0) compressRate:0.6];
}

+ (UIImage *)compressByImage:(UIImage *)image
               containerSize:(CGSize)defaultSize
                compressRate:(CGFloat)compressRate
{
    if (!image) {
        return nil;
    }
    
    CGSize imageSize = image.size;
    
    CGFloat defaulWidth  = defaultSize.width;
    CGFloat defaulHeight = defaultSize.height;
    CGFloat compressW    = compressRate;
    CGFloat compressH    = compressRate;
    CGFloat compress     = 1.0f;
    
    if (image.size.width >= defaulWidth && image.size.height >= defaulHeight) {
        
        compressW = defaulWidth/image.size.width;
        compressH = defaulHeight/image.size.height;
        compress = MIN(compressW, compressH);
        
    } else if (image.size.width >= defaulHeight && image.size.height >= defaulWidth) {
        
        compressW = defaulHeight/image.size.width;
        compressH = defaulWidth/image.size.height;
        compress = MIN(compressW, compressH);
        
    } else if (image.size.width >= defaulWidth || image.size.width >= defaulHeight ||
               image.size.height >= defaulWidth || image.size.height >= defaulHeight) {
        compress = 0.75;
    }
    
    imageSize = CGSizeMake(imageSize.width * compress, imageSize.height * compress);
    
    //体积压缩
    UIImage *newImage = [LKUIHelper imageWithImage:image scaledToSize:imageSize];
    
    return newImage;
}

+ (UIImage *)getRoundImageWithCutOuter:(BOOL)isCutOuter
                               corners:(UIRectCorner)corners
                                  size:(CGSize)size
                                radius:(CGFloat)radius
                       backgroundColor:(UIColor *)backgroundColor
{
    NSString *saveKey = [NSString stringWithFormat:@"RoundImage:%@_%@_%@_%@_%@_%@",
                         NSStringFromCGSize(size),
                         @(isCutOuter),
                         @(radius),
                         @(corners),
                         @(radius),
                         [backgroundColor hexString]];
    
    UIImage *retImage = (UIImage *)[LKCanCleanCache() objectForKey:saveKey];
    if (retImage) {
        return retImage;
    }else {
        UIView *roundView = [UIView new];
        roundView.backgroundColor = backgroundColor;
        [roundView setFrame:(CGRect){0,0,size.width+2, size.height+2}];
        
        retImage = [LVUIUtils getImageFromView:roundView atFrame:(CGRect){0, 0, size}];
        retImage = [self clipImageWithOriginalImage:retImage
                                           cutOuter:isCutOuter
                                            corners:corners
                                             radius:radius
                                        strokeColor:nil
                                          lineWidth:0];

        [LKCanCleanCache() setObject:retImage forKey:saveKey];
    }

    return retImage;
}

+ (UIImage *)clipImageWithOriginalImage:(UIImage *)origImage
                               cutOuter:(BOOL)isCutOuter
                                corners:(UIRectCorner)corners
                                 radius:(CGFloat)radius
                            strokeColor:(UIColor *)strokeColor
                              lineWidth:(CGFloat)lineWidth
{
    if (!origImage || CGSizeEqualToSize(origImage.size, CGSizeZero)) {
        return nil;
    }
    
    CGRect rect = (CGRect){CGPointZero, origImage.size};
    
    UIBezierPath *roundPath = nil;
    UIBezierPath *clipPath = nil;
    
    if (isCutOuter) {
        clipPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                         byRoundingCorners:corners
                                               cornerRadii:CGSizeMake(radius, radius)];
        roundPath = clipPath;
    }else{
        clipPath = [UIBezierPath bezierPathWithRect:CGRectInfinite];
        roundPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                          byRoundingCorners:corners
                                                cornerRadii:CGSizeMake(radius, radius)];
        [clipPath appendPath:roundPath];
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    {
        clipPath.usesEvenOddFillRule = YES;
        
        if (!isCutOuter) {
            [UIColor.clearColor setFill];
            [roundPath fill];
        }
        
        if (strokeColor) {
            [roundPath setLineWidth:2.0f];
            [strokeColor set];
            [roundPath stroke];
        }
    }
    [clipPath addClip];
    
    [origImage drawInRect:rect];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)avatarDefautBlurImage:(UIImage *)placehodler
                     containerSize:(CGSize)size
                      compressRate:(CGFloat)compressRate
                        blurRadius:(CGFloat)blurRadius
                         tintColor:(UIColor *)tintColor
             saturationDeltaFactor:(CGFloat)saturationDeltaFactor
{
    UIImage *placeholderImage = [[YYWebImageManager sharedManager].cache getImageForKey:LKAvatarPlacehodlerBlurImage
                                                                               withType:YYImageCacheTypeAll];
    if (!placeholderImage) {
        UIImage *compressImage = [LKUIHelper compressByImage:placehodler containerSize:size compressRate:compressRate];
        placeholderImage = [compressImage applyBlurWithRadius:blurRadius
                                                    tintColor:tintColor
                                        saturationDeltaFactor:saturationDeltaFactor
                                                    maskImage:nil];
    }
    
    return placeholderImage;
}

+ (UIImage *)createPlaceHolderWithImage:(UIImage *)centerPlaceHolder
                                   size:(CGSize)size
                                bgColor:(UIColor *)color
{
    if(size.width <= 1.0 || size.height < 1.0){
        return nil;
    }
    
    CGSize originSize = centerPlaceHolder.size;
    
    CGFloat originX = (size.width - originSize.width)/2;
    CGFloat originY = (size.height - originSize.height)/2;
    
    CGRect retRect = CGRectMake(0, 0, size.width, size.height);
    CGRect originRect = CGRectMake(originX, originY, originSize.width, originSize.height);
    
    UIImage *bgImage = [UIImage imageWithColor:color size:size];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [bgImage drawInRect:retRect];
    [centerPlaceHolder drawInRect:originRect];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (UIImage *)createPlaceHolderWithImage:(NSString *)centerPlaceHolderName
                                   size:(CGSize)size
{
    static NSMutableDictionary *cachePlaceholderImages = nil;
    
    UIImage *resultingImage = nil;
    NSString *cacheKey = [NSString stringWithFormat:@"LKUIPlaceHolder_%@_Size_%@",centerPlaceHolderName, NSStringFromCGSize(size)];
    
    if (cachePlaceholderImages) {
        resultingImage = cachePlaceholderImages[cacheKey];
    }else {
        cachePlaceholderImages = [NSMutableDictionary dictionary];
    }
    
    if (!resultingImage) {
        resultingImage = [self createPlaceHolderWithImage:[UIImage imageNamed:centerPlaceHolderName]
                                                     size:size
                                                  bgColor:UIColorHex(0xF4F4F4)];
        if (resultingImage) {
            [cachePlaceholderImages setObject:resultingImage forKey:cacheKey];
        }
    }
    
    return resultingImage;
}

+ (void)downloadImage:(NSString *)imageURLstr
               height:(NSInteger)height
             complete:(void (^)(UIImage *image))complete
{
    NSString *processURLString = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,h_%@", imageURLstr, @(height)];
    
    NSURL *imageURL = [NSURL URLWithString:processURLString];

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager loadImageWithURL:imageURL
                      options:0
                     progress:nil
                    completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
       
                        
                        if(complete) {
                            complete(image);
                        }
                        
                    }];

}

+ (void)downloadShareImage:(NSString *)imageURLStr
                  complete:(void (^)(UIImage *image))complete
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    NSURL *imageURL = [NSURL URLWithString:imageURLStr];
    
    [manager loadImageWithURL:imageURL
                      options:0
                     progress:nil
                    completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                        
                        UIImage *effectImage = [UIImage imageNamed:@"about_app_icon"];
                        if(image) {
                            effectImage = image;
                        }
                        
                        if(complete) {
                            complete(effectImage);
                        }
                        
                    }];
}

@end
