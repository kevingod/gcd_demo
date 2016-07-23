//
//  ViewController.m
//  gcd_demo
//
//  Created by kevingao on 16/7/23.
//  Copyright © 2016年 kevingao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //加载子视图
    [self setUpView];
}

//加载子视图
- (void)setUpView{

    NSArray* title_array = [NSArray arrayWithObjects:
                            
                            @"1.获取主线程",
                            @"2.主线程串行队列同步执行任务",
                            @"3.主线程串行队列异步执行任务",
                            @"4.从子线程，异步返回主线程更新UI",

                            @"5.获取全局并发队列",
                            @"6.全局并发队列同步执行任务",
                            @"7.全局并发队列异步执行任务",
                            @"8.多个全局并发队列,异步执行任务",

                            @"9.自定义串行队列",
                            @"10.自定义并发队列",
                            
                            @"11.Group queue (队列组)",

                            @"12.dispatch_after延时",
                            @"13.dispatch_once 执行一次",
                            @"14.dispatch_barrier_async 栅栏的作用",
                            @"15.dispatch 计时器",
                            
                            nil];

    for (NSInteger i = 0; i < [title_array count]; i++) {
        
        //title
        NSString* title = [title_array objectAtIndex:i];
        
        //button
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:title forState:UIControlStateNormal];
        
        button.frame = CGRectMake(20 + (i%2)*170, 50 + (i/2)*50, 160, 30);
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        
        button.backgroundColor = [UIColor blackColor];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        button.tag = i;
        
        [self.view addSubview:button];
    }

}

//点击事件
- (void)buttonClicked:(UIButton*)button{





}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
