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
#import "Header.h"
#import "PPLabel.h"

#define MessageContent_LabelToBackground 14
#define ContentLabel_FontSize 14.0
#define NameLabel_FontSize 12.0

@implementation MessageContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    [self addSubview:self.backImageView];
    [self addSubview:self.contentLabel];
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backImageView.frame = self.bounds;
    CGFloat contentLabelX = 0;
    if (![self.model.from isEqualToString:userID]) {
        contentLabelX = MessageContent_LabelToBackground+5;
    }
    else
    {
        contentLabelX = MessageContent_LabelToBackground;
    }
    self.contentLabel.frame = CGRectMake(contentLabelX, MessageContent_LabelToBackground, WIDTH-MessageContent_LabelToBackground*2-5, HEIGHT-MessageContent_LabelToBackground*2);
    
}

#pragma mark - 懒加载
- (UIImageView *)backImageView
{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
    
}
- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[PPLabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:ContentLabel_FontSize];
        _contentLabel.textColor = [UIColor colorWithRed:17.0/255 green:17.0/255 blue:17.0/255 alpha:1.0];

    }
    return _contentLabel;
}

#pragma mark - 手势的实现函数
- (void)longTap:(UILongPressGestureRecognizer*)longTap
{
    if ([self.delegate respondsToSelector:@selector(messageContentViewLongPress:content:)]) {
        [self.delegate messageContentViewLongPress:self content:self.contentLabel.text];
    }
}
- (void)tapPress:(UITapGestureRecognizer*)tapPress
{
    if ([self.delegate respondsToSelector:@selector(messageContentViewTapPress:content:)]) {
        [self.delegate messageContentViewTapPress:self content:self.contentLabel.text];
    }
    
}

@end
