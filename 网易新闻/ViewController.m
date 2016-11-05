//
//  ViewController.m
//  网易新闻
//
//  Created by 浩哲 夏 on 16/10/30.
//  Copyright © 2016年 浩哲 夏. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic,weak)UIScrollView *titleScroll;
@property(nonatomic,weak)UIScrollView *contentScroll;
@property(nonatomic,strong)NSMutableArray *arr_TitleBtn;
@property(nonatomic,weak)UIButton *stateButton;
@property(nonatomic,assign)BOOL isinitial;

@end

@implementation ViewController

-(NSMutableArray *)arr_TitleBtn{
    if (!_arr_TitleBtn) {
        _arr_TitleBtn = [NSMutableArray array];
    }
    return _arr_TitleBtn;
}

//NavigationController 高度固定为64
static CGFloat const NaviHeight = 64;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网易新闻";
    
    
    /* 1 创建标题scroll*/
    [self setUpTitleScroll];
    /* 2 创建内容Scroll*/
    [self setUpContentScroll];

    NSLog(@"%ld",self.childViewControllers.count);
    // iOS7以后,导航控制器中scollView顶部会添加64的额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;

}

#pragma mark - 在viewWillAppear里调用 标题栏
-(void)viewWillAppear:(BOOL)animated
{
    if (!_isinitial ) {
        /* 4 添加所有标题按钮 */
        [self setUpAllButton];
    }
}
#pragma mark - 创建标题栏
-(void)setUpTitleScroll{
    UIScrollView *titleScroll = [[UIScrollView alloc]init];
    titleScroll.frame = CGRectMake(0, NaviHeight, [UIScreen mainScreen].bounds.size.width, 44);
    [self.view addSubview:titleScroll];
    _titleScroll = titleScroll;
}


#pragma mark - 创建内容Scroll
-(void)setUpContentScroll{
    UIScrollView *contentScroll = [[UIScrollView alloc]init];
    contentScroll.frame = CGRectMake(0, self.titleScroll.frame.size.height + NaviHeight , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:contentScroll];
    _contentScroll = contentScroll;
    
    
    // 设置contentScrollView的属性
    // 分页
    self.contentScroll.pagingEnabled = YES;
    // 弹簧
    self.contentScroll.bounces = NO;
    // 指示器
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    
    // 设置代理.目的:监听内容滚动视图 什么时候滚动完成
    self.contentScroll.delegate = self;
    
}



#pragma mark - 添加所有标题按钮
-(void)setUpAllButton{
    NSInteger count = self.childViewControllers.count;
    CGFloat buttonHeight = self.titleScroll.frame.size.height;
    CGFloat buttonWidth = 100;
    CGFloat buttonX = 0;
    for (int i =0; i< count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *titleName = self.childViewControllers[i].title;
        buttonX = buttonWidth * i;
        [button setTitle:titleName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(buttonX, 0 ,buttonWidth , buttonHeight);
        button.tag = i;
        //监听点击
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        //将button保存起来
        [self.arr_TitleBtn addObject:button];
        
        if (0 == i) {
            [self clickButton: button];
        }
        [self.titleScroll addSubview:button];
    }
    
    //设置 标题栏 滚动范围
    self.titleScroll.contentSize = CGSizeMake(count * buttonWidth, 0);
    self.titleScroll.showsHorizontalScrollIndicator = NO;
    
    //设置 内容 滚动范围
    CGFloat  offsetX = count * [UIScreen mainScreen].bounds.size.width;
    self.contentScroll.contentSize = CGSizeMake(offsetX, 0);


    
}
#pragma mark - 监听按钮点击
-(void)clickButton :(UIButton *)button{
   
    //设置 选中button变 红色
    [self changeColorBtn:button];
    //设置 选中button 切换 内容
    [self changeContentView:button.tag];
    
    CGFloat  offsetX = button.tag * [UIScreen mainScreen].bounds.size.width;
    self.contentScroll.contentOffset = CGPointMake(offsetX, 0);
    
    
}
#pragma mark - 切换button属性
-(void)changeColorBtn :(UIButton *)button{
    
    _stateButton.transform = CGAffineTransformIdentity;
    [_stateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.transform = CGAffineTransformMakeScale(1.4, 1.4);
    
    //标题 居中
    [self setupTitleCenter:button];
    //保存 button 属性
    _stateButton = button;
}

#pragma mark - 切换窗口
-(void)changeContentView:(NSInteger)tag{
    
    UIViewController *VC = self.childViewControllers[tag];
    VC.view.frame = CGRectMake(tag *[UIScreen mainScreen].bounds.size.width , 0, [UIScreen mainScreen].bounds.size.width, self.contentScroll.frame.size.height);
    [self.contentScroll addSubview:VC.view];
}

#pragma mark - scrollViewDidScroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   
    NSInteger leftIndex = self.contentScroll.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    NSInteger rightIndex = leftIndex + 1;
    
    UIButton *leftButton = self.arr_TitleBtn[leftIndex];
    
    UIButton *rightButton;
    if (rightIndex < self.arr_TitleBtn.count) {
        rightButton = self.arr_TitleBtn[rightIndex];
    }
    
    //缩放比例 在 1- 1.5 之间
    CGFloat scaleRight =self.contentScroll.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    scaleRight -=leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    
    //按钮缩放
    leftButton.transform = CGAffineTransformMakeScale(scaleLeft *0.4 +1 , scaleLeft *0.4 + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleRight * 0.4 +1 , scaleRight* 0.4 +1);
    
    // 颜色渐变
    UIColor *rightColor = [UIColor colorWithRed:scaleRight green:0 blue:0 alpha:1];
    UIColor *leftColor = [UIColor colorWithRed:scaleLeft green:0 blue:0 alpha:1];
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
}

#pragma mark - scrollViewDidEndDecelerating
// 滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获取当前角标
    NSInteger index = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    
    // 获取标题按钮
    UIButton *titleButton = self.arr_TitleBtn[index];
    
    // 1.选中标题
    [self changeColorBtn:titleButton];
    
    // 2.把对应子控制器的view添加上去
    [self changeContentView:index];
}


#pragma mark - 标题居中
- (void)setupTitleCenter:(UIButton *)button
{
    // 本质:修改titleScrollView偏移量
    CGFloat offsetX = button.center.x - [UIScreen mainScreen].bounds.size.width * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    CGFloat maxOffsetX = self.titleScroll.contentSize.width - [UIScreen mainScreen].bounds.size.width;
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.titleScroll setContentOffset: CGPointMake(offsetX, 0) animated:YES];
    
}

@end
