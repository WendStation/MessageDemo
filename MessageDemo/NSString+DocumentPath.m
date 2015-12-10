//
//  NSString+DocumentPath.m
//  MessageDemo
//
//  Created by wufei on 15/12/10.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import "NSString+DocumentPath.h"

@implementation NSString (DocumentPath)

+(NSString *)documentPathWithFileName:(NSString *)fileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
}
@end
