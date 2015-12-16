//
//  NSString+DocumentPath.m
//  MessageDemo
//
//  Created by wufei on 15/12/10.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import "NSString+DocumentPath.h"

@implementation NSString (DocumentPath)


- (NSUInteger)numberOfLines
{
    return [self componentsSeparatedByString:@"\n"].count;
}

@end
