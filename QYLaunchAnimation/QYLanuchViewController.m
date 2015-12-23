//
//  QYLanuchViewController.m
//  BlueRhino
//
//  Created by 千叶 on 15/4/1.
//  Copyright (c) 2015年 qianye. All rights reserved.
//

#import "QYLanuchViewController.h"
#import "NSString+WPAttributedMarkup.h"
#import "UIViewExt.h"

#define kNavColor [UIColor colorWithRed:81/255.f green:196/255.f blue:212/255.f alpha:1.0]
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

@interface QYLanuchViewController ()<UIScrollViewDelegate>

@end

@implementation QYLanuchViewController
{
    UIImageView *_bgView;
    UIScrollView *_contentScrollVeiw;
    
    // 第一页标签
    UIButton *_messageImage;
    UILabel *_messageLabelOne;
    UILabel *_messageLabelTwo;
    // 第二页标签
    UIButton *_messageImage2;
    UILabel *_messageLabelOne2;
    UILabel *_messageLabelTwo2;
    // 第三页
    UIButton *_messageImage3;
    UILabel *_messageLabelOne3;
    // 第四页
    UIButton *_messageImage4;
    
    // 显示页数
    UIPageControl *_launchPage;
    
    // 当前的页数
    int _pageIndex;
    
    // 引导页图片
    NSArray *_imageArray;
    
    // 字体
    NSDictionary *_style;
    
    // 标签缩回的比例
    // 第二行
    CGFloat _moveScale1;
    // 第一行
    CGFloat _moveScale2;
    
    // 记录手指停下来时的偏移量 用于判断当前是在向左滑还是右滑
    CGFloat _currentOffset;
    // 判断左右滑动
    BOOL _isScrollRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yindao_bg"]];
    _pageIndex = 0;
    // Do any additional setup after loading the view.
    // 配置数据
    _imageArray = @[@"yindao_content_1",@"yindao_content_2",@"yindao_content_3"];
    _style = @{
               @"body":[UIFont fontWithName:@"HelveticaNeue" size:16.0],
               @"bold":[UIFont boldSystemFontOfSize:16],
               @"color": kNavColor,
               @"lightgray" : [UIColor lightGrayColor]
               };
    _moveScale1 = 20 / (kDeviceWidth - 20);
    _moveScale2 = 20 / (kDeviceWidth - 40);
    _currentOffset = 0.0;
    // 初始化视图
    [self _initWihtView];
}

