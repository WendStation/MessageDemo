//
//  MessageModel.h
//  MessageUI
//
//  Created by wufei on 15/12/9.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,strong) NSString *messageId;
@property (nonatomic,strong) NSString *from;
@property (nonatomic,strong) NSString *groupId;
@property (nonatomic,strong) NSString *to;
@property (nonatomic,strong) NSDictionary *message;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *avatar;//url image
@property (nonatomic,strong) NSString *creationTime;


+(instancetype)modelWithDict:(NSDictionary *)dict;


@end
