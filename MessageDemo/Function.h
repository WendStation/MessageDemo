//
//  Function.h
//  MessageDemo
//
//  Created by wend on 15/12/14.
//  Copyright © 2015年 wufei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Function : NSObject
+(NSString*)dateStringWithTimeString:(NSString*)time;
+(NSString*)compareTimeWithOldTime:(NSString*)oldTime NewTime:(NSString*)newTime;
@end
