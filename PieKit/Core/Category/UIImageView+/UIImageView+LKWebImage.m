//
//  UIImageView+LKWebImage.m
//  Pods
//
//  Created by RoyLei on 16/11/15.
//
//

#import "UIImageView+LKWebImage.h"
#import <YYKit/YYCGUtilities.h>
#import "UIImage+ImageEffects.h"
#import "LKMacros.h"
#import "LSYConstance.h"
#import "UIDevice+LKAdd.h"
#import "UIColor+YYAdd.h"
#import "LKUIHelper.h"

@implementation UIImageView(LKWebImage)

- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
{
    [self lk_setImageFadeWithURLStr:imageURLStr
                   placeholderImage:nil
              supportAnimationImage:YES
                           progress:nil
                          completed:nil];
}

- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder
{
    [self lk_setImageFadeWithURLStr:imageURLStr
                   placeholderImage:placeholder 
              supportAnimationImage:YES
                           progress:nil
                          completed:nil];
}

- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                        querySize:(CGSize)querySize
{
    [self lk_setImageFadeWithURLStr:imageURLStr
                   placeholderImage:nil
                          querySize:querySize
              supportAnimationImage:YES
                          completed:nil];
}

- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                      placeholder:(nullable UIImage *)placeholder
                        querySize:(CGSize)querySize
{
    [self lk_setImageFadeWithURLStr:imageURLStr
                   placeholderImage:placeholder
                          querySize:querySize
              supportAnimationImage:YES
                          completed:nil];
}

- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                 placeholderImage:(nullable UIImage *)placeholder          supportAnimationImage:(BOOL)supportAnimationImage
{
    [self lk_setImageFadeWithURLStr:imageURLStr
                   placeholderImage:placeholder
              supportAnimationImage:supportAnimationImage
                           progress:nil
                          completed:nil];
}

- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                      placeholder:(UIImage *)placeholder
                       completion:(SDExternalCompletionBlock)completion
{
    [self lk_setImageFadeWithURLStr:imageURLStr
                   placeholderImage:placeholder
              supportAnimationImage:YES
                           progress:nil
                          completed:completion];
}

- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr
{
    [self lk_setImageFadeAndBlurWithURLStr:imageURLStr placeholder:nil];
}

- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder
{
    [self lk_setImageFadeAndBlurWithURLStr:imageURLStr
                              compressSize:CGSizeMake(60, 60)
                              compressRate:0.6
                               placeholder:placeholder
                                blurRadius:5
                                 tintColor:UIColorHexAndAlpha(0x000000, 0.4)
                     saturationDeltaFactor:1.1];

}

- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr compressSize:(CGSize)compressSize placeholder:(UIImage *)placeholder
{
    [self lk_setImageFadeAndBlurWithURLStr:imageURLStr
                              compressSize:compressSize
                              compressRate:0.6
                               placeholder:placeholder
                                blurRadius:12
                                 tintColor:UIColorHexAndAlpha(0x000000, 0.4)
                     saturationDeltaFactor:1.1];
}

- (void)lk_setImageFadeAndBlurWithURLStr:(NSString *)imageURLStr
                            compressSize:(CGSize)compressSize
                            compressRate:(CGFloat)compressRate
                             placeholder:(UIImage *)placeholder
                              blurRadius:(CGFloat)blurRadius
                               tintColor:(UIColor *)color
                   saturationDeltaFactor:(CGFloat)saturationDeltaFactor
{
    // 获取对应大小图片（阿里云图片获取规则）
    NSURL *imageURL = [NSURL URLWithString:imageURLStr];
    
    NSString *effectImageURL = [NSString stringWithFormat:@"%@_blur_compressSize_%@_compressRate_%@_radius_%@_color_%@_factor_%@",
                                        NSStringFromCGSize(compressSize),@(compressRate),imageURL.absoluteString, @(blurRadius), [color hexString], @(saturationDeltaFactor)];
    
    UIImage *cacheImage = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:effectImageURL];
    if (cacheImage) {
        self.image = cacheImage;
        return;
    }
    
    WS(weakSelf)
    [self sd_setImageWithURL:imageURL placeholderImage:placeholder options:SDWebImageAvoidAutoSetImage progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *effectImage = nil;
            
            if(image) {
                
                UIImage *compressImage = [LKUIHelper compressByImage:image containerSize:compressSize compressRate:0.6];
                
                effectImage = [compressImage applyBlurWithRadius:blurRadius
                                                       tintColor:color
                                           saturationDeltaFactor:saturationDeltaFactor
                                                       maskImage:nil];
                
               [[SDWebImageManager sharedManager].imageCache storeImage:effectImage forKey:effectImageURL completion:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (effectImage) {
                    [weakSelf doanimationWithImage:effectImage placeholder:placeholder];
                }
            });
            
        });
        
    }];
}

- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                 placeholderImage:(nullable UIImage *)placeholder
            supportAnimationImage:(BOOL)supportAnimationImage
                         progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                        completed:(nullable SDExternalCompletionBlock)completedBlock
{
    NSURL *imageURL = [NSURL URLWithString:imageURLStr];
    
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imageURLStr]];
    UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];

    if (lastPreviousCachedImage) {
        
        if(supportAnimationImage == NO && lastPreviousCachedImage.images.count) {
            [self setImage:lastPreviousCachedImage.images.firstObject];
        }else {
            [self setImage:lastPreviousCachedImage];
        }
        
    }else {
        @weakify(self)
        [self sd_setImageWithURL:imageURL placeholderImage:placeholder options:0 progress:progressBlock completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable backImageURL) {
            @strongify(self)
            
            if(supportAnimationImage == NO && image.images.count) {
                image = image.images.firstObject;
            }
            
            if (![UIDevice isOlderThaniPhone5s] && cacheType == SDImageCacheTypeNone && image) {
                [self doanimationWithImage:image placeholder:placeholder];
            }
            
            if (completedBlock) {
                completedBlock(image, error, cacheType, backImageURL);
            }
        }];
    }
}

