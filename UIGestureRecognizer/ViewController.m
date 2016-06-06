//
//  ViewController.m
//  UIGestureRecognizer
//
//  Created by MacBook on 16/6/2.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "UIView+RTGestureRecognizer.h"

@interface ViewController ()
{
    UIImageView *_imageview;
    UIView *_view;
    UIView *_view2;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self imageViewGestureRecognizeraTest];
    
}

- (void)imageViewGestureRecognizeraTest
{
 //imageView
    _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    _imageview.image = [UIImage imageNamed:@"ruitai"];
    _imageview.contentMode = UIViewContentModeScaleAspectFit;
    [_imageview gestureConfig];
    _imageview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imageview];
 //view
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 150, 150, 150)];
    [_view gestureConfig];
    _view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_view];
//view2
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 150, 150)];
    [_view2 gestureConfig];
    _view2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_view2];
}
#pragma mark-- touchs
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
