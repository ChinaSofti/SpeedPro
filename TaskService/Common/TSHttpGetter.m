//
//  TSHttpGetter.m
//  TaskService
//
//  Created by Rain on 1/27/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSHttpGetter.h"
#import "TSLog.h"

@implementation TSHttpGetter

/**
 *  请求指定URL，并获取服务器响应数据
 *
 *  @param urlString 请求URL
 *
 *  @return 服务器返回数据
 */
+ (id)requestWithoutParameter:(NSString *)urlString
{
    NSData *data = [TSHttpGetter requestDataWithoutParameter:urlString];
    NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    TSDebug (@"response Data:%@", responseData);
    return responseData;
}

/**
 *  请求指定URL，并获取服务器响应数据
 *
 *  @param urlString 请求URL
 *
 *  @return 服务器返回数据
 */
+ (NSData *)requestDataWithoutParameter:(NSString *)urlString
{
    TSInfo (@"request URL:%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:10];
    //    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData *data =
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error)
    {
        TSError (@"request URL:%@ fail. %@", urlString, error);
        return nil;
    }

    return data;
}

@end
