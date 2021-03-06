//
//  SVUvMOSCalculater.m
//  SPUIView
//
//  Created by Rain on 2/10/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVContentProviderGetter.h"
#import "SVLog.h"
#import "SVProbeInfo.h"
#import "SVUvMOSCalculator.h"
#import "SVVideoUtil.h"
#import <SPCommon/SVTimeUtil.h>

@implementation SVUvMOSCalculator
{
    SVVideoTestContext *_testContext;
    SVVideoTestResult *_testResult;
    void *hServiceHandle;
    int isFirstTime;
    long _videoPlayTime;
    UvMOSPlayStatus _lastePlayStatus;
}

/**
 *  初始化UvMOS值计算器
 *
 *  @param testContext Test Context
 *  @param testResult Test Result
 *
 *  @return UvMOS值计算器
 */
- (id)initWithTestContextAndResult:(SVVideoTestContext *)testContext
                        testResult:(SVVideoTestResult *)testResult
{
    _testContext = testContext;
    _testResult = testResult;
    return self;
}


//- (void)updateMediaInfo
//{
//    /* 赋值视频静态参数  */
//    UvMOSMediaInfo stMediaInfo = { 0 };
//
//    // 视频帧率
//    stMediaInfo.eMediaType = MEDIA_TYPE_VOD;
//    // 视频提供商
//    stMediaInfo.eContentProvider =
//    [SVContentProviderGetter getContentProvider:_testContext.videoSegementURL.host];
//    stMediaInfo.eVideoCodec = VIDEO_CODEC_H264;
//    // 屏幕尺寸，单位英寸，输入为0时，屏幕映射默认为42寸TV
//    //    stMediaInfo.fScreenSize = [SVVideoUtil getScreenScale];
//    // 孙海龙 2016/02/13  屏幕尺寸 固定为42寸
//    SVProbeInfo *probeInfo = [[SVProbeInfo alloc] init];
//    float screenSize = [[probeInfo getScreenSize] floatValue];
//    stMediaInfo.fScreenSize = screenSize;
//    [_testResult setScreenSize:screenSize];
//
//    // 视频分辨率
//    stMediaInfo.iVideoResolutionWidth = _testResult.videoWidth;
//    stMediaInfo.iVideoResolutionHeigth = _testResult.videoHeight;
//
//    // 屏幕分辨率
//    CGSize scressSize = [SVVideoUtil getScreenScale];
//    stMediaInfo.iScreenResolutionWidth = scressSize.width;
//    stMediaInfo.iScreenResolutionHeight = scressSize.height;
//
//    /* 第一步：申请U-vMOS服务号 (携带视频静态参数 )  */
//    SVInfo (@"UvMOSMediaInfo[eMediaType:%d  eContentProvider:%d  eVideoCodec:%d  screenSize:%.2f "
//            @"iVideoResolutionWidth:%d  iVideoResolutionHeigth:%d  iScreenResolutionWidth:%d   "
//            @"iScreenResolutionHeight:%d]",
//            stMediaInfo.eMediaType, stMediaInfo.eContentProvider, stMediaInfo.eVideoCodec,
//            stMediaInfo.fScreenSize, stMediaInfo.iVideoResolutionWidth,
//            stMediaInfo.iVideoResolutionHeigth,
//            stMediaInfo.iScreenResolutionWidth, stMediaInfo.iScreenResolutionHeight);
//
//    resetMediaInfo (&hServiceHandle, &stMediaInfo);
//}

