//
//  GDCubeView.m
//  CoreAnimation
//
//  Created by Alex G on 08.12.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "GDCubeView.h"

@implementation GDCubeView {
    CALayer *cubeLayer;
    CAShapeLayer *holeLayer;
    CAShapeLayer *circleLayer;
    CAShapeLayer *backgroundLayer;
    CATextLayer *textLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCount:(NSNumber *)count {
    textLayer.string = [count stringValue];
    CAKeyframeAnimation *animationPath = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    CGPathRef initPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-14, -14, 68, 68)].CGPath;
    CGPathRef finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-19, -19, 78, 78)].CGPath;
    animationPath.values = @[(__bridge id)initPath, (__bridge id)finalPath, (__bridge id)initPath];
    animationPath.duration = 0.3;
    CAKeyframeAnimation *animationFillColor = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
    CGColorRef initColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
    CGColorRef finalColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    animationFillColor.values = @[(__bridge id)initColor, (__bridge id)finalColor, (__bridge id)initColor];
    animationFillColor.duration = 0.3;
    [backgroundLayer addAnimation:animationPath forKey:@"path"];
    [backgroundLayer addAnimation:animationFillColor forKey:@"fillColor"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 40, 40)];
    if (self) {
        
        backgroundLayer = [CAShapeLayer layer];
        backgroundLayer.fillColor = [UIColor colorWithWhite:1 alpha:0.2].CGColor;
        backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-14, -14, 68, 68)].CGPath;
        [self.layer addSublayer:backgroundLayer];
        
        cubeLayer = [CALayer layer];
        cubeLayer.contents = (id)[UIImage imageNamed:@"cube"].CGImage;
        cubeLayer.frame = CGRectMake(0, 0, 40, 40);
        
        holeLayer = [CAShapeLayer layer];
        holeLayer.fillRule = kCAFillRuleEvenOdd;
        UIBezierPath *holePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(25, 0, 20, 20)];
        [holePath appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 80, 80)]];
        holeLayer.path = holePath.CGPath;
        cubeLayer.mask = holeLayer;
        
        circleLayer = [CAShapeLayer layer];
        circleLayer.fillColor = [UIColor whiteColor].CGColor;
        circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(26, 1, 18, 18)].CGPath;
        [self.layer addSublayer:circleLayer];
        
        textLayer = [CATextLayer layer];
        textLayer.contentsScale = [[UIScreen mainScreen] scale];
        textLayer.font = (__bridge CFTypeRef)(@"Helvetica-Neue");
        textLayer.fontSize = 12;
        textLayer.string = @"1";
        textLayer.frame = CGRectMake(26, 2, 18, 18);
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.foregroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        [circleLayer addSublayer:textLayer];
        
        [self.layer addSublayer:cubeLayer];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position.y";
        animation.values = @[@0, @-4, @0];
        animation.duration = 0.8;
        animation.additive = YES;
        animation.repeatCount = HUGE_VALF;
        
        [holeLayer addAnimation:animation forKey:@"bounce"];
        
        [circleLayer addAnimation:animation forKey:@"bounce"];
    }
    return self;
}

@end
