//
//  MessageCell.h
//  MessageDemo
//
//  Created by wufei on 15/12/10.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageCellFrame.h"
@class MessageCell

@protocol MessageCellDelegate <NSObject>

-(void)MessageCell:(MessageCell *)messageCell tapContent:(NSString *)content;

@end

@interface MessageCell : UITableViewCell
@property(nonatomic,strong)messageCellFrame* cellFrame;
@property(nonatomic,assign)id<MessageCellDelegate> delegate;

@end
