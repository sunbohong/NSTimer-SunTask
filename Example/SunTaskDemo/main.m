//
//  main.m
//  SunTaskDemo
//
//  Created by sunbohong on 16/8/15.
//  Copyright © 2016年 sunbohong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import <FBAllocationTracker/FBAllocationTrackerManager.h>

int main(int argc, char *argv[]) {
    [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
    [[FBAllocationTrackerManager sharedManager] enableGenerations];

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
