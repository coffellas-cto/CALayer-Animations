//
//  ViewController.m
//  CoreAnimation
//
//  Created by Alex G on 08.12.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

#import "ViewController.h"
#import "GDCubeView.h"

@interface ViewController () {
    GDCubeView *cube;
    CAGradientLayer *gradientLayer;
}

@end

@implementation ViewController

- (void)incrementCubesCount:(uint)count {
    __block uint countBlock = ++count;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [cube setCount:@(countBlock)];
        [self incrementCubesCount:countBlock];
    });
}

- (void)setupGradientAnimation {
    CFTimeInterval duration = 10;
    NSArray *initialColors = @[(__bridge id)[UIColor magentaColor].CGColor, (__bridge id)[UIColor cyanColor].CGColor];
    NSArray *intermediateColors1 = @[(__bridge id)[UIColor cyanColor].CGColor, (__bridge id)[UIColor redColor].CGColor];
    NSArray *intermediateColors2 = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor magentaColor].CGColor];
    
    CAKeyframeAnimation *animationColor = [CAKeyframeAnimation animationWithKeyPath:@"colors"];
    animationColor.duration = duration;
    animationColor.values = @[initialColors, intermediateColors1, intermediateColors2, initialColors];
    animationColor.repeatCount = HUGE_VALF;
    
    [gradientLayer addAnimation:animationColor forKey:@"colors"];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [gradientLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    centerView.clipsToBounds = YES;
    centerView.layer.cornerRadius = 20;
    centerView.center = self.view.center;
    centerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:centerView];
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor magentaColor].CGColor, (__bridge id)[UIColor cyanColor].CGColor];
    gradientLayer.locations = @[@0, @1];
    CGFloat margin = 80;
    gradientLayer.frame = CGRectMake(-margin/2.0, -margin / 2.0, 200 + margin, 200 + margin);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [centerView.layer addSublayer:gradientLayer];
    
    [self setupGradientAnimation];
    
    cube = [GDCubeView new];
    cube.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    cube.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
    [self.view addSubview:cube];
    
    [self incrementCubesCount:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
