//
//  BPQRCodeReaderView.m
//  BPQRCodeReaderDemo
//
//  Created by milton on 16/7/18.
//  Copyright © 2016年 baoping.zhang. All rights reserved.
//

#import "BPQRCodeReaderView.h"

@implementation BPQRCodeReaderView
{
    UIImage *_lefttopImage;
    UIImage *_righttopImage;
    UIImage *_leftbottomImage;
    UIImage *_rightbottomImage;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initCornerImageWithDataSource];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    //扫描框
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor lightGrayColor] setStroke];
    [bezierPath setLineWidth:3];
    [bezierPath stroke];
    //扫描框四个角的图片
    CGRect lefttopRect = CGRectMake(0, 0, 20, 20);
    CGRect righttopRect = CGRectMake(self.bounds.size.width - 20, 0, 20, 20);
    CGRect leftbottomRect = CGRectMake(0, self.bounds.size.height - 20, 20, 20);
    CGRect rightbottomRect = CGRectMake(self.bounds.size.width - 20, self.bounds.size.height -20, 20, 20);
    
    [_lefttopImage drawInRect:lefttopRect];
    [_righttopImage drawInRect:righttopRect];
    [_leftbottomImage drawInRect:leftbottomRect];
    [_rightbottomImage drawInRect:rightbottomRect];
}
//为边角的image赋初值
- (void)initCornerImageWithDataSource{
    _lefttopImage = [UIImage imageNamed:@"leftTop.png"];
    _righttopImage = [UIImage imageNamed:@"rightTop.png"];
    _leftbottomImage = [UIImage imageNamed:@"leftbottom.png"];
    _rightbottomImage = [UIImage imageNamed:@"rightbottom.png"];
}

//当传入新的图片是更改边角图片
-(void)setCornerImageNamesArr:(NSArray *)cornerImageNamesArr{
    _cornerImageNamesArr = cornerImageNamesArr;
    _lefttopImage = [UIImage imageNamed:cornerImageNamesArr[0]];
    _righttopImage = [UIImage imageNamed:cornerImageNamesArr[1]];
    _leftbottomImage = [UIImage imageNamed:cornerImageNamesArr[2]];
    _rightbottomImage = [UIImage imageNamed:cornerImageNamesArr[3]];
    [self setNeedsDisplay];
}



@end
