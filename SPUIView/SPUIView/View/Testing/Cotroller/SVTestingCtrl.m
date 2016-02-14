//
//  SVTestingCtrl.m
//  SPUIView
//
//  Created by WBapple on 16/1/20.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import "SVBackView.h"
#import "SVCurrentResultViewCtrl.h"
#import "SVPointView.h"
#import "SVTestingCtrl.h"
#import "SVTimeUtil.h"
#import "SVVideoTest.h"

@interface SVTestingCtrl ()
{

    // 定义headerView
    SVPointView *_headerView;

    //定义testingView
    SVPointView *_testingView;

    //定义视频播放View
    SVPointView *_videoView;

    // 定义footerView
    SVPointView *_footerView;
}

@property (nonatomic, strong) SVBackView *backView;
@end

@implementation SVTestingCtrl

@synthesize navigationController;

- (void)viewDidLoad
{

    [super viewDidLoad];
    NSLog (@"SVTestingCtrl");

    // 1.自定义navigationItem.titleView
    //设置图片大小
    UIImageView *imageView = [[UIImageView alloc]
    initWithFrame:CGRectMake (FITWIDTH (0), FITWIDTH (0), FITWIDTH (100), FITWIDTH (30))];
    //设置图片名称
    imageView.image = [UIImage imageNamed:@"speed_pro"];
    //让图片适应
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //把图片添加到navigationItem.titleView
    self.navigationItem.titleView = imageView;
    //电池显示不了,设置样式让电池显示
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    // 2.设置整个Viewcontroller
    //设置背景颜色
    self.view.backgroundColor =
    [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    //打印排序结果
    //    NSLog (@"%@", _selectedA);

    // 3.自定义UIBarButtonItem
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, 44, 44)];
    //    button.backgroundColor = [UIColor redColor];
    //    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //图片位置(相对于)
    //    [button setImageEdgeInsets:UIEdgeInsetsMake (0, -10, 0, 10)];
    //设置点击事件
    [button addTarget:self
               action:@selector (backBtnClik)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    // backButton设为navigationItem.leftBarButtonItem
    self.navigationItem.leftBarButtonItem = backButton;
    //是否允许用户交互(默认是交互的)
    //    self.navigationItem.leftBarButtonItem.enabled = YES;

    //为了保持平衡添加一个leftBtn
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, 44, 44)];
    UIBarButtonItem *backButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = backButton1;
    self.navigationItem.rightBarButtonItem.enabled = NO;

    //添加方法
    [self creatHeaderView];
    [self creatTestingView];
    [self creatVideoView];
    [self creatFooterView];
}


#pragma mark - 创建头headerView

- (void)creatHeaderView
{

    //初始化headerView
    _headerView = [[SVPointView alloc] init];

    //把所有Label添加到View中
    [self.view addSubview:_headerView.uvMosLabel];
    [self.view addSubview:_headerView.speedLabel];
    [self.view addSubview:_headerView.bufferLabel];
    [self.view addSubview:_headerView.uvMosNumLabel];
    [self.view addSubview:_headerView.speedNumLabel];
    [self.view addSubview:_headerView.bufferNumLabel];
    //把headerView添加到中整个视图上
    [self.view addSubview:_headerView];
}

#pragma mark - 创建测试中仪表盘testingView

- (void)creatTestingView
{

    //初始化整个testingView
    _testingView = [[SVPointView alloc] init];
    //添加到View中
    [self.view addSubview:_testingView.pointView];
    [_testingView start];
    [self.view addSubview:_testingView.grayView];
    _testingView.grayViewSuperView = _testingView.grayView.superview;
    _testingView.grayViewIndexInSuperView = [self.view.subviews indexOfObject:_testingView.grayView];
    [self.view addSubview:_testingView.panelView];
    [self.view addSubview:_testingView.middleView];
    [self.view addSubview:_testingView.label1];
    [self.view addSubview:_testingView.label2];
    _testingView.label2SuperView = _testingView.label2.superview;
    _testingView.label2IndexInSuperView = [self.view.subviews indexOfObject:_testingView.label2];
}


#pragma mark - 创建视频播放View


- (void)creatVideoView
{
    //初始化
    _videoView = [[SVPointView alloc]
    initWithFrame:CGRectMake (FITWIDTH (10), FITWIDTH (420), FITWIDTH (150), FITWIDTH (92))];

    //把panlView添加到中整个视图上
    [self.view addSubview:_videoView];

    //把视频播放放到线程中
    long testId = [SVTimeUtil currentMilliSecondStamp];
    SVVideoTest *videoTest =
    [[SVVideoTest alloc] initWithView:testId showVideoView:_videoView testDelegate:self];
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [videoTest test];
      // TODO liuchengyu 完成测试。跳转到结果页面

    });

    //添加视频点击事件
    UIButton *bgBtn = [[UIButton alloc]
    initWithFrame:CGRectMake (FITWIDTH (10), FITWIDTH (420), FITWIDTH (150), FITWIDTH (92))];
    [bgBtn addTarget:self
              action:@selector (bgButtonClick:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bgBtn];
}
//点击事件
- (void)bgButtonClick:(UIButton *)btn
{
    NSLog (@"点击了视频");
}

