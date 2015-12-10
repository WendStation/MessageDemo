//
//  MessageModel.h
//  MessageUI
//
//  Created by wufei on 15/12/9.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
//messageId: "2320"
//from: "11450"
//groupId: "226"
//to: "0"
//message: {
//   type: "text"
//   content: "刘宝瑞已加入群聊"
//   time: 1449209945001
// }
//sendTime: "0"
//creationTime: "2015-12-04 14:24:53"
//received: "0"
//name: "-"
//avatar: ""
//projectId: "265"
@property(nonatomic,strong)NSString* messageId;
@property(nonatomic,strong)NSString* from;
@property(nonatomic,strong)NSString* groupId;
@property(nonatomic,strong)NSString* to;
@property(nonatomic,strong)NSDictionary* message;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* avatar;//url image
@property(nonatomic,strong)NSString* creationTime;
+(instancetype)modelWithDict:(NSDictionary *)dict;

@end
