//
//  UnDeallocModels.m
//  TTClub
//
//  Created by RoyLei on 15/8/19.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import "UnDeallocModels.h"

@interface UnDeallocModels ()

@end
@implementation UnDeallocModels

+ (instancetype)shareUnDeallocModels
{
    static dispatch_once_t once;
    static UnDeallocModels *shareDealocModels;
    dispatch_once(&once, ^{
        shareDealocModels = [[UnDeallocModels alloc]init];
    });
    return shareDealocModels;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)unDealocModels
{
    if (!_unDealocModels) {
        _unDealocModels = [[NSMutableArray alloc]init];
    }
    return _unDealocModels;
}

- (void)addContrllerName:(NSString *)controllerName andFloor:(NSInteger)num
{
    if (num > 1) {
        //首页不加入
        if ([[UnDeallocModels shareUnDeallocModels].unDealocModels isKindOfClass:[NSMutableArray class]]) {
            [[UnDeallocModels shareUnDeallocModels].unDealocModels addObject:controllerName];
        } else {
            [UnDeallocModels shareUnDeallocModels].unDealocModels = [NSMutableArray arrayWithArray:[UnDeallocModels shareUnDeallocModels].unDealocModels];
            [[UnDeallocModels shareUnDeallocModels].unDealocModels addObject:controllerName];
        }
    }
}

- (void)deallocControllerName:(NSString *)controllerName andFloor:(NSInteger)num
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[UnDeallocModels shareUnDeallocModels].unDealocModels];
    for (NSString *ctlString in tempArray) {
        if ([ctlString isEqualToString:controllerName]) {
            NSInteger ctlIndex = [tempArray indexOfObjectIdenticalTo:ctlString];
            if ([[UnDeallocModels shareUnDeallocModels].unDealocModels isKindOfClass:[NSMutableArray class]]) {
                [[UnDeallocModels shareUnDeallocModels].unDealocModels removeObjectAtIndex:ctlIndex];
            } else {
                [UnDeallocModels shareUnDeallocModels].unDealocModels = [NSMutableArray arrayWithArray:[UnDeallocModels shareUnDeallocModels].unDealocModels];
                [[UnDeallocModels shareUnDeallocModels].unDealocModels removeObjectAtIndex:ctlIndex];
            }
            break;
        }
    }
    if ([UnDeallocModels shareUnDeallocModels].unDealocModels.count > 0) {
        if (num == 1) {
            //回到首层打印泄露
            NSLog(@"内存泄露对象: %@",[UnDeallocModels shareUnDeallocModels].unDealocModels);
        }
    }
}

@end
