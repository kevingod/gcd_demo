//
//  ViewController.m
//  gcd_demo
//
//  Created by kevingao on 16/7/23.
//  Copyright © 2016年 kevingao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray* title_array;

}
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

    title_array = [NSArray arrayWithObjects:
                            
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

    NSLog(@"%@",[title_array objectAtIndex:button.tag]);

    switch (button.tag) {
        case 0:
        {
            //@"1.获取主线程",

            [self getMainQueue];
        }
            break;
        case 1:
        {
            //@"2.主线程串行队列同步执行任务",

            [self mainQueueSync];
        }
            break;
        case 2:
        {
            //@"3.主线程串行队列异步执行任务",

            [self mainQueueAsync];
        }
            break;
        case 3:
        {
            //@"4.从子线程，异步返回主线程更新UI",
            
            [self subQueueToMainQueue];
        }
            break;
        case 4:
        {
            //@"5.获取全局并发队列",

            [self getGlobalQueue];
        }
            break;
        case 5:
        {
            //@"6.全局并发队列同步执行任务",

            [self sendSyncTask];
        }
            break;
        case 6:
        {
            //@"7.全局并发队列异步执行任务",

            [self sendAsynTask];
        }
            break;
        case 7:
        {
            //@"8.多个全局并发队列,异步执行任务",
            
            [self sendMoreAsyncTask];
        }
            break;
        case 8:
        {
            //@"9.自定义串行队列",

            [self customQueue_serial];
        }
            break;
        case 9:
        {
            //@"10.自定义并发队列",
            
            [self customQueue_concurrent];
        }
            break;
        case 10:
        {
            //@"11.Group queue (队列组)",
            
            [self createGroupqueue];
        }
            break;
        case 11:
        {
            //@"12.dispatch_after延时",

            
        }
            break;
        case 12:
        {
            //@"13.dispatch_once 执行一次",

            
        }
            break;
        case 13:
        {
            //@"14.dispatch_barrier_async 栅栏的作用",

            
        }
            break;
        case 14:
        {
            //@"15.dispatch 计时器",
            
            
        }
            break;
        default:
            break;
    }
}

//获得主线程
- (void)getMainQueue{

    dispatch_queue_t mainQueue = dispatch_get_main_queue();

    NSLog(@"%@",mainQueue);
}

//主线程队列执行同步操作
- (void)mainQueueSync{

    NSLog(@"界面卡死");
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_sync(mainQueue, ^(){
    
        NSLog(@"MainQueue");
    
    });
    
}

//主线程队列执行异步操作
- (void)mainQueueAsync{
    
    //获得主线程
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(mainQueue, ^(){
    
        NSLog(@"向主线程异步发送消息，界面不会卡死");

    });
}

//在子线程处理任务，异步返回主线程刷新UI
- (void)subQueueToMainQueue{

    //获取全局并发队列
    dispatch_queue_t goable_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //主线程
    dispatch_queue_t main_queue = dispatch_get_main_queue();

    //异步操作
    dispatch_async(goable_queue, ^(){
    
        //子线程异步执行下载任务，防止主线程卡顿
        NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
        NSError *error;
        NSString *htmlData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (htmlData != nil) {
        
            //刷新主线程UI
            dispatch_async(main_queue, ^(){
            
                NSLog(@"UI刷新");
                
            });
        
        }else{
        
            NSLog(@"error when download:%@",error);
        }
    
    });
}

//获得全局并发队列
- (void)getGlobalQueue{

    //获取全局并发队列

    //默认优先级
    dispatch_queue_t queue_1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //高等级
    dispatch_queue_t queue_2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

    //低等级
    dispatch_queue_t queue_3 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);

    //backGround
    dispatch_queue_t queue_4 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    NSLog(@"默认优先级 : %@",queue_1);
    NSLog(@"高等级 : %@",queue_2);
    NSLog(@"低等级 : %@",queue_3);
    NSLog(@"backGround : %@",queue_4);
}

//全局并发队列执行同步任务
- (void)sendSyncTask{

    //获得默认等级同步队列
    dispatch_queue_t queue_1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    NSLog(@"current task");
    
    //同步执行会导致主线程卡顿
    dispatch_sync(queue_1, ^(){
    
        sleep(2.0);
    
        NSLog(@"sleep 2.0s");
    });
    
    NSLog(@"最后一步，next task");
}

//全局并发队列执行异步任务
- (void)sendAsynTask{

    //获得全局并发队列
    dispatch_queue_t queue_1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    NSLog(@"开始任务");
    
    dispatch_async(queue_1, ^(){
    
        sleep(2.0);
        
        NSLog(@"结束任务");
    });
    
    NSLog(@"ok 任务执行中");
}

//执行多个并发任务
- (void)sendMoreAsyncTask{
    
//    异步线程的执行顺序是不确定的。几乎同步开始执行
//    全局并发队列由系统默认生成的，所以无法调用dispatch_resume()和dispatch_suspend()来控制执行继续或中断。

    dispatch_queue_t queue_1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    NSLog(@"current task");

    dispatch_async(queue_1, ^(){
    
        NSLog(@"最先加入全局并发队列");
    
    });
    
    dispatch_async(queue_1, ^(){
    
        NSLog(@"次加入全局并发队列");
    });
    
    NSLog(@"next task");
}

//自定义串行队列
- (void)customQueue_serial{

    //当前串行队列标示符
    const char* identifier = "com.kevingao.serialQueue";
    
    //串行队列
    dispatch_queue_t queue_1 = dispatch_queue_create(identifier, DISPATCH_QUEUE_SERIAL);

    NSLog(@"%@",queue_1);

    NSLog(@"current task");
    
    //同步
    dispatch_sync(queue_1, ^(){
    
        NSLog(@"最先加入自定义串行队列");

        sleep(2);
    
    });
    
    //同步
    dispatch_sync(queue_1, ^{
        
        NSLog(@"次加入自定义串行队列");
        
    });
    
    NSLog(@"next task");
}

//自定义并发队列
- (void)customQueue_concurrent{

    const char* identifier = "com.kevingao.concurrentQueue";
    
    //创建自定义并发队列
    dispatch_queue_t queue_1 = dispatch_queue_create(identifier, DISPATCH_QUEUE_CONCURRENT);

    NSLog(@"current task");

    //同步
    dispatch_sync(queue_1, ^(){
    
        sleep(2.0);
        
        NSLog(@"先加入队列");
    });

    //同步
    dispatch_sync(queue_1, ^(){
        
        NSLog(@"次加入队列");
    });
    
    NSLog(@"next task");
}

//创建队列组
- (void)createGroupqueue{

    //全局并发队列
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //主线程
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    //队列组
    dispatch_group_t group_queue = dispatch_group_create();
    
    //执行一段
    dispatch_group_async(group_queue, global_queue, ^(){
    
        NSLog(@"并行任务1");

    });
    
    //执行二段
    dispatch_group_async(group_queue, global_queue, ^(){
    
        NSLog(@"并行任务2");
    
    });

    //主线程收到通知
    dispatch_group_notify(group_queue, main_queue, ^(){
    
        NSLog(@"groupQueue中的任务 都执行完成,回到主线程更新UI");
    });
 
    NSLog(@"next task");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
