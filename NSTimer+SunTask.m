//
//  NSTimer+SunTask.m
//  NSTimer+SunTask
//
//  Created by sunbohong on 16/8/9.
//  Copyright © 2016年 sunbohong. All rights reserved.
//

#import "NSTimer+SunTask.h"

NSString *const SUNTimerUserInfoBlockKey    = @"com.sunbohong.userinfo.block";
NSString *const SUNTimerUserInfoIntervalKey = @"com.sunbohong.userinfo.interval";

@interface NSTimer (SunPrivate)

+ (void)sun_executeBlockFromTimer:(NSTimer *)aTimer;

+ (void)sun_setupNextBlock:(NSTimer *)aTimer;

@end

@implementation NSTimer (SunPrivate)

+ (void)sun_executeBlockFromTimer:(NSTimer *)aTimer {
    dispatch_block_t block = (dispatch_block_t)aTimer.userInfo[SUNTimerUserInfoBlockKey];
    if(block) block();
    [self sun_setupNextBlock:aTimer];
}

+ (void)sun_setupNextBlock:(NSTimer *)aTimer {
    NSTimeInterval Interval = [(NSNumber *) aTimer.userInfo[SUNTimerUserInfoIntervalKey] doubleValue];
    [aTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:Interval]];
}

@end

@implementation NSTimer (SunTask)

+ (instancetype)sun_scheduleAfter:(NSTimeInterval)afterTimeInterval
                   repeatingEvery:(NSTimeInterval)Interval
                           action:(dispatch_block_t)block {
    return [NSTimer scheduledTimerWithTimeInterval:afterTimeInterval
                                            target:self selector:@selector(sun_executeBlockFromTimer:)
                                          userInfo:[NSMutableDictionary dictionaryWithDictionary:
                                                    @{
                                                      SUNTimerUserInfoBlockKey:[block copy],
                                                      SUNTimerUserInfoIntervalKey:@(Interval)
                                                      }
                                                    ]
                                           repeats:YES];
}

- (void)sun_fire {
    [self setFireDate:[NSDate date]];
    [[NSTimer class] sun_setupNextBlock:self];
}

- (void)sun_fireAfter:(NSTimeInterval)afterTimeInterval {
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:afterTimeInterval]];
    [[NSTimer class] sun_setupNextBlock:self];
}

- (void)sun_setInterval:(NSTimeInterval)interval {
    NSMutableDictionary *userInfo = (NSMutableDictionary *)self.userInfo;
    if([userInfo isKindOfClass:[NSMutableDictionary class]]) {
        userInfo[SUNTimerUserInfoIntervalKey] = @(interval);
    } else{
        NSLog(@"无效的%@，请使用%@生成NSTimer的实例", self, NSStringFromSelector(@selector(sun_scheduleAfter:repeatingEvery:action:)));
    }
}

- (NSTimeInterval)sun_timeInterval {
    return [self.userInfo[SUNTimerUserInfoIntervalKey] doubleValue];
}

- (void)pause {
    [self setFireDate:[NSDate distantFuture]];
}

@end
