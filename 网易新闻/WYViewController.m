//
//  WYViewController.m
//  网易新闻
//
//  Created by 浩哲 夏 on 16/10/31.
//  Copyright © 2016年 浩哲 夏. All rights reserved.
//

#import "WYViewController.h"
#import "topViewController.h"
#import "hotViewController.h"
#import "societyViewController.h"
#import "technologyViewController.h"
#import "subscribeViewController.h"
#import "VideoViewController.h"
@implementation WYViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    /* 3 添加所有子控制器*/
    [self setUpAllController];
}

#pragma mark - 添加所有子控制器
-(void)setUpAllController{
    topViewController *topVC = [[topViewController alloc]init];
    topVC.title = @"头条";
    [self addChildViewController:topVC];
    
    hotViewController *hotVC = [[hotViewController alloc]init];
    hotVC.title = @"热点";
    [self addChildViewController:hotVC];
    
    societyViewController *societyVC = [[societyViewController alloc]init];
    societyVC.title = @"社会";
    [self addChildViewController:societyVC];
    
    technologyViewController *technologyVC = [[technologyViewController alloc]init];
    technologyVC.title = @"科技";
    [self addChildViewController:technologyVC];
    
    VideoViewController *videoVC = [[VideoViewController alloc]init];
    videoVC.title = @"视频";
    [self addChildViewController:videoVC];
    
    subscribeViewController *subscribeVC = [[subscribeViewController alloc]init];
    subscribeVC.title = @"订阅";
    [self addChildViewController:subscribeVC];
}
@end

