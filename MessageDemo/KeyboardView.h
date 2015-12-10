//
//  KeyboardView.h
//  MessageDemo
//
//  Created by wend on 15/12/9.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KeyboardView;
@protocol KeyboardViewDelegate <NSObject>

-(void)KeyboardVIew:(KeyboardView*)keyboardView textFileReturn:(UITextField*)textField;
-(void)KeyboardVIew:(KeyboardView*)keyboardView textFileBegin:(UITextField*)textField;
//开始录音
-(void)beginRecord;
//结束录音
-(void)stopRecord;
@end

@interface KeyboardView : UIView

@property(nonatomic,assign)id<KeyboardViewDelegate>delegate;
@end
