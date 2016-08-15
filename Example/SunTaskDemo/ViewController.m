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
    [super dealloc];
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


// static SunButton *subview;


- (void)viewDidLoad {
    [super viewDidLoad];

    /**
     *  在 ARC 下面，因为 UITouch 会强引用 UIView。导致UIView延迟释放。通过查看 subview 的生命释放周期，可以证明该问题。
     *  当前源文件已经改为 MRR 环境。所以将此行代码注释。
     */


    {
//        subview = [[SunButton alloc] initWithFrame:CGRectInset(self.view.bounds, 100, 100)];
//
//        subview.backgroundColor = [UIColor redColor];
//        [self.view addSubview:subview];
    }


    // 双指单击
    [self.view bk_whenDoubleTapped:^(){
         if(self.stackView) return;

         {
             UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:[NSMutableArray array]];

             stackView.axis = UILayoutConstraintAxisVertical;
             stackView.spacing = 20;
             stackView.distribution = UIStackViewDistributionFill;
             stackView.alignment = UIStackViewAlignmentCenter;

             self.stackView = stackView;
             [self.view addSubview:self.stackView];
             [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
                  make.center.mas_equalTo(CGPointMake(0, 0));
              }];
         }


         // 计数器

         [self.stackView addArrangedSubview:^(){
              self.countLabel = [SunLabel new];
              {
                  self.countLabel.text = @"0";
              }
              return self.countLabel;
          } ()];


         // 开始&暂停

         [self.stackView addArrangedSubview:^(){

              UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:[NSMutableArray array]];
              {
                  stackView.axis = UILayoutConstraintAxisHorizontal;
                  stackView.spacing = 20;
                  stackView.distribution = UIStackViewDistributionFill;
                  stackView.alignment = UIStackViewAlignmentCenter;
              }
              [stackView addArrangedSubview:^(){
                   SunButton *button = [SunButton buttonWithType:UIButtonTypeSystem];
                   [button setTitle:@"开始" forState:UIControlStateNormal];

                   [button bk_addEventHandler:^(id sender) {
                        if(!self.timer) {
                            self.timer = [NSTimer sun_scheduleAfter:0.3 repeatingEvery:1 action:^{
                                              self.countLabel.text = [NSString stringWithFormat:@"%@", @([self.countLabel.text integerValue]+1)];
                                          }];
                        }
                    } forControlEvents:UIControlEventTouchUpInside];

                   return button;
               } ()];

              [stackView addArrangedSubview:^(){
                   SunButton *button = [SunButton buttonWithType:UIButtonTypeSystem];
                   [button setTitle:@"停止" forState:UIControlStateNormal];

                   [button bk_addEventHandler:^(id sender) {
                        [self.timer invalidate];
                        [self.timer release];

                        [self.stackView removeFromSuperview];
                        [self.stackView release];
                        self.stackView = nil;

                        [self.countLabel release];
                        self.countLabel = nil;
                    } forControlEvents:UIControlEventTouchUpInside];

                   return button;
               } ()];

              return [stackView autorelease];
          } ()];


         // 暂停&恢复
         [self.stackView addArrangedSubview:^(){

              UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:[NSMutableArray array]];
              {
                  stackView.axis = UILayoutConstraintAxisHorizontal;
                  stackView.spacing = 20;
                  stackView.distribution = UIStackViewDistributionFill;
                  stackView.alignment = UIStackViewAlignmentCenter;
              }

              [stackView addArrangedSubview:^(){
                   SunButton *button = [SunButton buttonWithType:UIButtonTypeSystem];
                   [button setTitle:@"暂停" forState:UIControlStateNormal];

                   [button bk_addEventHandler:^(id sender) {
                        [self.timer sun_pause];
                    } forControlEvents:UIControlEventTouchUpInside];

                   return button;
               } ()];

              [stackView addArrangedSubview:^(){
                   SunButton *button = [SunButton buttonWithType:UIButtonTypeSystem];
                   [button setTitle:@"恢复" forState:UIControlStateNormal];

                   [button bk_addEventHandler:^(id sender) {
                        [self.timer sun_resume];
                    } forControlEvents:UIControlEventTouchUpInside];

                   return button;
               } ()];

              return [stackView autorelease];
          } ()];
     }];
}

//    - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//        [subview removeFromSuperview];
//        [subview release];
//        subview = nil;
//    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
