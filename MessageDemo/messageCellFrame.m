//
//  messageCellFrame.m
//  MessageDemo
//
//  Created by wufei on 15/12/10.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import "messageCellFrame.h"
#import "Header.h"
#import "Function.h"


#define IconMarginX 10
#define IconMarginY 15
#define BLANKSPACE 10 //控件之间间距
#define IconWidth 44
#define IconHeight 44
#define ErrorImage_Width 30
#define ErrorImage_Height 30
#define LabelMaxWidth 200
#define LabelMaxHeight 50
#define TimeLabelToTop_Y 15
#define ContentLabel_FontSize 14.0
#define CellMaxYToContentMaxY 5
#define MessageContent_LabelToBackground 14

@implementation MessageCellFrame

- (void)setModel:(MessageModel *)model
{
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    if (self.isTimeShow) {
        CGSize size = CGSizeMake(LabelMaxWidth, LabelMaxHeight);
        if (self.CurrentTimeStr) {
            CGRect labelRect = [self.CurrentTimeStr boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil];
            self.timeRect = CGRectMake([[UIScreen mainScreen]bounds].size.width/2.0-(labelRect.size.width+10)/2, TimeLabelToTop_Y, labelRect.size.width, labelRect.size.height+4);
        }
    }
    else
        self.timeRect = CGRectZero;
    _model = model;
    CGFloat iconX = IconMarginX;
    CGFloat iconY = IconMarginY;
    CGFloat iconWidth = IconWidth;
    CGFloat iconHeight = IconHeight;
    CGFloat contentX = CGFLOAT_MIN;
    if(![model.from isEqualToString:userID]){
        self.iconRect = CGRectMake(iconX, iconY+ CGRectGetMaxY(self.timeRect), iconWidth, iconHeight);
        contentX = CGRectGetMaxX(self.iconRect)+BLANKSPACE;
    }else{
        iconX = winSize.width-IconMarginX-iconWidth;
        self.iconRect = CGRectMake(iconX, iconY+ CGRectGetMaxY(self.timeRect), iconWidth, iconHeight);
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:ContentLabel_FontSize]};
    CGSize contentSize = [model.message[@"content"] boundingRectWithSize:CGSizeMake(LabelMaxWidth, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    if([model.from isEqualToString:userID]){
        contentX = iconX-BLANKSPACE-contentSize.width-2*MessageContent_LabelToBackground;
         self.messageViewRect = CGRectMake(contentX-5, CGRectGetMinY(self.iconRect), contentSize.width+2*MessageContent_LabelToBackground+BLANKSPACE, contentSize.height+2*MessageContent_LabelToBackground+2);
        //设置菊花的位置
        self.indicatorRect = CGRectMake(contentX-ErrorImage_Width-BLANKSPACE, CGRectGetMinY(self.messageViewRect)+CGRectGetHeight(self.messageViewRect)/2-ErrorImage_Width/2, ErrorImage_Width, ErrorImage_Height);
        //设置错误图片的位置
        self.errorImageRect = CGRectMake(contentX-ErrorImage_Width-BLANKSPACE, CGRectGetMinY(self.messageViewRect)+CGRectGetHeight(self.messageViewRect)/2-ErrorImage_Width/2, ErrorImage_Width, ErrorImage_Height);
        self.nameRect = CGRectZero;
    }
    else
    {
        //设置姓名的位置
        //包裹
        CGSize size = CGSizeMake(LabelMaxWidth, LabelMaxHeight);
        NSString *name = model.name;
        CGRect labelRect = [name boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil];
        self.nameRect = CGRectMake(contentX, CGRectGetMinY(self.iconRect), labelRect.size.width+2, labelRect.size.height);
        self.messageViewRect = CGRectMake(contentX-5, CGRectGetMaxY(self.nameRect)+5,contentSize.width+2*MessageContent_LabelToBackground+2+8, contentSize.height+2*MessageContent_LabelToBackground+2);
    }
    self.cellHeight = MAX(CGRectGetMaxY(self.messageViewRect),CGRectGetMaxY(self.iconRect))+CellMaxYToContentMaxY;
}


@end
