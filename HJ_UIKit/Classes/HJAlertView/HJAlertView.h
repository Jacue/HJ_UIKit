//
//  HJAlertView.h
//  Loan
//
//  Created by muzhenhua on 16/6/20.
//  Copyright © 2016年 ZhiLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYLabel.h>
#import "HJPriorityManager.h"

typedef void(^ClickBlock)(void);

@interface HJAlertView : UIView <HJPriorityProtocol>

// 提供设置“取消”、“确定”的block，避免在实例化方法中设置，导致代码块太大
@property (nonatomic, copy) ClickBlock confirmBlock;
@property (nonatomic, copy) ClickBlock cancelBlock;

// 提供给外部设置富文本
@property (strong, nonatomic)  YYLabel *titleLabel;
@property (strong, nonatomic) YYLabel *messageLabel;

// 强制阅读(confirmButton按钮效果)
@property (nonatomic, assign) BOOL forceRead;

// 弹窗优先级
@property (nonatomic, assign) NSInteger alertLevel;

// 是否展示右上角“X”按钮,默认不显示
@property (nonatomic, assign) BOOL revokable;

// 点击“确定”／“取消”弹框不消失，需要等到特定时机手动dismiss
@property (nonatomic, assign) BOOL keepAlive;

/**
 实例化方法
 
 @param title 标题，在无右上角“X”按钮的情况下为加粗样式
 @param message 提示内容
 @param confirmButtonTitle 确定按钮的文案
 @param confirmBlock 确定的操作
 @return 实例化弹窗对象
 */
- (HJAlertView *)initWithTitle:(NSString *)title
                       message:(NSString *)message
            confirmButtonTitle:(NSString *)confirmButtonTitle
                  confirmBlock:(void(^)(void))confirmBlock;

/**
 实例化方法
 
 @param title 标题，在无右上角“X”按钮的情况下为加粗样式
 @param attributeMessage 提示内容
 @param confirmButtonTitle 确定按钮的文案
 @param confirmBlock 确定的操作
 @return 实例化弹窗对象
 */
- (HJAlertView *)initWithTitle:(NSString *)title
              attributeMessage:(NSAttributedString *)attributeMessage
            confirmButtonTitle:(NSString *)confirmButtonTitle
                  confirmBlock:(void(^)(void))confirmBlock;

/**
 实例化方法
 
 @param title 标题，在无右上角“X”按钮的情况下为加粗样式
 @param message 提示内容
 @param cancelBlock 取消的操作
 @param confirmBlock 确定的操作
 @return 实例化弹窗对象
 */
- (HJAlertView *)initWithTitle:(NSString *)title
                       message:(NSString *)message
                   cancelBlock:(void(^)(void))cancelBlock
                  confirmBlock:(void(^)(void))confirmBlock;

/**
 实例化方法
 
 @param title 标题，在无右上角“X”按钮的情况下为加粗样式
 @param message 提示内容
 @param cancelButtonTitle 取消按钮的文案
 @param confirmButtonTitle 确定按钮的文案
 @param cancelBlock 取消的操作
 @param confirmBlock 确定的操作
 @return 实例化弹窗对象
 */
- (HJAlertView *)initWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
            confirmButtonTitle:(NSString *)confirmButtonTitle
                   cancelBlock:(void(^)(void))cancelBlock
                  confirmBlock:(void(^)(void))confirmBlock;

/**
 *	@brief	初始化方法
 *
 *	@param 	title 	标题
 *	@param 	message 	内容
 *	@param 	cancelButtonTitle 	左侧按钮名字
 *	@param 	confirmButtonTitle 	右侧按钮名字
 *
 *	@return	id UIAlertView
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle;

/**
 *	@brief	显示弹出框,加在keywindow上
 */
- (void)show;


/**
 代码触发的隐藏弹框，必定会消失
 */
- (void)hide;


@end
