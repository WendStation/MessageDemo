//
//  KeyboardView.m
//  MessageDemo
//
//  Created by wend on 15/12/9.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import "KeyboardView.h"
#import "Header.h"
#import "NSString+DocumentPath.h"

@interface KeyboardView()<UITextFieldDelegate,UITextViewDelegate>


@property (nonatomic,strong) UIButton *voiceBtn;
@property (nonatomic,strong) UIButton *imageBtn;
@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIButton *speakBtn;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIButton *SendBtn;


@property(nonatomic,assign)CGFloat textViewContentHeight;


@end

@implementation KeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithData];
    }
    return self;
}
-(void)initWithData
{
    [self addSubview:self.backImageView];
    [self addSubview:self.voiceBtn];
//    [self addSubview:self.textField];
    [self addSubview:self.textView];
    [self addSubview:self.imageBtn];
    [self addSubview:self.addBtn];
    [self addSubview:self.speakBtn];
    [self addSubview:self.SendBtn];
    
}
#pragma mark - 懒加载
-(UIImageView *)backImageView
{
    if (_backImageView==nil) {
        _backImageView=[[UIImageView alloc]initWithFrame:self.bounds];
        _backImageView.image=[UIImage imageNamed:@"toolbar_bottom_bar"];
//        _backImageView.backgroundColor=[UIColor blackColor];
//        _backImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _backImageView;
}
-(UIButton *)voiceBtn
{
    if (_voiceBtn==nil) {
        _voiceBtn=[self buttonWithState:@"chat_bottom_voice_nor" hightLight:@"chat_bottom_voice_press" action:@selector(voiceButtonPress:)];
        [_voiceBtn setFrame:CGRectMake(0, 0, KeyBoard_ButtonHeight, KeyBoard_ButtonHeight)];
        [_voiceBtn setCenter:CGPointMake(VoiceButton_X, HEIGHT*0.5)];
    }
    return _voiceBtn;
}

-(UITextView *)textView
{
    if (_textView==nil) {
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, WIDTH-3*self.voiceBtn.frame.size.width-BLANKSPACE, HEIGHT*0.8)];
        CGFloat contentX=CGRectGetMinX(self.imageBtn.frame)/2+CGRectGetMaxX(self.voiceBtn.frame)/2;
        _textView.center=CGPointMake(contentX, HEIGHT*0.5);
        _textView.font=[UIFont systemFontOfSize:FontSize];
        _textView.maximumZoomScale=100;
        _textView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _textView.layer.cornerRadius=5.0f;
        _textView.delegate=self;
        _textView.returnKeyType=UIReturnKeySend;
    }
    return _textView;
}
-(UIButton *)imageBtn
{
    if (_imageBtn==nil) {
         _imageBtn=[self buttonWithState:@"chat_bottom_smile_nor" hightLight:@"chat_bottom_smile_press" action:@selector(imageButtonPress:)];
        [_imageBtn setFrame:CGRectMake(0, 0, KeyBoard_ButtonHeight, KeyBoard_ButtonHeight)];
        [_imageBtn setCenter:CGPointMake(self.addBtn.frame.origin.x-33/2, HEIGHT*0.5)];
        _imageBtn.hidden=YES;
    }
    return _imageBtn;
}
-(UIButton *)addBtn
{
    if (_addBtn==nil) {
        _addBtn=[self buttonWithState:@"chat_bottom_up_nor" hightLight:@"chat_bottom_up_press" action:@selector(addButtonPress:)];
        [_addBtn setFrame:CGRectMake(0, 0, KeyBoard_ButtonHeight, KeyBoard_ButtonHeight)];
        [_addBtn setCenter:CGPointMake(WIDTH-33/2-5, HEIGHT*0.5)];
        _addBtn.hidden=YES;
    }
    return _addBtn;
}
-(UIButton *)speakBtn
{
    if (_speakBtn==nil) {
        _speakBtn=[self buttonWithState:nil hightLight:nil action:@selector(speakButtonPress:)];
//        [_speakBtn setFrame:self.textView.frame];
        _speakBtn.frame=CGRectMake(0, 0, WIDTH-3*self.voiceBtn.frame.size.width-BLANKSPACE, HEIGHT*0.5);
        CGFloat contentX=CGRectGetMinX(self.imageBtn.frame)/2+CGRectGetMaxX(self.voiceBtn.frame)/2;
        _speakBtn.center=CGPointMake(contentX, HEIGHT*0.5);
        
        [_speakBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [_speakBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_speakBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [_speakBtn setBackgroundColor:[UIColor whiteColor]];
        _speakBtn.layer.cornerRadius=5.0f;
        _speakBtn.hidden=YES;
    }
    return _speakBtn;
}
-(UIButton *)SendBtn
{
    if (_SendBtn==nil) {
        _SendBtn=[self buttonWithState:nil hightLight:nil action:@selector(sendButtonClick:)];
        [_SendBtn setFrame:CGRectMake(0, 0, SendButtonWidth, KeyBoard_ButtonHeight)];
        CGFloat contentX=(CGRectGetMaxX(self.addBtn.frame)- CGRectGetMinX(self.imageBtn.frame))/2+CGRectGetMinX(self.imageBtn.frame);
        [_SendBtn setCenter:CGPointMake(contentX, HEIGHT*0.5)];
//        [_SendBtn setBackgroundColor:[UIColor greenColor]];
        [_SendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _SendBtn.layer.cornerRadius=5.0f;
//        _SendBtn.hidden=YES;
        
    }
    return _SendBtn;
}

#pragma mark - button的封装 和实现
-(UIButton *)buttonWithState:(NSString*)normal hightLight:(NSString*)hightLight action:(SEL)action
{
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hightLight] forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)sendButtonClick:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(sendMessage)]) {
        [self.delegate sendMessage];
    }
    NSLog(@"发送");
}
//声音的点击事件，主要是处理键盘控件的显示/隐藏
-(void)voiceButtonPress:(UIButton*)button
{
    
    NSString *normal,*hightLight;
    if(self.speakBtn.hidden==YES){
        self.speakBtn.hidden=NO;
        self.textField.hidden=YES;
        normal=@"chat_bottom_keyboard_nor.png";
        hightLight=@"chat_bottom_keyboard_press.png";
        if ([self.delegate respondsToSelector:@selector(KeyboardVIew:textViewHeightChange:)])
        {
             [self.delegate KeyboardVIew:self textViewHeightChange:self.textView];
        }
        [self.textView endEditing:YES];
    }else{
        self.speakBtn.hidden=YES;
        self.textField.hidden=NO;
        normal=@"chat_bottom_voice_nor.png";
        hightLight=@"chat_bottom_voice_press.png";
    }
    [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hightLight] forState:UIControlStateHighlighted];
}
//显示表情的按钮
-(void)imageButtonPress:(UIButton *)button
{
    NSLog(@"%s",__func__);
}
//增加按钮的实现
-(void)addButtonPress:(UIButton *)button
{
     NSLog(@"%s",__func__);

    
}
//按下按钮的实现，开始录音
-(void)touchDown:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(beginRecord)]) {
        [self.delegate beginRecord];
        NSLog(@"开始录音。。。。。。");
    }
    
}
-(void)speakButtonPress:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(stopRecord)]) {
        [self.delegate stopRecord];
    }
}



