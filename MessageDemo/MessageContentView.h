//
//  MessageContentView.h
//  MessageDemo
//
//  Created by wend on 15/12/9.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPLabel;

@class MessageContentView,MessageModel;

@protocol MessageContentViewDelegate <NSObject>

-(void)messageContentViewLongPress:(MessageContentView*)messageContentView content:(NSString*)content;
-(void)messageContentViewTapPress:(MessageContentView*)messageContentView content:(NSString *)content;

@end


@interface MessageContentView : UIView
@property(nonatomic,strong)UIImageView* backImageView;
@property(nonatomic,strong)PPLabel* contentLabel;

@property(nonatomic,strong)MessageModel* model;
@property(nonatomic,assign)id<MessageContentViewDelegate>delegate;

@end
