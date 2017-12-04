//
//  ViewController.m
//  BaiduVoice-practice
//
//  Created by 欧阳昌帅 on 2017/11/15.
//  Copyright © 2017年 0easy. All rights reserved.
//

#import "ViewController.h"
#import "MyAsrManagerHelper.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *endBtn;
@property (nonatomic, strong) UITextView *myTextView;
@property (nonatomic, strong) MyAsrManagerHelper *asrManagerHelper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    _myTextView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_myTextView];
    
    _startBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 120, 50, 50)];
    _startBtn.backgroundColor = [UIColor redColor];
    [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [_startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBtn];
    
    _endBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 120, 50, 50)];
    _endBtn.backgroundColor = [UIColor redColor];
    [_endBtn setTitle:@"结束" forState:UIControlStateNormal];
    [_endBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_endBtn];
    
    _asrManagerHelper = [MyAsrManagerHelper sharedManager];
    _asrManagerHelper.autoStop = 1;
    __weak typeof(self) weakSelf = self;
    _asrManagerHelper.asrBlock = ^(NSString *resultStr){
        
        NSLog(@"resultStr = %@", resultStr);
        weakSelf.myTextView.text = resultStr;
        
    };
    
}

- (void)start{
    
    [_asrManagerHelper start];
    
}

- (void)stop{
    
    [_asrManagerHelper stop];
    
}

@end
