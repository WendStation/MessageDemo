//
//  MessageContentView.m
//  MessageDemo
//
//  Created by wend on 15/12/9.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import "MessageContentView.h"
#import "MessageContentView.h"
#import "MessageModel.h"

#define ContentStartMargin 25
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation MessageContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    [self addSubview:self.backImageView];
    [self addSubview:self.contentLabel];
    
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)]];
    
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //为什么要设置为self.bounds大小
    self.backImageView.frame=self.bounds;
    CGFloat contentLabelX=0;
    //判断是否是自己发送的，从而判断位置
    if ([self.model.from isEqualToString:self.userId]) {
        contentLabelX=ContentStartMargin*0.8;
    }
    else
    {
        contentLabelX=ContentStartMargin*0.5;
    }
    //这句话什么作用
    self.contentLabel.frame=CGRectMake(contentLabelX, -3, WIDTH-ContentStartMargin-5, HEIGHT);
    
    //这里设置时间label
    
    //这里设置用户的label
    
}

#pragma mark - 懒加载
-(UIImageView *)backImageView
{
    if (_backImageView==nil) {
        _backImageView=[[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled=YES;
    }
    return _backImageView;
    
}
-(UILabel *)contentLabel
{
    if (_contentLabel==nil) {
        _contentLabel=[[UILabel alloc]init];
        _contentLabel.numberOfLines=0;
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        _contentLabel.font=[UIFont systemFontOfSize:13.0f];
    }
    return _contentLabel;
}
-(UILabel *)timeLabel
{
    if (_timeLabel==nil) {
        _timeLabel=[[UILabel alloc]init];
        _timeLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _timeLabel;
}
-(UILabel *)userNameLabel
{
    if (_userNameLabel==nil) {
        _userNameLabel=[[UILabel alloc]init];
        _userNameLabel.textAlignment=NSTextAlignmentLeft;
        
    }
    return _userNameLabel;
}
#pragma mark - 手势的实现函数
-(void)longTap:(UILongPressGestureRecognizer*)longTap
{
    if ([self.delegate respondsToSelector:@selector(messageContentViewLongPress:content:)]) {
        [self.delegate messageContentViewLongPress:self content:self.contentLabel.text];
    }
}
-(void)tapPress:(UITapGestureRecognizer*)tapPress
{
    if ([self.delegate respondsToSelector:@selector(messageContentViewTapPress:content:)]) {
        [self.delegate messageContentViewTapPress:self content:self.contentLabel.text];
    }
}

@end
