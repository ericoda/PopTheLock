//
//  ViewController.m
//  PopTheLock
//
//  Created by Eric on 2017/3/1.
//  Copyright © 2017年 Eric. All rights reserved.
//

#import "ViewController.h"
#import "LockView.h"
@interface ViewController ()
@end

@implementation ViewController {
    LockView *_lview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (_lview) {
        [_lview removeFromSuperview];
        _lview = nil;
    }
//    CGFloat wid = CGRectGetWidth(self.view.frame);
//    CGFloat hei = CGRectGetHeight(self.view.frame);;
    CGRect rect = (CGRect){{0,0},{100,100}};
    _lview = [[LockView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_lview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
