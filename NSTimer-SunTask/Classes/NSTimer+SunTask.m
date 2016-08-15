//
//  NSTimer+SunTask.m
//  NSTimer+SunTask
//
//  Created by sunbohong on 16/8/9.
//  Copyright © 2016年 sunbohong. All rights reserved.
//

#import "NSTimer+SunTask.h"

// 是否由本分类生成
NSString *const SUNTimerUserInfoISSunTask = @"com.sunbohong.userinfo.issuntask";

// 保存传入的block
NSString *const SUNTimerUserInfoBlockKey = @"com.sunbohong.userinfo.block";

// 保存任务执行间隔
NSString *const SUNTimerUserInfoIntervalKey = @"com.sunbohong.userinfo.interval";

//保存暂停计时的剩余时间，用于恢复计时
NSString *const SUNTimerUserInfoCountDownKey = @"com.sunbohong.userinfo.countdown";

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
                                                        SUNTimerUserInfoISSunTask:@(YES),
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

- (void)sun_setBlock:(dispatch_block_t)block {
    if(![self _checkValied]) {
        return;
    }
    NSMutableDictionary *userInfo = (NSMutableDictionary *)self.userInfo;
    userInfo[SUNTimerUserInfoBlockKey] = [block copy];
}

- (void)sun_setInterval:(NSTimeInterval)interval {
    if(![self _checkValied]) {
        return;
    }

    NSMutableDictionary *userInfo = (NSMutableDictionary *)self.userInfo;
    userInfo[SUNTimerUserInfoIntervalKey] = @(interval);
}

- (NSTimeInterval)sun_timeInterval {
    return [self.userInfo[SUNTimerUserInfoIntervalKey] doubleValue];
}

- (void)sun_resetCountDown {
    if(![self _checkValied]) {
        return;
    }

    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:[self sun_timeInterval]]];

#ifdef DEBUG
    NSLog(@"当前日期:%@；fireDate:%@；时间间隔:%@", [NSDate date], self.fireDate, @([self sun_timeInterval]));
#endif
}

- (void)sun_pause {
    if(![self _checkValied]) {
        return;
    }

    NSMutableDictionary *userInfo = (NSMutableDictionary *)self.userInfo;

    if([userInfo.allKeys containsObject:SUNTimerUserInfoCountDownKey]) {
#ifdef DEBUG
        NSLog(@"已经处于暂停运行状态，无法再次暂停运行。您需要通过@selector(%@)恢复计时后，才能通过本方法再次暂停", NSStringFromSelector(@selector(sun_resume)));
#endif
        return;
    }

    userInfo[SUNTimerUserInfoCountDownKey] = @([[self fireDate] timeIntervalSinceNow]);

#ifdef DEBUG
    NSLog(@"暂停成功:当前日期:%@；原下次执行时间:fireDate:%@；原剩余时间:%@；", [NSDate date], self.fireDate, userInfo[SUNTimerUserInfoCountDownKey]);
#endif

    [self setFireDate:[NSDate distantFuture]];

#ifdef DEBUG
    NSLog(@"下次运行时间:%@", self.fireDate);
#endif
}

- (void)sun_resume {
    if(![self _checkValied]) {
        return;
    }

    NSMutableDictionary *userInfo = (NSMutableDictionary *)self.userInfo;

    if(![userInfo.allKeys containsObject:SUNTimerUserInfoCountDownKey]) {
#ifdef DEBUG
        NSLog(@"无法恢复运行。您需要通过@selector(%@)暂停计时，才能通过本方法再次计时", NSStringFromSelector(@selector(sun_pause)));
#endif
        return;
    }

    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:[userInfo[SUNTimerUserInfoCountDownKey] doubleValue]]];
    userInfo[SUNTimerUserInfoCountDownKey] = nil;
}

#pragma mark - private

- (BOOL)_checkValied {
    NSMutableDictionary *userInfo = (NSMutableDictionary *)self.userInfo;
    if([userInfo isKindOfClass:[NSMutableDictionary class]] && [userInfo.allKeys containsObject:SUNTimerUserInfoISSunTask]) {
        return YES;
    } else{
#ifdef DEBUG
        NSLog(@"无效的%@，请使用@selector(%@)生成NSTimer的实例", self, NSStringFromSelector(@selector(sun_scheduleAfter:repeatingEvery:action:)));
#endif
        return NO;
    }
}

@end