- (void)lk_setImageFadeWithURLStr:(NSString *)imageURLStr
                 placeholderImage:(nullable UIImage *)placeholder
                        querySize:(CGSize)querySize
            supportAnimationImage:(BOOL)supportAnimationImage
                        completed:(nullable SDExternalCompletionBlock)completedBlock
{
    
    NSString *tmpURLString = nil;
    CGSize imageSize = querySize;
    
    if(imageSize.width <= 0.0f || imageSize.height <= 0.0f) {
        
        tmpURLString = imageURLStr;
    }else {
        
        UIScreen *mainScreen = [UIScreen mainScreen];

        if ([mainScreen respondsToSelector:@selector(nativeScale)]) {
            imageSize.width = imageSize.width * mainScreen.nativeScale;
            imageSize.height = imageSize.height * mainScreen.nativeScale;
        }else {
            imageSize.width = imageSize.width * mainScreen.scale;
            imageSize.height = imageSize.height * mainScreen.scale;
        }

        tmpURLString = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_%@,w_%@",
                                                    imageURLStr,
                                                    @(ceil(imageSize.height)), @(ceil(imageSize.width))];
    }

    // 获取对应大小图片（阿里云图片获取规则）
    NSURL *processUrl = [NSURL URLWithString:tmpURLString];
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:processUrl];
    UIImage *cacheImage = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:key];
    
    
    if (cacheImage) {
        
        if(supportAnimationImage == NO && cacheImage.images.count) {
            [self setImage:cacheImage.images.firstObject];
        }else {
            [self setImage:cacheImage];
        }
        return;
    }
    
    @weakify(self)
    [self sd_setImageWithURL:processUrl placeholderImage:placeholder options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable backImageURL) {
        @strongify(self)
        
        
        if(supportAnimationImage == NO && cacheImage.images.count) {
            image = image.images.firstObject;
        }
        
        if (![UIDevice isOlderThaniPhone5s] && cacheType == SDImageCacheTypeNone && image) {
            [self doanimationWithImage:image placeholder:placeholder];
        }
        
        if(!image){
            [self setImage:placeholder];
        }
        
        if (completedBlock) {
            completedBlock(image, error, cacheType, backImageURL);
        }
    }];
}

- (void)lk_setBlackHeaderWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder
{
    NSURL *imageURL = [NSURL URLWithString:imageURLStr];
    
    NSString *effectImageURL = [NSString stringWithFormat:@"%@_black_header_effect", imageURL.absoluteString];
    UIImage *cacheImage = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:effectImageURL];
    if (cacheImage) {
        self.image = cacheImage;
        return;
    }
    
    @weakify(self)
    [self sd_setImageWithURL:imageURL placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        @strongify(self)
        
        UIImage *effectImage = nil;
        if(image) {
            effectImage = [image lk_convertImageToGreyScale];
            [[SDWebImageManager sharedManager].imageCache storeImage:effectImage forKey:effectImageURL completion:nil];
        }
        
        if (![UIDevice isOlderThaniPhone5s] && cacheType == SDImageCacheTypeNone && image) {
            [self doanimationWithImage:image placeholder:placeholder];
        }
        
    }];
}

#pragma mark - Private Helper Mathods

/**
 * @brief clip the cornerRadius with image, UIImageView must be setFrame before, no off-screen-rendered
 */
- (UIImage *)lk_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType
{
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return nil;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];

    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = processedImage;
    
    return processedImage;
}

- (void)doanimationWithImage:(UIImage *)image placeholder:(UIImage *)placeholder
{
    [self.layer removeAllAnimations];
    
    if (placeholder) {
        
        CABasicAnimation *contentsAnimation = (CABasicAnimation *)[self.layer animationForKey:@"lk_contentsAnimation"];
        if (!contentsAnimation) {
            contentsAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
            contentsAnimation.fromValue = (__bridge id)placeholder.CGImage;
            contentsAnimation.toValue = (__bridge id)image.CGImage;
            contentsAnimation.duration = 0.3f;
            contentsAnimation.removedOnCompletion = YES;
            contentsAnimation.fillMode = kCAFillModeForwards;
            self.layer.contents = (__bridge id)image.CGImage;
            [self.layer addAnimation:contentsAnimation forKey:@"lk_contentsAnimation"];
        }
        
    }else {
        
        CABasicAnimation *transitionAnimation = (CABasicAnimation *)[self.layer animationForKey:@"LKImageFadeAnimationKey"];
        if (!transitionAnimation) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [self.layer addAnimation:transition forKey:@"LKImageFadeAnimationKey"];
        }
    }
    
    self.image = image;
}

#pragma mark - 获取当前ImageView尺寸

- (NSInteger)lk_imageFitHeight
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    NSInteger height = self.frame.size.height;
    
    if (height <= 0) {
        return 0;
    }
    
    if ([mainScreen respondsToSelector:@selector(nativeScale)]) {
        height = self.frame.size.height * mainScreen.nativeScale;
    }else {
        height = self.frame.size.height * [mainScreen scale];
    }
    
    return height;
}

- (NSInteger)lk_imageFitWidth
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    NSInteger width = self.frame.size.width;
    
    if (width <= 0) {
        return 0;
    }
    
    if ([mainScreen respondsToSelector:@selector(nativeScale)]) {
        width = self.frame.size.width * mainScreen.nativeScale;
    }else {
        width = self.frame.size.width * [mainScreen scale];
    }
    
    return width;
}


@end
