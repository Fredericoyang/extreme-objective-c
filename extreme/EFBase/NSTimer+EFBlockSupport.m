//
//  NSTimer+EFBlockSupport.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "NSTimer+EFBlockSupport.h"

@implementation NSTimer (EFBlockSupport)

+ (NSTimer *)ef_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void(^)(void))block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(ef_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)ef_blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