#pragma mark - 创建尾footerView

- (void)creatFooterView
{
    //初始化headerView
    _footerView = [[SVPointView alloc] init];

    //把所有Label添加到headerView中
    [self.view addSubview:_footerView.placeLabel];
    [_footerView addSubview:_footerView.resolutionLabel];
    [_footerView addSubview:_footerView.bitLabel];
    [_footerView addSubview:_footerView.placeNumLabel];
    [_footerView addSubview:_footerView.resolutionNumLabel];
    [_footerView addSubview:_footerView.bitNumLabel];
    //把headerView添加到中整个视图上
    [self.view addSubview:_footerView];
}


#pragma mark - back弹框页

//生命周期(点击按钮就创建)
- (void)backBtnClik
{
    //    [self setShadowView];
}
/**
 *  创建阴影背景
 */

//代理方法
- (void)setShadowView
{
    //添加动画
    [UIView
    animateWithDuration:1
             animations:^{
               //黑色透明阴影
               UIView *shadowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
               shadowView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];

               if (!_backView)
               {
                   _backView = [[SVBackView alloc]
                   initWithFrame:CGRectMake (FITWIDTH (20), FITWIDTH (140),
                                             shadowView.frame.size.width - FITWIDTH (40), FITWIDTH (220))
                         bgColor:[UIColor whiteColor]];

                   //                   _backView.delegate = self;
               }

               [shadowView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                        action:@selector (dismissTextField:)]];

               [shadowView addSubview:_backView];

               [self.view.window addSubview:shadowView];
             }];
}
//取消键盘
- (void)dismissTextField:(UIGestureRecognizer *)tap
{
    UIView *view = tap.view;
    [view endEditing:YES];
}
//代理方法-否
- (void)backView:(SVBackView *)backView overLookBtnClick:(UIButton *)Btn
{
    NSLog (@"NO");
    UIView *shadowView = [[[Btn superview] superview] superview];
    [shadowView removeFromSuperview];
    backView = nil;
}
//代理方法-是
- (void)backView:(SVBackView *)backView saveBtnClick:(UIButton *)Btn
{
    NSLog (@"YES");
    UIView *shadowView = [[[Btn superview] superview] superview];
    [shadowView removeFromSuperview];
    backView = nil;
}
/**
 ******************************以上弹框代码结束*****************************************
 **/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTestResultDelegate:(SVVideoTestContext *)testContext
                      testResult:(SVVideoTestResult *)testResult
{

    // UvMOS 综合得分
    NSArray *testSamples = testResult.videoTestSamples;
    SVVideoTestSample *testSample = testSamples[testSamples.count - 1];
    float uvMOSSession = testSample.UvMOSSession;

    //首次缓冲时长
    long firstBufferTime = testResult.firstBufferTime;

    // 卡顿次数
    int cuttonTimes = testResult.videoCuttonTimes;

    // 视频服务器位置
    NSString *location = testContext.videoSegemnetLocation;

    // 视频码率
    float bitrate = testResult.bitrate;

    // 分辨率
    NSString *videoResolution = testResult.videoResolution;
    NSLog (@"uvMOSSession: %f  firstBufferTime:%ld  cuttonTimes:%d  location:%@  bitrate:%f  "
           @"videoResolution:%@",
           uvMOSSession, firstBufferTime, cuttonTimes, location, bitrate, videoResolution);
    dispatch_async (dispatch_get_main_queue (), ^{
      [_footerView.placeLabel setText:location];
      [_footerView.resolutionLabel setText:videoResolution];
      [_footerView.bitLabel setText:[NSString stringWithFormat:@"%.2fkpbs", bitrate]];
      [_headerView.bufferLabel setText:[NSString stringWithFormat:@"%d", cuttonTimes]];
      [_headerView.speedLabel setText:[NSString stringWithFormat:@"%ldms", firstBufferTime]];
      [_headerView.uvMosLabel setText:[NSString stringWithFormat:@"%.2f", uvMOSSession]];
      [_testingView updateUvMOS:uvMOSSession];
      if (testContext.testStatus == TEST_FINISHED)
      {
          SVCurrentResultViewCtrl *currentResultView = [[SVCurrentResultViewCtrl alloc] init];
          currentResultView.navigationController = navigationController;
          //          [self presentViewController:currentResultView animated:YES completion:nil];
          [navigationController pushViewController:currentResultView animated:YES];
      }
    });
}


@end
