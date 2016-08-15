//
//  ViewController.m
//  SunTaskDemo
//
//  Created by sunbohong on 16/8/15.
//  Copyright © 2016年 sunbohong. All rights reserved.
//

#import "ViewController.h"

@interface SunButton : UIButton

@end

@implementation SunButton;

- (void)dealloc {
    NSLog(@"%@", self);
}

@end

@interface SunLabel : UILabel

@end

@implementation SunLabel;

@end

@import NSTimer_SunTask;
@import Masonry;
@import BlocksKit;

@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) SunLabel *countLabel;
@property (nonatomic, strong) UIStackView *stackView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 双指单击
    [self.view bk_whenDoubleTapped:^(){
         if(self.stackView) return;

         {
             UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:[NSMutableArray array]];

             stackView.axis = UILayoutConstraintAxisHorizontal;
             stackView.spacing = 8;
             stackView.distribution = UIStackViewDistributionFill;
             stackView.alignment = UIStackViewAlignmentFirstBaseline;

             self.stackView = stackView;
         }

         self.countLabel = [SunLabel new];
         {
             self.countLabel.text = @"0";
             [self.stackView addArrangedSubview:self.countLabel];
         }

         SunButton *startButton = [SunButton buttonWithType:UIButtonTypeSystem];
         {
             [startButton setTitle:@"开始" forState:UIControlStateNormal];
             [startButton bk_addEventHandler:^(id sender) {
                  if(!self.timer) {
                      self.timer = [NSTimer sun_scheduleAfter:0.3 repeatingEvery:1 action:^{
                                        self.countLabel.text = [NSString stringWithFormat:@"%@", @([self.countLabel.text integerValue]+1)];
                                    }];
                  }
              } forControlEvents:UIControlEventTouchUpInside];

             [self.stackView addArrangedSubview:startButton];
         }

         SunButton *stopButton = [SunButton buttonWithType:UIButtonTypeSystem];
         {
             [stopButton setTitle:@"停止" forState:UIControlStateNormal];

             [stopButton bk_addEventHandler:^(id sender) {
                  [self.timer invalidate];
                  self.timer = nil;
                  [self.stackView removeFromSuperview];
                  self.stackView = nil;
                  self.countLabel = nil;
              } forControlEvents:UIControlEventTouchUpInside];

             [self.stackView addArrangedSubview:stopButton];
             [self.view addSubview:self.stackView];
         }

         [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.center.mas_equalTo(CGPointMake(0, 0));
          }];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
