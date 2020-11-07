//
//  NSTimer+EFBlockSupport.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSTimer (EFBlockSupport)

/**
 使用 ef_scheduledTimerWithTimeInterval: block: repeats: 来避免循环引用

 @param interval 循环周期
 @param block 执行块
 @param repeats 是否循环执行
 @return 返回 NSTimer 实体
 */
+ (NSTimer *)ef_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(void))block repeats:(BOOL)repeats;

@end
