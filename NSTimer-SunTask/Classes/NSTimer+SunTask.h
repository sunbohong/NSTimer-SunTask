//
//  NSTimer+SunTask.h
//  NSTimer+SunTask
//
//  Created by sunbohong on 16/8/9.
//  Copyright © 2016年 sunbohong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  本分类用于扩展NSTimer对定期任务的支持
 */
@interface NSTimer (SunTask)

/**
 *  返回一个重复任务的实例
 *
 *  @param afterTimeInterval 延迟触发间隔
 *  @param timeInterval 触发时间间隔
 *  @param block        任务
 *
 *  @return <#return value description#>
 */
+ (instancetype)sun_scheduleAfter:(NSTimeInterval)afterTimeInterval repeatingEvery:(NSTimeInterval)timeInterval action:(dispatch_block_t)block;

/**
 *  立即执行任务，并在**interval**后再次执行任务
 */
- (void)sun_fire;

/**
 *  修改距离下次的触发时间的间隔
 *
 *  @param afterTimeInterval 下次的触发时间的间隔
 */
- (void)sun_fireAfter:(NSTimeInterval)afterTimeInterval;

/**
 *  不会破坏当前的定时任务，执行block后，才会修改间隔。例：原间隔为10s，新的间隔为30s，当前剩余5s执行block。当5s后执行完block，新的间隔才会生效。
 *
 *  @param interval 新的时间间隔
 */
- (void)sun_setInterval:(NSTimeInterval)interval;

/**
 *  更新任务
 *
 *  @param block 新的任务
 */
- (void)sun_setBlock:(dispatch_block_t)block;

/**
 *  获取当前的时间间隔
 *
 *  @return 获取当前的时间间隔
 */
- (NSTimeInterval)sun_timeInterval;

/**
 *  重新倒计时，在设定的间隔后，任务才会开始执行
 */
- (void)sun_resetCountDown;

/**
 *  暂停倒计时，
 */
- (void)sun_pause;

/**
 *  恢复计时，重新启动暂停的倒计时
 */
- (void)sun_resume;

@end
