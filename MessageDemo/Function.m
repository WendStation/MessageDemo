//
//  Function.m
//  MessageDemo
//
//  Created by wend on 15/12/14.
//  Copyright © 2015年 wufei. All rights reserved.
//

#import "Function.h"
#import "Header.h"

@implementation Function
+(NSString*)dateStringWithTimeString:(NSString*)time 
{
    NSDate* date=[NSDate dateWithTimeIntervalSince1970:time.intValue];
    NSDateFormatter* formater=[[NSDateFormatter alloc]init];
    NSDate* today=[NSDate date];
    [formater setDateFormat:@"dd"];
    NSString* dateOfDay=[formater stringFromDate:date];
    NSString* todayOfDay=[formater stringFromDate:today];
    //不是今天
    if (![todayOfDay isEqualToString:dateOfDay]) {
        [formater setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        return [formater stringFromDate:date];
    }
    else
    {
        //是今天，但是大于5分钟
        [formater setDateFormat:@"mm"];
        NSString* dateOfMin=[formater stringFromDate:date];
        NSString* todayOfMin=[formater stringFromDate:today];
        if (todayOfMin.intValue-dateOfMin.intValue>=5) {
            [formater setDateFormat:@"HH:mm"];
            return [formater stringFromDate:date];
        }
        return nil;
    }
}

+(NSString*)compareTimeWithOldTime:(NSString*)oldTime NewTime:(NSString*)newTime
{
    NSDate* oldDate=[NSDate dateWithTimeIntervalSince1970:oldTime.intValue];
    NSDate* newDate=[NSDate dateWithTimeIntervalSince1970:newTime.intValue];
    
    NSDateFormatter* formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"dd"];
    NSString* oldDateOfDay=[formater stringFromDate:oldDate];
    NSString* newDateOfDay=[formater stringFromDate:newDate];
    //不是今天
    if (![oldDateOfDay isEqualToString:newDateOfDay]) {
        [formater setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        return [formater stringFromDate:newDate];
    }
    else
    {
        //是今天，但是大于5分钟

        //如果超过最大时间
        if (newTime.intValue-oldTime.intValue>=MaxMinite*60) {
            [formater setDateFormat:@"HH:mm"];
            NSLog(@"time:%@",[formater stringFromDate:newDate]);
            return [formater stringFromDate:newDate];
            
        }
        return nil;
    }
}
@end
