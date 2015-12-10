//
//  MessageContentView.h
//  MessageDemo
//
//  Created by wend on 15/12/9.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MessageContentView,MessageModel;

@protocol MessageContentViewDelegate <NSObject>

-(void)messageContentViewLongPress:(MessageContentView*)messageContentView content:(NSString*)content;
-(void)messageContentViewTapPress:(MessageContentView*)messageContentView content:(NSString *)content;

@end


@interface MessageContentView : UIView
@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)UIImageView* backImageView;
@property(nonatomic,strong)UILabel* contentLabel;
@property(nonatomic,strong)UILabel* timeLabel;
@property(nonatomic,strong)UILabel* userNameLabel;
@property(nonatomic,strong)MessageModel* model;
@property(nonatomic,assign)id<MessageContentViewDelegate>delegate;

@end
