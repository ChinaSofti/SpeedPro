//
//  SVAdvancedSetting.m
//  SPUIView
//
//  Created by Rain on 2/17/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVAdvancedSetting.h"

#define default_screenSize 42;

@implementation SVAdvancedSetting

// 屏幕尺寸
static NSString *_screenSize;


/**
 *  单例
 *
 *  @return 单例对象
 */
+ (id)sharedInstance
{
    static SVAdvancedSetting *advancedSetting;
    @synchronized (self)
    {
        if (advancedSetting == nil)
        {
            advancedSetting = [[super allocWithZone:NULL] init];

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            _screenSize = [defaults objectForKey:@"screenSize"];
            if (!_screenSize)
            {
                _screenSize = @"42.00";
                [defaults setObject:_screenSize forKey:@"screenSize"];
                [defaults synchronize];
            }
        }
    }

    return advancedSetting;
}

/**
 *  覆写allocWithZone方法
 *
 *  @param zone _NSZone
 *
 *  @return 单例对象
 */
+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [SVAdvancedSetting sharedInstance];
}

/**
 *  覆写copyWithZone方法
 *
 *  @param zone _NSZone
 *
 *  @return 单例对象
 */

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [SVAdvancedSetting sharedInstance];
}


/**
 *  设置屏幕尺寸
 *
 *  @param screenSize 屏幕尺寸
 */
- (void)setScreenSize:(float)screenSize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _screenSize = [NSString stringWithFormat:@"%.2f", screenSize];
    [defaults setObject:_screenSize forKey:@"screenSize"];
    [defaults synchronize];
}

/**
 *  查询屏幕尺寸
 *
 *  @return 屏幕尺寸
 */
- (NSString *)getScreenSize
{
    return _screenSize;
}

@end