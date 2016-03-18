//
//  TRLabel.m
//  TRFindDeals
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRLabel.h"

@implementation TRLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    [super drawRect:rect];
    
    //上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //起点
    CGContextMoveToPoint(context, 0, rect.size.height*0.5);
    //终点
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height*0.5);
    //渲染(划线)
    CGContextStrokePath(context);
    
    
}


@end
