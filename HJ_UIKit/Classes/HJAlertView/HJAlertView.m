//
//  HJAlertView.m
//  Loan
//
//  Created by muzhenhua on 16/6/20.
//  Copyright © 2016年 ZhiLi. All rights reserved.
//

#import "HJAlertView.h"
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import "NSBundle+HJAlertView.h"
#import "HJPriorityManager.h"

#define CenterViewEdgePadding 40
#define CenterViewPaddingInset 18

@interface HJAlertView()

@property (strong, nonatomic)  UIView *maskLayer;
@property (strong, nonatomic)  UIView *centerView;
@property (strong, nonatomic)  UIButton *confirmButton;
@property (strong, nonatomic)  UIButton *cancelButton;
@property (strong, nonatomic)  UIButton *closeButton;
@property (strong, nonatomic)  UIView *line1;
@property (strong, nonatomic)  UIView *line2;
@property (nonatomic, strong) UIWindow *window;

@end

@implementation HJAlertView

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
                  confirmBlock:(void(^)(void))confirmBlock {
    return [self initWithTitle:title message:message cancelButtonTitle:nil confirmButtonTitle:confirmButtonTitle cancelBlock:nil confirmBlock:confirmBlock];
}


- (HJAlertView *)initWithTitle:(NSString *)title
              attributeMessage:(NSAttributedString *)attributeMessage
            confirmButtonTitle:(NSString *)confirmButtonTitle
                  confirmBlock:(void (^)(void))confirmBlock{
    return [self initWithTitle:title attributeMessage:attributeMessage cancelButtonTitle:nil confirmButtonTitle:confirmButtonTitle cancelBlock:nil confirmBlock:confirmBlock];
}


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
                  confirmBlock:(void(^)(void))confirmBlock {
    
    return [self initWithTitle:title message:message cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" cancelBlock:cancelBlock confirmBlock:confirmBlock];
}

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
                   confirmBlock:(void(^)(void))confirmBlock {
    message = message?:@"";
    
    return [[HJAlertView alloc] initWithTitle:title
                             attributeMessage:(NSAttributedString *)message
                            cancelButtonTitle:cancelButtonTitle
                           confirmButtonTitle:confirmButtonTitle
                                  cancelBlock:cancelBlock
                                 confirmBlock:confirmBlock];
}

/**
 实例化方法
 
 @param title 标题，在无右上角“X”按钮的情况下为加粗样式
 @param attributeMessage 提示内容
 @param cancelButtonTitle 取消按钮的文案
 @param confirmButtonTitle 确定按钮的文案
 @param cancelBlock 取消的操作
 @param confirmBlock 确定的操作
 @return 实例化弹窗对象
 */
- (HJAlertView *)initWithTitle:(NSString *)title
              attributeMessage:(NSAttributedString *)attributeMessage
             cancelButtonTitle:(NSString *)cancelButtonTitle
            confirmButtonTitle:(NSString *)confirmButtonTitle
                   cancelBlock:(void(^)(void))cancelBlock
                  confirmBlock:(void(^)(void))confirmBlock {
    self = [[HJAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    [self setupSubViews];
    
    // 如果没有title，则调整约束
    if (title && title.length > 0) {
        self.titleLabel.text = title;
        [self.titleLabel sizeToFit];
    }else{
        [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
        }];
    }
    
    // 披着NSAttributedString外衣的NSString
    if ([attributeMessage isKindOfClass:[NSString class]]) {
        NSString *message = (NSString *)attributeMessage;
        // 如果没有message,调整约束
        if (!message || message.length == 0) {
            [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom);
            }];
        }
        
        // 设置弹窗文案
        if (message) {
            self.messageLabel.text = message;
            [self.messageLabel sizeToFit];
        }
    } else {
        // 如果没有message,调整约束
        if (!attributeMessage.string || attributeMessage.string.length == 0) {
            [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom);
            }];
        }
        if (attributeMessage) {
            self.messageLabel.attributedText = attributeMessage;
        }
    }
    
    if (cancelButtonTitle && cancelButtonTitle.length > 0) {
        if (confirmButtonTitle && confirmButtonTitle.length > 0) {
            [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        }else{
            [self.confirmButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        }
    }else {
        [self.line2 removeFromSuperview];
        [self.cancelButton removeFromSuperview];
        [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line1.mas_bottom);
            make.left.right.bottom.mas_equalTo(self.centerView);
            make.height.mas_equalTo(45);

        }];
    }
    
    if (confirmButtonTitle  && confirmButtonTitle.length > 0) {
        [self.confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
    }
    
    self.cancelBlock = cancelBlock;
    self.confirmBlock = confirmBlock;
    
    return self;
}

// 根据revokable设置“X”按钮是否可见，如果不可见，标题为粗体
- (void)setRevokable:(BOOL)revokable {
    
    _revokable = revokable;
    
    if (revokable) {
        if (revokable) {
            self.closeButton.hidden = NO;
            self.titleLabel.font = [UIFont systemFontOfSize:18];
        }
    }
}


- (HJAlertView *)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle{
    
    return [self initWithTitle:title
                       message:message
             cancelButtonTitle:cancelButtonTitle
            confirmButtonTitle:confirmButtonTitle
                   cancelBlock:nil
                  confirmBlock:nil];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (_forceRead) {
        [self startTime:3 title:_confirmButton.titleLabel.text];
    }
}

