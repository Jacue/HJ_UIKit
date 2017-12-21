//
//  ViewController.m
//  Demo
//
//  Created by Jacue on 2017/12/18.
//  Copyright © 2017年 Jacue. All rights reserved.
//

#import "ViewController.h"
#import <HJ_UIKit/HJAlertView.h>
#import <HJ_UIKit/HJPriorityManager.h>
#import <YYText/YYText.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableAttributedString *messageString = [[NSMutableAttributedString alloc] initWithString:@"www.baidu.com, it may be very very very long, more than you can image"];
    [messageString yy_setTextHighlightRange:NSMakeRange(0, 13) color:[UIColor redColor] backgroundColor:[UIColor greenColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"this is tap test.");
    }];

    HJAlertView *alertView1 = [[HJAlertView alloc] initWithTitle:@"Title1" attributeMessage:messageString confirmButtonTitle:@"confirm" confirmBlock:nil];
//    alertView1.revokable = YES;
    alertView1.forceRead = YES;
//    alertView1.keepAlive = YES;
    alertView1.alertLevel = 1;
    [[HJPriorityManager sharedManager] show:alertView1 withBlock:^{
        [alertView1 show];
    }];
    
    HJAlertView *alertView2 = [[HJAlertView alloc] initWithTitle:@"Title2" attributeMessage:messageString confirmButtonTitle:@"confirm" confirmBlock:nil];
    alertView2.alertLevel = 1;
    [[HJPriorityManager sharedManager] show:alertView2 withBlock:^{
        [alertView2 show];
    }];


    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
