//
//  Header.h
//  MessageDemo
//
//  Created by wend on 15/12/10.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#ifndef MessageDemo_Header_h
#define MessageDemo_Header_h

#define userID @"11450"
//屏幕的宽高
#define ScreenWidth [[UIScreen mainScreen]bounds].size.width
#define ScreenHeight [[UIScreen mainScreen]bounds].size.height
//单独view的宽高
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

#define LINESPACE 2
#define KeyBoardHeight 40

//cell里面的宏
#define CellMaxYToContentMaxY 10
#define IconMarginX 10
#define IconMarginY 15
#define BLANKSPACE 10 //控件之间间距
#define IconWidth 44
#define IconHeight 44
#define ErrorImage_Width 30
#define ErrorImage_Height 30
#define TimeLabelToTop_Y 15
#define LabelMaxWidth 200
#define LabelMaxHeight 50
#define MessageContent_LabelToBackground 14
#define ContentLabel_FontSize 14.0
#define NameLabel_FontSize 12.0
//keyboard里面的宏
#define MaxLine 6   //输入最大行数
#define FontSize 12.0f
#define SendButtonWidth 60
#define KeyBoard_ButtonHeight 33
#define VoiceButton_X 20
//时间的最大间隔，超过后显示时间
#define MaxMinite 5


#endif
