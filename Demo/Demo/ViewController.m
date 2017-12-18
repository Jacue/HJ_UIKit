//
//  ViewController.m
//  Demo
//
//  Created by Jacue on 2017/12/18.
//  Copyright © 2017年 Jacue. All rights reserved.
//

#import "ViewController.h"
#import <HJ_UIKit/LNAlertView.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LNAlertView *alertView = [[LNAlertView alloc] initWithTitle:@"Title" message:@"Message" cancelBlock:nil confirmBlock:nil];
    [alertView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
