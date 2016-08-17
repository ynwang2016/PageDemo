//
//  ViewController.m
//  YNWPageTest
//
//  Created by ynwang on 16/6/14.
//  Copyright © 2016年 ynwang. All rights reserved.
//

#import "ViewController.h"
#import "YNPageControlView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    YNPageControlView *pageControl = [[YNPageControlView alloc] init];
    pageControl.imagesArray = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg"];
    [pageControl loadCustomViews:self.view complecationBlock:^(int index) {
        NSLog(@"%d", index);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
