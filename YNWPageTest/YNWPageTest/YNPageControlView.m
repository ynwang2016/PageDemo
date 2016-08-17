//
//  YNPageControlView.m
//  YNWPageTest
//
//  Created by ynwang on 16/6/14.
//  Copyright © 2016年 ynwang. All rights reserved.
//

#import "YNPageControlView.h"
#import "Masonry.h"
#import "Define.h"

@interface YNPageControlView()<UIScrollViewDelegate>
{
    int _curPage;
    NSTimer *timer;
}


@end
@implementation YNPageControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) loadCustomViews:(UIView *) superView complecationBlock:(ComplecationBlock) complecationBlock
{
    _curPage = 0;
    superView.userInteractionEnabled = YES;
    self.frame = CGRectMake(0, 0, kWIDTH, 300);
    [superView addSubview:self];
    
    //1.scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    scrollView.pagingEnabled = YES;
    scrollView.tag = 1000;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentOffset = CGPointMake(kWIDTH, 0);
    scrollView.contentSize = CGSizeMake(kWIDTH * (_imagesArray.count + 2), 300);
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1.0;
    tap.numberOfTouchesRequired = 1;
    
    //第一张图片
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _imagesArray[_imagesArray.count - 1]]];
    //imageView1.contentMode = UIViewContentModeScaleToFill;
    imageView1.userInteractionEnabled = YES;
    [scrollView addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scrollView.mas_left).offset(0);
        make.top.mas_equalTo(scrollView.mas_top).offset(0);
        make.width.offset(kWIDTH);
        make.height.offset(300);
    }];
    [imageView1 addGestureRecognizer:tap];
    
    
    //2.imageView 中间的图片
    for (int i = 1; i < _imagesArray.count + 1; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:[_imagesArray objectAtIndex:(i - 1)]];
        //imageView.contentMode = UIViewContentModeScaleToFill;
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap1.numberOfTapsRequired = 1.0;
        tap1.numberOfTouchesRequired = 1;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(scrollView.mas_left).offset(i * kWIDTH);
            make.width.mas_equalTo(kWIDTH);
            make.height.mas_equalTo(kHEIGHT);
        }];
        
        [imageView addGestureRecognizer:tap1];
    }
    
    //最后一张图片
    UIImageView *imageview5 = [[UIImageView alloc] init];
    imageview5.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _imagesArray[0]]];
    //imageview5.contentMode = UIViewContentModeScaleToFill;
    [scrollView addSubview:imageview5];
    imageview5.userInteractionEnabled = YES;
    [imageview5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWIDTH *( _imagesArray.count + 1));
        make.top.mas_equalTo(scrollView.mas_top).offset(0);
        make.width.mas_equalTo(kWIDTH);
        make.height.mas_equalTo(300);
    }];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap2.numberOfTapsRequired = 1.0;
    tap2.numberOfTouchesRequired = 1;
    [imageview5 addGestureRecognizer:tap2];
    
    //3.uiPagecontrol
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.tag = 1001;
    pageControl.numberOfPages = _imagesArray.count;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [pageControl addTarget:self action:@selector(pageTurn) forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.height.mas_offset(30);
        make.width.mas_offset(100);
    }];
    
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(pageTurn) userInfo:nil repeats:YES];
    }
    
    _complecationBlock = complecationBlock;
    
}

- (void) pageTurn
{
    UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:1000];
    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:1001];
    [UIView transitionWithView:scrollView duration:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        CGFloat content = scrollView.contentOffset.x + kWIDTH;
        [scrollView setContentOffset:CGPointMake(content, 0)];
        CGPoint currentOffSet = scrollView.contentOffset;
        CGFloat num = currentOffSet.x / kWIDTH;
        
        pageControl.currentPage = num - 1;
        if (num == 0  ) {
            pageControl.currentPage = 4;
        }
        else if (num == 6) // num  =  6  表示第二个1号图片显示到屏幕上，表示用户想看第一张图片即第一个1号图片
        {
            pageControl.currentPage = 0;
        }

        
    } completion:^(BOOL finished) {
        
    }];
    
    if (scrollView.contentOffset.x > kWIDTH * self.imagesArray.count) {
        
        [scrollView setContentOffset:CGPointMake(kWIDTH, 0)];
    }
    
    //当偏移量小于第一张图片的偏移量偏移量变为最后一张图片的偏移量
    if (scrollView.contentOffset.x < kWIDTH) {
        [scrollView setContentOffset:CGPointMake(kWIDTH  * self.imagesArray.count, 0)];
    }
}


/**
 *  当scrollView减速停止的时候开始执行，在该方法中判断该显示第几张图片
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint currentOffSet = scrollView.contentOffset;
    NSLog(@"%@ ",NSStringFromCGPoint(currentOffSet));
    CGFloat num = currentOffSet.x / kWIDTH;
    NSLog(@"num = %f",num);
    
    // 设置页码
    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:1001];
    pageControl.currentPage = num - 1;
    
    // num = 0 表示第一个5号图片显示到屏幕上，表示用户想看最后一张图片，即第二个5号图片
    if (num == 0  ) {
      [scrollView setContentOffset:CGPointMake(5 * kWIDTH, 0)];
       pageControl.currentPage = 4;
    }
    else if (num == 6) // num  =  6  表示第二个1号图片显示到屏幕上，表示用户想看第一张图片即第一个1号图片
    {
       [scrollView setContentOffset:CGPointMake(1 * kWIDTH, 0)];
       pageControl.currentPage = 0;
    }
}


- (void) tapAction:(UITapGestureRecognizer *)tap
{
    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:1001];
    int page = (int)pageControl.currentPage;
    if (_complecationBlock) {
        _complecationBlock(page);
    }
}
- (void)dealloc
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
