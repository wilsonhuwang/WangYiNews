//
//  ViewController.m
//  网易新闻
//
//  Created by wanghu on 16/5/25.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "ViewController.h"
#import "TKExampleViewController.h"

@interface ViewController () <UIScrollViewDelegate>
// 标题栏
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
// 内容栏
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@end

@implementation ViewController

static const int count = 9;
static const CGFloat labelRed = 0.4;
static const CGFloat labelGreen = 0.6;
static const CGFloat labelBlue = 0.7;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 设置内容栏
    [self setupContentScrollView];
    // 设置标题栏
    [self setupTitleScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
//    [self scrollViewDidScroll:self.contentScrollView];
//    [self.contentScrollView setContentOffset:CGPointZero animated:YES];
}

// 设置标题栏
- (void)setupTitleScrollView
{
    CGFloat w = 60;
    CGFloat h = self.titleScrollView.frame.size.height;
    CGFloat y = 0;
    for (int i = 0; i < count; i ++) {
        UILabel *label = [[UILabel alloc] init];
        CGFloat x = i * w;
        label.frame = CGRectMake(x, y, w, h);
        [self.titleScrollView addSubview:label];
        
        label.text = [NSString stringWithFormat:@"示例%d", i + 1];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0];
        label.textColor = [UIColor colorWithRed:labelRed green:labelGreen blue:labelBlue alpha:1.0];
        label.font = [UIFont systemFontOfSize:12];
        label.tag = i;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
        [label addGestureRecognizer:tap];
//         设置默认选中label scale
        if (i == 0) [self setLabel:label scale:1.0];
    }
    
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
}

- (void)tapLabel:(UITapGestureRecognizer*)tap
{
    int index = tap.view.tag;
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = self.contentScrollView.frame.size.width * index;
    [self.contentScrollView setContentOffset:offset animated:YES];
}

// 设置内容栏
- (void)setupContentScrollView
{
    
    for (int i = 0; i < count; i++) {
        TKExampleViewController *example =[[TKExampleViewController alloc] init];
        example.title = [NSString stringWithFormat:@"示例%02d", i +1];
        [self addChildViewController:example];
    }
    self.contentScrollView.contentSize = CGSizeMake(count * self.contentScrollView.frame.size.width, 0);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    NSLog(@"%s", __func__);
    CGFloat w = scrollView.frame.size.width;
    CGFloat h = scrollView.frame.size.height;
    
    // 选中index
    int index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 选中label居中
    UILabel *selectedLabel = self.titleScrollView.subviews[index];
    CGPoint titleOffset = self.titleScrollView.contentOffset;
    // 需要移动的值
    CGFloat scaleX = selectedLabel.center.x - self.titleScrollView.frame.size.width * 0.5;

    // 左边超出处理
    if (scaleX < 0) {
        scaleX = 0;
    }
    // 右边超出处理
    if (scaleX > self.titleScrollView.contentSize.width - self.contentScrollView.frame.size.width) {
        scaleX = self.titleScrollView.contentSize.width - self.contentScrollView.frame.size.width;
    }
    // 移动titleScrollView
    titleOffset.x = scaleX;
    [self.titleScrollView setContentOffset:titleOffset animated:YES];
    
    TKExampleViewController *example = self.childViewControllers[index];
    example.view.frame = CGRectMake(scrollView.contentOffset.x, 0, w, h);
    [scrollView addSubview:example.view];
}

// 手指松开scrollView后，scrollView停止减速完毕就会调用这个
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%s", __func__);
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%s", __func__);
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scale < 0 || scale >= count ) return;
    
    NSInteger leftIndex = scale;
    NSInteger rightIndex = leftIndex + 1;
    CGFloat rightScale = scale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    UILabel *leftLabel = self.titleScrollView.subviews[leftIndex];
    [self setLabel:leftLabel scale:leftScale];
    
    if (rightIndex >= count) return;
    UILabel *rightLabel = self.titleScrollView.subviews[rightIndex];
    [self setLabel:rightLabel scale:rightScale];
}

- (void)setLabel:(UILabel *)label scale:(CGFloat)scale
{
    // 设置label transform
    CGFloat transformScale = 1 + scale * 0.4;
    label.transform = CGAffineTransformMakeScale(transformScale, transformScale);
    
    // 设置labe textColor
    CGFloat redScale = (1 - labelRed) * scale + labelRed;
    CGFloat greenScale = (1 - scale) * labelGreen;
    CGFloat blueScale = (1 - scale) * labelBlue;
    label.textColor = [UIColor colorWithRed:redScale green:greenScale blue:blueScale alpha:1.0];
}

@end
