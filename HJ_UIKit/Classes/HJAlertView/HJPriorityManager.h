//
//  HJPriorityManager.h
//  AlertViewManager
//
//  Created by Jacue on 2017/7/6.
//  Copyright © 2017年 Jacue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol HJPriorityProtocol <NSObject>

// 弹窗的优先级
- (NSInteger)level;

// 弹窗顶替时隐藏弹窗
- (void)dismissWithCompletion:(void(^)(void))completionBlock;

@end


@interface HJPriorityManager : NSObject

+ (instancetype)sharedManager;

/**
 展示弹层
 
 @param alertView 弹层
 @param alertBlock 弹层的展示操作
 */
- (void)show:(id<HJPriorityProtocol>)alertView withBlock:(void(^)(void))alertBlock;

/**
 展示弹窗，并清除之前的所有的弹窗
 
 @param alertView 弹层
 @param alertBlock 弹层的展示操作
 */
- (void)showAlone:(id<HJPriorityProtocol> )alertView withBlock:(void(^)(void))alertBlock;


/**
 用户手动隐藏弹窗需把当前保存的优先级、弹窗还原。
 */
- (void)dismissCurrentAlertViewManually:(BOOL)isManual;

@end
