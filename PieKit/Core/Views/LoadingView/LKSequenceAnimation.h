//
//  LKSequenceLoadingAnimation.h
//  LKNovelty
//
//  Created by Pie on 17/3/31.
//  Copyright © 2017年 Laka. All rights reserved.
//

#import "LKLoadingAnimationProtocol.h"
#import <YYKit/YYFrameImage.h>

typedef NS_ENUM(NSInteger, LKSequenceAnimationType) {
   LKSequenceAnimationSmall = 0,
   LKSequenceAnimationBig = 1,
};

@interface LKSequenceAnimation : NSObject <LKLoadingAnimationProtocol>
- (void)initImageViewUI:(UIView*)baseView;
@property (assign, nonatomic) LKSequenceAnimationType lineType;
@end