- (void)show {
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [window makeKeyAndVisible];
    [window endEditing:YES];
    self.window = window;

    [window addSubview:self];
    self.frame = [UIScreen mainScreen].bounds;
}

#pragma mark - ForceRead methods

-(void)startTime:(NSUInteger )timeout title:(NSString *)tittle {
    __block NSUInteger timeOut=timeout; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                 [_confirmButton setTitle:tittle forState:UIControlStateNormal];
                 [_confirmButton setTitleColor:[UIColor colorWithRed:48.0/255.f green:151.0/255.f blue:253.0/255.f alpha:1] forState:UIControlStateNormal];
                 _confirmButton.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = @(timeOut).stringValue;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSString *buttonString = [NSString stringWithFormat:@"%@(%@s)",tittle,strTime];
                [_confirmButton setTitle:buttonString forState:UIControlStateNormal];
                [_confirmButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                _confirmButton.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - action method

- (void)onCloseBtnClick {
    // 判断keepAlive属性，如果为真，clickBlock不置空，可多次调用，且不隐藏弹窗（支持优先级高的弹窗顶替）
    if (_cancelBlock) {
        _cancelBlock();
    }
    if (!self.keepAlive) {
        _cancelBlock = nil;
        [self dismissManually:YES];
    }
}

- (void)onConfirmBtnClick {
    // 判断keepAlive属性，如果为真，clickBlock不置空，可多次调用，且不隐藏弹窗（支持优先级高的弹窗顶替）
    if (_confirmBlock) {
        _confirmBlock();
    }
    if (!self.keepAlive) {
        _confirmBlock = nil;
        [self dismissManually:YES];
    }
}

// 隐藏
- (void)hide{
    if (_cancelBlock) {
        _cancelBlock();
        _cancelBlock = nil;
    }
    [self dismissManually:YES];
}

- (void)dismissManually:(BOOL)isManual {
    [self removeFromSuperview];
    
    [[HJPriorityManager sharedManager] dismissCurrentAlertViewManually:isManual];
}

#pragma mark - LNAlertProtocol

- (NSInteger)level {
    return self.alertLevel;
}

- (void)dismissWithCompletion:(void (^)(void))completionBlock {
    [self dismissManually:NO];
    if (completionBlock) {
        completionBlock();
    }
}

#pragma mark - Getter

/**
 界面初始化
 */
- (void)setupSubViews {
    
    [self addSubview:[self maskLayer]];
    [self addSubview:[self centerView]];
    
    [[self maskLayer] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [[self centerView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(CenterViewEdgePadding);
        make.right.mas_equalTo(self.mas_right).offset(-CenterViewEdgePadding);
        make.top.mas_equalTo(self.titleLabel.mas_top).offset(-CenterViewPaddingInset);
        make.bottom.mas_equalTo(self.line2.mas_bottom);
    }];
}

- (UIView *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [[UIView alloc] init];
        _maskLayer.backgroundColor = [UIColor blackColor];
        _maskLayer.alpha = 0.6;
    }
    return _maskLayer;
}

- (UIView *)centerView {
    
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerView.layer.cornerRadius = 8.0;
        
        [_centerView addSubview:self.titleLabel];
        [_centerView addSubview:self.messageLabel];
        [_centerView addSubview:self.line1];
        [_centerView addSubview:self.line2];
        [_centerView addSubview:self.cancelButton];
        [_centerView addSubview:self.confirmButton];
        [_centerView addSubview:self.closeButton];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.centerView.mas_top).offset(CenterViewPaddingInset);
            make.left.mas_equalTo(self.centerView.mas_left).offset(CenterViewPaddingInset);
            make.right.mas_equalTo(self.centerView.mas_right).offset(-CenterViewPaddingInset);
        }];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(self.centerView.mas_left).offset(CenterViewPaddingInset);
            make.right.mas_equalTo(self.centerView.mas_right).offset(-CenterViewPaddingInset);
        }];
        
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.messageLabel.mas_bottom).offset(CenterViewPaddingInset);
            make.left.right.mas_equalTo(self.centerView);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line1.mas_bottom);
            make.centerX.mas_equalTo(self.centerView);
            make.size.mas_equalTo(CGSizeMake(0.5, 45));
        }];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.line2);
            make.left.mas_equalTo(self.centerView.mas_left);
            make.right.mas_equalTo(self.line2.mas_left);
        }];
        
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.line2);
            make.right.mas_equalTo(self.centerView.mas_right);
            make.left.mas_equalTo(self.line2.mas_right);
        }];
        
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(self.centerView);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
    }

    return _centerView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 2 * (CenterViewPaddingInset + CenterViewEdgePadding);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (YYLabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[YYLabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 2 * (CenterViewPaddingInset + CenterViewEdgePadding);
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _messageLabel;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
    }
    return _line2;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelButton setTitleColor:[UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_confirmButton setTitleColor:[UIColor colorWithRed:48.0/255.f green:151.0/255.f blue:253.0/255.f alpha:1] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(onConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[NSBundle my_bundleImageNamed:@"alert_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(onCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


@end
