//
//  UIButton+Block.m
//  cinderella
//
//  Created by Heller on 15/7/10.
//  Copyright (c) 2015年 Laka inc. All rights reserved.
//

#import "UIButton+Block.h"
#import "UIControl+YYAdd.h"
#import <objc/runtime.h>

@implementation UIButton (Block)

- (void)addClickBlock:(TouchUpInsideBlock)block
{
    [self addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (block) {
            block(sender);
        }
    }];
}

- (void)setUserData:(id)userData
{
    objc_setAssociatedObject(self, @"user_data", userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC | OBJC_ASSOCIATION_ASSIGN);
}

- (id)getUserData
{
    return objc_getAssociatedObject(self, @"user_data");
}


- (void)setUserIndex:(id)index
{
    objc_setAssociatedObject(self, @"index", index, OBJC_ASSOCIATION_RETAIN_NONATOMIC | OBJC_ASSOCIATION_ASSIGN);
}

- (id)getUserIndex
{
    return objc_getAssociatedObject(self, @"index");
}

- (void)setUserData:(id)userData key:(NSString *)key
{
    objc_setAssociatedObject(self, [key UTF8String], userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC | OBJC_ASSOCIATION_ASSIGN);
}

- (id)getUserData:(NSString *)key
{
    return objc_getAssociatedObject(self, [key UTF8String]);
}

@end
