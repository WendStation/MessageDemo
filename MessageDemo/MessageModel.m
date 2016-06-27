//
//  MessageModel.m
//  MessageUI
//
//  Created by wufei on 15/12/9.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel


+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    MessageModel *model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