#pragma mark - textView协议

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(KeyboardVIew:textViewBegin:)]) {
        [self.delegate KeyboardVIew:self textViewBegin:self.textView];
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(KeyboardVIew:textViewDidChang:)]) {
        [self.delegate KeyboardVIew:self textViewDidChang:self.textView];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(KeyboardVIew:sendMessage:currentMessage:)]) {
        return  [self.delegate KeyboardVIew:self sendMessage:self.textView currentMessage:text];
    }
    return YES;
}

//调整textView的高度
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
//    changeInHeight=changeInHeight+1;
    self.textViewContentHeight=changeInHeight;
    CGRect prevFrame = self.textView.frame;
    
    NSUInteger numLines = MAX([self numberOfLinesOfText],
                       [self.textView.text numberOfLines]);
    
    NSLog(@"number line == %lu",numLines);
    
    self.textView.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);
//    
    self.textView.contentInset = UIEdgeInsetsMake((numLines >= MaxLine-1 ? 5.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= MaxLine-1 ? 5.0f : 0.0f),
                                                  0.0f);
    
    self.textView.scrollEnabled = (numLines >= MaxLine-1);

    //改变发送按钮的高度
    CGFloat contentX=(CGRectGetMaxX(self.addBtn.frame)- CGRectGetMinX(self.imageBtn.frame))/2+CGRectGetMinX(self.imageBtn.frame);
    CGFloat contentY=(CGRectGetMaxY(self.SendBtn.frame)+CGRectGetMinY(self.SendBtn.frame))/2+changeInHeight;
    CGRect sendBtnFrame = self.SendBtn.frame;
    self.SendBtn.frame=CGRectMake(0, 0, sendBtnFrame.size.width, sendBtnFrame.size.height);
    self.SendBtn.center=CGPointMake(contentX, contentY);
    
    if(numLines >= MaxLine) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
    } 
}


#pragma mark - 其他函数
- (NSUInteger)numberOfLinesOfText
{
    return [self numberOfLinesForMessage:self.textView.text];
}

- (NSUInteger)maxCharactersPerLine
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 20 : 109;
}

- (NSUInteger)numberOfLinesForMessage:(NSString *)text
{
    return (text.length / [self maxCharactersPerLine]) + 1;
}
- (CGFloat)textViewLineHeight
{
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:FontSize];
    return [self.textView.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]].height;
}

- (CGFloat)maxLines
{
    return MaxLine*1.0f;
}

- (CGFloat)maxHeight
{
    return [self maxLines] * [self textViewLineHeight];
}





@end
