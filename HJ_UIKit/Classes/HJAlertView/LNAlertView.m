//
//  LNAlertView.m
//  Loan
//
//  Created by muzhenhua on 16/6/20.
//  Copyright © 2016年 ZhiLi. All rights reserved.
//

#import "LNAlertView.h"
#import "TPCoreAnimationEffect.h"
#import <YYText/YYText.h>

@interface LNAlertView()
@property (weak, nonatomic) IBOutlet UILabel *myMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelTopPadding;

@end

@implementation LNAlertView

/**
 实例化方法
 
 @param title 标题，在无右上角“X”按钮的情况下为加粗样式
 @param message 提示内容
 @param confirmButtonTitle 确定按钮的文案
 @param confirmBlock 确定的操作
 @return 实例化弹窗对象
 */
- (LNAlertView *)initWithTitle:(NSString *)title
                       message:(NSString *)message
            confirmButtonTitle:(NSString *)confirmButtonTitle
                  confirmBlock:(void(^)(void))confirmBlock {
    return [self initWithTitle:title message:message cancelButtonTitle:nil confirmButtonTitle:confirmButtonTitle cancelBlock:nil confirmBlock:confirmBlock];
}


- (LNAlertView *)initWithTitle:(NSString *)title
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
- (LNAlertView *)initWithTitle:(NSString *)title
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
- (LNAlertView *)initWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
            confirmButtonTitle:(NSString *)confirmButtonTitle
                   cancelBlock:(void(^)(void))cancelBlock
                   confirmBlock:(void(^)(void))confirmBlock {
    message = message?:@"";
    
    return [[LNAlertView alloc] initWithTitle:title
                             attributeMessage:(NSAttributedString *)message
                            cancelButtonTitle:cancelButtonTitle
                           confirmButtonTitle:confirmButtonTitle
                                  cancelBlock:cancelBlock
                                 confirmBlock:confirmBlock];
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
- (LNAlertView *)initWithTitle:(NSString *)title
              attributeMessage:(NSAttributedString *)attributeMessage
             cancelButtonTitle:(NSString *)cancelButtonTitle
            confirmButtonTitle:(NSString *)confirmButtonTitle
                   cancelBlock:(void(^)(void))cancelBlock
                  confirmBlock:(void(^)(void))confirmBlock {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 116;
    
    self.messageLabel = [[YYLabel alloc] init];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.preferredMaxLayoutWidth = maxWidth;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.messageLabel setFont:self.myMessageLabel.font];
    
    [self.myMessageLabel addSubview:self.messageLabel];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];

    // 如果没有title，则调整约束
    if (title && title.length > 0) {
        self.titleLabel.text = title;
    }else{
        self.messageLabelTopPadding.constant = 0;
    }
    
    // 披着NSAttributedString外衣的NSString
    if ([attributeMessage isKindOfClass:[NSString class]]) {
        NSString *message = (NSString *)attributeMessage;
        // 如果没有message,调整约束
        if (!message || message.length == 0) {
            self.messageLabelTopPadding.constant = 0;
        }
        
        // 设置弹窗文案
        if (message) {
            self.messageLabel.text = message;
        }
        
    } else {
        // 如果没有message,调整约束
        if (!attributeMessage.string || attributeMessage.string.length == 0) {
            self.messageLabelTopPadding.constant = 0;
        }
        
        // 设置弹窗文案，设置段落样式
        if (attributeMessage) {
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineSpacing = 6.0;
            NSMutableAttributedString *tempAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:attributeMessage];
            
            [tempAttributeString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle}
                                         range:NSMakeRange(0, attributeMessage.string.length)];
            
            self.messageLabel.attributedText = tempAttributeString;
        }
    }
    
    
    if (cancelButtonTitle && cancelButtonTitle.length > 0) {
        if (confirmButtonTitle && confirmButtonTitle.length > 0) {
            [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        }else{
            [self.confirmButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        }
    }else {
        [self.lineView removeFromSuperview];
        [self.cancelButton removeFromSuperview];
        [self.subView addConstraint:[NSLayoutConstraint constraintWithItem:self.confirmButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_subView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [self.subView layoutSubviews];
    }
    
    if (confirmButtonTitle  && confirmButtonTitle.length > 0) {
        [self.confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
    }
    
    self.closeButtonClickBlock = cancelBlock;
    self.confirmButtonClickBlock = confirmBlock;
    
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


- (LNAlertView *)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle{
    
    return [self initWithTitle:title
                       message:message
             cancelButtonTitle:cancelButtonTitle
            confirmButtonTitle:confirmButtonTitle
                   cancelBlock:nil
                  confirmBlock:nil];
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window endEditing:YES];
    
    [window addSubview:self];
    self.frame = [UIScreen mainScreen].bounds;
    if (_forceRead) {
        [self startTime:3 title:_confirmButton.titleLabel.text];
    }
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
                 [_confirmButton setTitleColor:RGBCOLORV(0x3097fd) forState:UIControlStateNormal];
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
- (IBAction)onCloseBtnClick {
    // 判断keepAlive属性，如果为真，clickBlock不置空，可多次调用，且不隐藏弹窗（支持优先级高的弹窗顶替）
    if (_closeButtonClickBlock) {
        _closeButtonClickBlock();
        if (!self.keepAlive) {
            _confirmButtonClickBlock = nil;
        }
    }
    if (!self.keepAlive) {
        [self dismissManually:YES];
    }
}

- (IBAction)onConfirmBtnClick {
    // 判断keepAlive属性，如果为真，clickBlock不置空，可多次调用，且不隐藏弹窗（支持优先级高的弹窗顶替）
    if (_confirmButtonClickBlock) {
        _confirmButtonClickBlock();
        if (!self.keepAlive) {
            _confirmButtonClickBlock = nil;
        }
    }
    if (!self.keepAlive) {
        [self dismissManually:YES];
    }
}


// 隐藏
- (void)hide{
    
    if (_closeButtonClickBlock) {
        _closeButtonClickBlock();
        _closeButtonClickBlock = nil;
    }

    [self dismissManually:YES];
}

- (void)dismissManually:(BOOL)isManual {

    [self removeFromSuperview];
    
    [[LNAlertManager sharedManager] dismissCurrentAlertViewManually:isManual];
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


@end