#pragma mark - 视图创建
- (void)_initWihtView
{
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 150, kDeviceWidth - 80, KDeviceHeight - 150)];
    _bgView.image = [UIImage imageNamed:@"yindao_phoneBg"];
    [self.view addSubview:_bgView];
    
    
    // 活动内容
    _contentScrollVeiw = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    _contentScrollVeiw.delegate = self;
    _contentScrollVeiw.contentSize = CGSizeMake(kDeviceWidth * 4, KDeviceHeight);
    _contentScrollVeiw.pagingEnabled = YES;
    _contentScrollVeiw.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentScrollVeiw];
    
    // 添加分页标签
    _launchPage = [[UIPageControl alloc] initWithFrame:CGRectMake((kDeviceWidth - 60) / 2.0, 0, 60, 20)];
    _launchPage.numberOfPages = 4;
    _launchPage.userInteractionEnabled = NO;
    _launchPage.pageIndicatorTintColor = [UIColor lightGrayColor];
    _launchPage.currentPageIndicatorTintColor = kNavColor;
    [self.view addSubview:_launchPage];
    
    // 添加内容提示
    // 第一页
    _messageImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, kDeviceWidth, 26)];
    [_messageImage setImage:[UIImage imageNamed:@"yindao_myPosition"] forState:UIControlStateNormal];
    _messageImage.userInteractionEnabled = NO;
    [self.view addSubview:_messageImage];
    _messageLabelOne = [[UILabel alloc] initWithFrame:CGRectMake(0, _messageImage.bottom + 10, kDeviceWidth, 20)];
    _messageLabelOne.attributedText = [@"<bold>直观</bold> <lightgray>马上服务</lightgray>" attributedStringWithStyleBook:_style];
    _messageLabelOne.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_messageLabelOne];
    _messageLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(0, _messageLabelOne.bottom + 5, kDeviceWidth, 20)];
    _messageLabelTwo.attributedText = [@"<lightgray>实时为您展示</lightgray><color>司机位置</color>" attributedStringWithStyleBook:_style];
    _messageLabelTwo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_messageLabelTwo];
    
    // 第二页
    _messageImage2 = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth, 30, kDeviceWidth, 36)];
    [_messageImage2 setImage:[UIImage imageNamed:@"yindao_car"] forState:UIControlStateNormal];
    _messageImage2.userInteractionEnabled = NO;
    [self.view addSubview:_messageImage2];
    _messageLabelOne2 = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth, _messageImage2.bottom + 10, kDeviceWidth, 20)];
    _messageLabelOne2.attributedText = [@"<bold>车型</bold> <lightgray>分城市</lightgray><color>扩充车型</color>" attributedStringWithStyleBook:_style];
    _messageLabelOne2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_messageLabelOne2];
    _messageLabelTwo2 = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth, _messageLabelOne2.bottom + 5, kDeviceWidth, 20)];
    _messageLabelTwo2.attributedText = [@"<lightgray>方便您的用车选择</lightgray>" attributedStringWithStyleBook:_style];
    _messageLabelTwo2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_messageLabelTwo2];
    
    // 第三页
    _messageImage3 = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth, 40, kDeviceWidth, 26)];
    [_messageImage3 setImage:[UIImage imageNamed:@"yindao_heart"] forState:UIControlStateNormal];
    _messageImage3.userInteractionEnabled = NO;
    [self.view addSubview:_messageImage3];
    _messageLabelOne3 = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth, _messageImage3.bottom + 10, kDeviceWidth, 20)];
    _messageLabelOne3.attributedText = [@"<bold>收藏</bold> <color>优先派单</color><lightgray>给您收藏的司机</lightgray>" attributedStringWithStyleBook:_style];
    _messageLabelOne3.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_messageLabelOne3];
    
    // 第四页
    _messageImage4 = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth, KDeviceHeight / 2.0 - 60 - 52, kDeviceWidth, 105)];
    [_messageImage4 setImage:[UIImage imageNamed:@"yindao_logo"] forState:UIControlStateNormal];
    _messageImage4.userInteractionEnabled = NO;
    [self.view addSubview:_messageImage4];
    
    
    CGFloat imageHeight = 0.0;
    if (KDeviceHeight == 480) {
        imageHeight = 210;
    }else if (KDeviceHeight == 568) {
        imageHeight = 220;
    }else {
        imageHeight = 235;
    }
    // 添加内容信息
    for (int i = 0; i< 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60 + kDeviceWidth * i, imageHeight, kDeviceWidth - 120, ( 568 / 320.0) * (kDeviceWidth - 120))];
        imageView.image = [UIImage imageNamed:_imageArray[i]];
        [_contentScrollVeiw addSubview:imageView];
    }
    // 添加开启应用按钮
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(3 * kDeviceWidth + (kDeviceWidth - 192) / 2.0, KDeviceHeight / 2.0 + 60, 192, 45);
    [startBtn setImage:[UIImage imageNamed:@"yindao_button"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentScrollVeiw addSubview:startBtn];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    _pageIndex = offsetX / kDeviceWidth;
    _launchPage.currentPage = _pageIndex;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat isScrollRight = offsetX - _currentOffset;
    if (offsetX <= 0) {
        _bgView.left = 40 - offsetX;
    }else if (offsetX >= 2 * kDeviceWidth && offsetX <= 3 * kDeviceWidth) {
        _bgView.right = kDeviceWidth - 40 - (offsetX - 2 * kDeviceWidth);
    }
    
    // 控制标题位移
    // 第一页
    if (offsetX <= kDeviceWidth) {
        _messageLabelTwo.left = - offsetX;
        if (offsetX <= 0) {
            _messageLabelOne.left = ABS(offsetX) >= 20 ? (_messageLabelTwo.left - 20 + _moveScale1 * (- offsetX - 20)) : 0;
            _messageImage.left = ABS(offsetX) >= 40 ? (_messageLabelOne.left - 20 + _moveScale2 * (- offsetX - 40)) : 0;
        }else {
            _messageLabelOne.left = ABS(offsetX) >= 20 ? (_messageLabelTwo.left + 20 - _moveScale1 * (offsetX - 20)) : 0;
            _messageImage.left = ABS(offsetX) >= 40 ?( _messageLabelOne.left + 20 - _moveScale2 * (offsetX - 40)) : 0;
        }
    }
    
    // 第二页
    if (offsetX <= kDeviceWidth * 2 && offsetX >= 0) {
        _messageLabelTwo2.left = kDeviceWidth - offsetX;
        if (offsetX <= kDeviceWidth && isScrollRight > 0) {
            _messageLabelOne2.left = ABS(offsetX) >= 20 ? (_messageLabelTwo2.left - 20 + _moveScale1 * (offsetX - 20)): kDeviceWidth;
            _messageImage2.left = ABS(offsetX) >= 40 ? (_messageLabelOne2.left - 20 + _moveScale2 * (offsetX - 40)): kDeviceWidth;
        }else if (offsetX <= kDeviceWidth && isScrollRight < 0) {
            // 手指向右滑动
            _messageLabelOne2.left = ABS(offsetX - kDeviceWidth) >= 20 ? (_messageLabelTwo2.left - 20 + _moveScale1 * (kDeviceWidth - offsetX - 20)) : 0;
            _messageImage2.left = ABS(offsetX - kDeviceWidth) >= 40 ? (_messageLabelOne2.left - 20 + _moveScale2 * (kDeviceWidth - offsetX - 40)) : 0;
        }else {
            _messageLabelOne2.left = ABS(offsetX - kDeviceWidth) >= 20 ? (_messageLabelTwo2.left + 20 - _moveScale1 * (offsetX - kDeviceWidth - 20)): 0;
            _messageImage2.left = ABS(offsetX - kDeviceWidth) >= 40 ? (_messageLabelOne2.left + 20  - _moveScale2 * (offsetX - kDeviceWidth - 40)): 0;
        }
    }
    
    // 第三页
    if (offsetX <= kDeviceWidth * 3 && offsetX >= kDeviceWidth) {
        _messageLabelOne3.left = kDeviceWidth * 2 - offsetX;
        if (offsetX <= kDeviceWidth * 2 && isScrollRight > 0) {
            _messageImage3.left = ABS(offsetX - kDeviceWidth) >= 20 ? (_messageLabelOne3.left - 20 + _moveScale1 * (offsetX - kDeviceWidth - 20)): kDeviceWidth;
        }else if (offsetX <= kDeviceWidth * 2 && isScrollRight < 0){
            _messageImage3.left = ABS(offsetX - kDeviceWidth * 2) >= 20 ? (_messageLabelOne3.left - 20 + _moveScale1 * (2 * kDeviceWidth - offsetX - 20)) : 0;
        }else {
            _messageImage3.left = ABS(offsetX - kDeviceWidth * 2) >= 20 ? (_messageLabelOne3.left + 20  - _moveScale1 * (offsetX - kDeviceWidth * 2 - 20)): 0;
        }
    }
    
    // 第四页
    if (offsetX <= kDeviceWidth * 4 && offsetX >= kDeviceWidth *2) {
        if (offsetX <= kDeviceWidth * 3 && isScrollRight > 0) {
            _messageImage4.left = ABS(offsetX - kDeviceWidth * 2) >= 40 ? (kDeviceWidth * 3 - offsetX - 20 + _moveScale2 * (offsetX - kDeviceWidth * 2 - 40)): kDeviceWidth;
        }else if (offsetX <= kDeviceWidth * 3 && isScrollRight < 0) {
            _messageImage4.left = ABS(offsetX - kDeviceWidth * 3) >= 40 ? (kDeviceWidth * 3 - offsetX - 40 + _moveScale2 * (3 * kDeviceWidth - offsetX - 40)) : 0;
        }else {
            _messageImage4.left = ABS(offsetX - kDeviceWidth * 3) >= 20 ? (kDeviceWidth * 3 - offsetX + 20  - _moveScale1 * (offsetX - kDeviceWidth * 3 - 20)): 0;
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _currentOffset = scrollView.contentOffset.x;
}

#pragma mark - 按钮点击事件
- (void)startAction:(UIButton *)sender
{
    [_contentScrollVeiw scrollRectToVisible:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight) animated:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
