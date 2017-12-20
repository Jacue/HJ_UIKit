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

// 优先级,数组越大表示优先级越高
@property (nonatomic, assign) NSUInteger priorityLevel;

// 展现的操作
@property (nonatomic,copy) Block presentBlock;

// 消失的操作
@property (nonatomic,copy) Block dismissBlock;

@end
