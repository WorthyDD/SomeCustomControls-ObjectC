//
//  BannerView.m
//  EmployeeAssistant
//
//  Created by 武淅 段 on 16/9/9.
//  Copyright © 2016年 xxkuaipao. All rights reserved.
//

#import "BannerView.h"
#import "Tookit.h"
#import "constant.h"
#import <AFNetworking.h>
#import "BaseWebViewController.h"
#define time_interval 5.0

@interface BannerView()<UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
//@property (nonatomic) NSMutableArray<UIImageView *> *imageViews;    //永远放三个
@property (nonatomic) UIImageView *leftImageView;
@property (nonatomic) UIImageView *middletImageView;
@property (nonatomic) UIImageView *rightImageView;
@property (nonatomic) UIPageControl *pageControl;
@property (nonatomic) NSTimer *timer;   //定时器

@end
@implementation BannerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setBounces:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    _leftImageView = [self imageView];
    _middletImageView = [self imageView];
    _rightImageView = [self imageView];
    [_scrollView addSubview:_leftImageView];
    [_scrollView addSubview:_middletImageView];
    [_scrollView addSubview:_rightImageView];
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    [self addSubview:_pageControl];
    _pageControl.hidden = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:time_interval target:self selector:@selector(needScroll:) userInfo:nil repeats:YES];
    [_timer fire];
}

- (UIImageView *)imageView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapImage:)];
    [imageView addGestureRecognizer:tap];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    return imageView;
}

- (void) needScroll: (NSTimer *)timer
{
    if(!_imgUrls || _imgUrls.count<2){
        return;
    }
    //向右滚动
    NSInteger index = _pageControl.currentPage + 1;
    if(index > _imgUrls.count-1){
        index = 0;
    }
    _pageControl.currentPage = index;
    [_scrollView setContentOffset:CGPointMake(self.width*2, 0) animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    NSLog(@"layout subViews");
    _scrollView.frame = self.bounds;
    [_scrollView setContentSize:CGSizeMake(self.width*3, self.height)];
    _leftImageView.frame = CGRectMake(0, 0, self.width, self.height);
    _middletImageView.frame = CGRectMake(self.width, 0, self.width, self.height);
    _rightImageView.frame = CGRectMake(self.width*2, 0, self.width, self.height);
    
    [self updateImagesLocation];
    
}

- (void) updateImagesLocation
{
    //永远保持中间的位置
    [_scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
    _pageControl.hidden = _imgUrls.count <= 1;
    _pageControl.center = CGPointMake(self.centerX, self.height-_pageControl.height/2.0);
    _scrollView.scrollEnabled = _imgUrls.count > 1;
    
    if(!_imgUrls || _imgUrls.count == 0){
        //清空
        _leftImageView.image = nil;
        _middletImageView.image = nil;
        _rightImageView.image = nil;
        return;
    }
    
    //找到前后的对应的url 设置图片
    NSInteger currentIndex = _pageControl.currentPage;
    NSInteger leftIndex = currentIndex-1 < 0 ? _imgUrls.count-1 : currentIndex-1;
    NSInteger rightIndex = currentIndex+1 > _imgUrls.count-1 ? 0 : currentIndex+1;
    NSString *left = _imgUrls[leftIndex];
    NSString *middle = _imgUrls[currentIndex];
    NSString *right = _imgUrls[rightIndex];
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:left]];
    [_middletImageView sd_setImageWithURL:[NSURL URLWithString:middle]];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:right]];
}


- (void)setImgUrls:(NSArray<NSString *> *)imgUrls
{
    _imgUrls = imgUrls;
    [_pageControl setNumberOfPages:imgUrls.count];
    //回位 避免溢出
    if(_pageControl.currentPage > imgUrls.count-1){
        _pageControl.currentPage = 0;
    }
    
    [self setNeedsLayout];
}



#pragma mark -scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断是否滚动到边界
    CGFloat x = scrollView.contentOffset.x;
    if(x >= self.width*2){
        [self updateImagesLocation];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //循环滚动  判断滚动的方向
    
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = x/self.width;
    NSInteger n = _pageControl.currentPage;    //pagecontrol的位置
    if(index == 0){
        //向左滚动
        n--;
        if(n <0){
            n = _imgUrls.count-1;
        }
    }
    else if(index == 2){
        //向右滚动
        n++;
        if(n > _imgUrls.count-1){
            n = 0;
        }
    }
    [_pageControl setCurrentPage:n];

    [self updateImagesLocation];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //暂停计时器
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //恢复计时
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:time_interval]];
}


#pragma mark - click action

- (void) didTapImage : (UITapGestureRecognizer *)tap
{
    NSString *url = @"http://www.baidu.com";
    BaseWebViewController *webVC = [[BaseWebViewController alloc]init];
    webVC.urlString = url;
    
    if(_owner){
        [_owner.navigationController pushViewController:webVC animated:YES];
    }
}

- (void) dealloc
{
    [_timer invalidate];
    _timer = nil;
}

@end
