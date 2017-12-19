//
//  ViewController.m
//  Demo
//
//  Created by Jacue on 2017/12/18.
//  Copyright © 2017年 Jacue. All rights reserved.
//

#import "ViewController.h"
#import <HJ_UIKit/HJAlertView.h>
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

    HJAlertView *alertView = [[HJAlertView alloc] initWithTitle:@"this is title, maybe a little long" attributeMessage:messageString confirmButtonTitle:@"confirm" confirmBlock:nil];
//    alertView.revokable = YES;
    alertView.forceRead = YES;
//    alertView.keepAlive = YES;
    [alertView show];
    


    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
