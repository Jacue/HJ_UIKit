//
//  HJPriorityManageObject.h
//  HJ_UIKit
//
//  Created by Jacue on 2017/12/19.
//

#import <Foundation/Foundation.h>

@protocol HJPriorityProtocol;

typedef void(^Block)(void);

@interface HJPriorityManagedModel : NSObject

// 按优先级管理的对象
@property (nonatomic,strong) id<HJPriorityProtocol> managedObject;

// 展现的操作
@property (nonatomic,copy) Block presentBlock;

// 消失的操作
@property (nonatomic,copy) Block dismissBlock;

@end
