//
//  YNPageControlView.h
//  YNWPageTest
//
//  Created by ynwang on 16/6/14.
//  Copyright © 2016年 ynwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ComplecationBlock)(int index);

@interface YNPageControlView : UIView

@property (strong, nonatomic) NSArray *imagesArray;

- (void) loadCustomViews:(UIView *) superView complecationBlock:(ComplecationBlock) complecationBlock;

@property (copy, nonatomic)ComplecationBlock complecationBlock;
@end
