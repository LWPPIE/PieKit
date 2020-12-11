//
//  UnDeallocModels.h
//  TTClub
//
//  Created by RoyLei on 15/8/19.
//  Copyright (c) 2015年 TTClub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnDeallocModels : NSObject

+ (instancetype)shareUnDeallocModels;

@property (strong, nonatomic) NSMutableArray *unDealocModels;

- (void)addContrllerName:(NSString *)controllerName andFloor:(NSInteger)num;         //添加视图名

- (void)deallocControllerName:(NSString *)controllerName andFloor:(NSInteger)num;    //移除视图名

@end