- (void)registeService
{
    /* 赋值视频静态参数  */
    UvMOSMediaInfo stMediaInfo = { 0 };

    // 视频帧率
    stMediaInfo.eMediaType = MEDIA_TYPE_VOD;
    // 视频提供商
    stMediaInfo.eContentProvider =
    [SVContentProviderGetter getContentProvider:_testContext.videoSegementURL.host];
    stMediaInfo.eVideoCodec = VIDEO_CODEC_H264;
    // 屏幕尺寸，单位英寸，输入为0时，屏幕映射默认为42寸TV
    //    stMediaInfo.fScreenSize = [SVVideoUtil getScreenScale];
    // 孙海龙 2016/02/13  屏幕尺寸 固定为42寸
    SVProbeInfo *probeInfo = [[SVProbeInfo alloc] init];
    float screenSize = [[probeInfo getScreenSize] floatValue];
    stMediaInfo.dScreenSize = screenSize;
    [_testResult setScreenSize:screenSize];

    // 视频分辨率
    stMediaInfo.iVideoResolutionWidth = _testResult.videoWidth;
    stMediaInfo.iVideoResolutionHeigth = _testResult.videoHeight;

    // 屏幕分辨率
    CGSize scressSize = [SVVideoUtil getScreenScale];
    stMediaInfo.iScreenResolutionWidth = scressSize.width;
    stMediaInfo.iScreenResolutionHeight = scressSize.height;

    /* 第一步：申请U-vMOS服务号 (携带视频静态参数 )  */
    SVInfo (@"UvMOSMediaInfo[eMediaType:%d  eContentProvider:%d  eVideoCodec:%d  screenSize:%.2f   "
            @"iVideoResolutionWidth:%d  iVideoResolutionHeigth:%d  iScreenResolutionWidth:%d   "
            @"iScreenResolutionHeight:%d]",
            stMediaInfo.eMediaType, stMediaInfo.eContentProvider, stMediaInfo.eVideoCodec,
            stMediaInfo.dScreenSize, stMediaInfo.iVideoResolutionWidth, stMediaInfo.iVideoResolutionHeigth,
            stMediaInfo.iScreenResolutionWidth, stMediaInfo.iScreenResolutionHeight);
    int iResult = registerUvMOSService (&stMediaInfo, &hServiceHandle);
    if (iResult < 0)
    {
        SVError (@"registe UvMOS calculate service fail.  iResult:%d", iResult);
    }
    else
    {
        SVInfo (@"registe UvMOS calculate service.  iResult:%d", iResult);
    }
}

- (void)setFirstBufferStatus
{
    [self registeService];
    [self update:STATUS_INIT_BUFFERING time:1];
    [self update:STATUS_BUFFERING_END time:_testResult.firstBufferTime];
}

- (void)update:(UvMOSPlayStatus)status time:(int)iTimeStamp
{
    /* 第二步：每个周期调用计算(携带周期性参数) */
    if (!hServiceHandle)
    {
        SVError (@"calculate UvMOS fail. hServiceHandle is null");
        return;
    }

    /* 赋值周期性采样参数 */
    UvMOSSegmentInfo stSegmentInfo = { 0 };
    UvMOSResult stResult = { 0 };

    stSegmentInfo.iAvgVideoBitrate = _testResult.bitrate;
    stSegmentInfo.dVideoFrameRate = _testResult.frameRate;
    stSegmentInfo.iAvgKeyFrameSize = 0;
    stSegmentInfo.ePlayStatus = status;
    stSegmentInfo.iImpairmentDegree = 50;
    stSegmentInfo.iTimeStamp = iTimeStamp;

    _lastePlayStatus = stSegmentInfo.ePlayStatus;

    SVInfo (@"-----UvMOSSegmentInfo[iAvgVideoBitrate:%d  iVideoFrameRate:%.2f  iAvgKeyFrameSize:%d "
            @" "
            @"iImpairmentDegree:%d   ePlayStatus:%d   "
            @"iTimeStamp:%d] ",
            stSegmentInfo.iAvgVideoBitrate, stSegmentInfo.dVideoFrameRate, stSegmentInfo.iAvgKeyFrameSize,
            stSegmentInfo.iImpairmentDegree, stSegmentInfo.ePlayStatus, stSegmentInfo.iTimeStamp);

    int iResult = calculateUvMOSSegment (hServiceHandle, &stSegmentInfo, &stResult);
    if (iResult < 0)
    {
        SVInfo (@"calculate UvMOS fail.  iResult:%d", iResult);
        return;
    }

    SVInfo (
    @"----- UvMOSResult[sQualitySession:%.2f  sInteractionSession:%.2f  sViewSession:%.2f  "
    @"uvmosSession:%.2f  sQualityInstant:%.2f  sInteractionInstant:%.2f  sViewInstant:%.2f  "
    @"uvmosInstant:%.2f  ] ",
    stResult.sQualitySession, stResult.sInteractionSession, stResult.sViewSession, stResult.uvmosSession,
    stResult.sQualityInstant, stResult.sInteractionInstant, stResult.sViewInstant, stResult.uvmosInstant);
}

