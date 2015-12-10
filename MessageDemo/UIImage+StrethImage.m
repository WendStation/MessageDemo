//
//  UIImage+StrethImage.m
//  MessageDemo
//
//  Created by wufei on 15/12/10.
//  Copyright (c) 2015年 wufei. All rights reserved.
//

#import "UIImage+StrethImage.h"

@implementation UIImage (StrethImage)


+(instancetype)strethImageWithName:(NSString *)imageName{
    UIImage* image=[UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
}
@end