- (void)calculateUvMOS:(SVVideoTestSample *)sample time:(int)iTimeStamp
{
    if (!isFirstTime)
    {
        [self setFirstBufferStatus];
        isFirstTime += 1;
    }

    /* 第二步：每个周期调用计算(携带周期性参数) */
    if (!hServiceHandle)
    {
        SVError (@"calculate UvMOS fail. hServiceHandle is null");
        return;
    }

    /* 赋值周期性采样参数 */
    UvMOSSegmentInfo stSegmentInfo = { 0 };
    UvMOSResult stResult = { 0 };

    stSegmentInfo.iAvgVideoBitrate = _testResult.bitrate;
    stSegmentInfo.dVideoFrameRate = _testResult.frameRate;
    stSegmentInfo.iAvgKeyFrameSize = 0;

    if (_lastePlayStatus == STATUS_IMPAIR_END || _lastePlayStatus == STATUS_BUFFERING_END)
    {
        stSegmentInfo.ePlayStatus = STATUS_PLAYING;
    }
    else
    {
        stSegmentInfo.ePlayStatus = _lastePlayStatus;
    }

    _lastePlayStatus = stSegmentInfo.ePlayStatus;

    stSegmentInfo.iImpairmentDegree = 50;
    stSegmentInfo.iTimeStamp = iTimeStamp;
    SVInfo (@"-----UvMOSSegmentInfo[iAvgVideoBitrate:%d  iVideoFrameRate:%.2f  iAvgKeyFrameSize:%d "
            @" "
            @"iImpairmentDegree:%d   ePlayStatus:%d   "
            @"iTimeStamp:%d] ",
            stSegmentInfo.iAvgVideoBitrate, stSegmentInfo.dVideoFrameRate, stSegmentInfo.iAvgKeyFrameSize,
            stSegmentInfo.iImpairmentDegree, stSegmentInfo.ePlayStatus, stSegmentInfo.iTimeStamp);

    int iResult = calculateUvMOSSegment (hServiceHandle, &stSegmentInfo, &stResult);
    if (iResult < 0)
    {
        SVInfo (@"calculate UvMOS fail.  iResult:%d", iResult);
        return;
    }

    SVInfo (
    @"----- UvMOSResult[sQualitySession:%.2f  sInteractionSession:%.2f  sViewSession:%.2f  "
    @"uvmosSession:%.2f  sQualityInstant:%.2f  sInteractionInstant:%.2f  sViewInstant:%.2f  "
    @"uvmosInstant:%.2f  ] ",
    stResult.sQualitySession, stResult.sInteractionSession, stResult.sViewSession, stResult.uvmosSession,
    stResult.sQualityInstant, stResult.sInteractionInstant, stResult.sViewInstant, stResult.uvmosInstant);

    [sample setSQualitySession:stResult.sQualitySession];
    [sample setSInteractionSession:stResult.sInteractionSession];
    [sample setSViewSession:stResult.sViewSession];
    [sample setUvMOSSession:stResult.uvmosSession];
}


- (void)unRegisteService
{
    /* 第三步：去注册服务 */
    int iResult = unregisterUvMOSService (hServiceHandle);
    if (iResult < 0)
    {
        SVError (@"unregiste UvMOS calculate service fail.  iResult:%d", iResult);
    }
    else
    {
        SVInfo (@"unregiste UvMOS calculate service.  iResult:%d", iResult);
    }
}


@end
