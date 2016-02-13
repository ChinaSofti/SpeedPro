//
//  TSIPAndISPGetter.m
//  TaskService
//
//  Created by Rain on 1/27/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "SVHttpGetter.h"
#import "SVI18N.h"
#import "SVIPAndISPGetter.h"
#import "SVLog.h"

@implementation SVIPAndISPGetter
{
    //    TSIPAndISP *ipAndISP;
}

static NSString *defaultURL = @"http://ip-api.com/json?lang=%@";

static NSString *queryIPLocationURL = @"http://ip-api.com/json/%@?lang=%@";

static NSString *DEFAULT_ZH_CN_LANG = @"zh-CN";

static NSString *DEFAULT_EN_US_LANG = @"en";

+ (SVIPAndISP *)getIPAndISP
{
    return [SVIPAndISPGetter queryIPDetail:nil];
}


/**
 *  根据IP查询归属地。目前只支持两种语言的返回结果，英文和中文。缺省采用系统语言进行查询，并返回结果
 *
 *  @param ip IP地址
 *
 *  @return IP归属地
 */
+ (SVIPAndISP *)queryIPDetail:(NSString *)ip
{
    NSString *lang = [SVI18N currentLanguage];

    if ([lang containsString:@"en"])
    {
        lang = DEFAULT_EN_US_LANG;
    }
    else
    {
        lang = DEFAULT_ZH_CN_LANG;
    }

    NSData *jsonData = nil;
    if (!ip)
    {
        SVInfo (@"query ip and isp of this iphone, and return value with %@ language", lang);
        jsonData = [SVHttpGetter requestDataWithoutParameter:[NSString stringWithFormat:defaultURL, lang]];
    }
    else
    {
        SVInfo (@"query ip[%@] location, and return value with %@ language", ip, lang);
        jsonData = [SVHttpGetter
        requestDataWithoutParameter:[NSString stringWithFormat:queryIPLocationURL, ip, lang]];
    }

    NSError *error;
    NSDictionary *dictionay =
    [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error)
    {
        SVError (@"query ip[%@] location fail. Error:%@", ip, error);
        return nil;
    }

    SVIPAndISP *ipAndISP = [[SVIPAndISP alloc] init];
    [ipAndISP setAs:[dictionay valueForKey:@"as"]];
    [ipAndISP setZip:[dictionay valueForKey:@"zip"]];
    [ipAndISP setQuery:[dictionay valueForKey:@"query"]];
    [ipAndISP setLat:[dictionay valueForKey:@"lon"]];
    [ipAndISP setLon:[dictionay valueForKey:@"lon"]];
    [ipAndISP setCountry:[dictionay valueForKey:@"country"]];
    [ipAndISP setCountryCode:[dictionay valueForKey:@"countryCode"]];
    [ipAndISP setIsp:[dictionay valueForKey:@"isp"]];
    [ipAndISP setCity:[dictionay valueForKey:@"city"]];
    [ipAndISP setRegion:[dictionay valueForKey:@"region"]];
    [ipAndISP setTimezone:[dictionay valueForKey:@"timezone"]];
    [ipAndISP setOrg:[dictionay valueForKey:@"org"]];
    [ipAndISP setRegionName:[dictionay valueForKey:@"regionName"]];
    [ipAndISP setStatus:[dictionay valueForKey:@"status"]];

    SVDebug (@"return ipAndISP [as:%@  zip:%@  query:%@  lat:%@  lon:%@  country:%@  "
             @"countryCode:%@  "
             @"isp:%@  city:%@  region:%@   timezone:%@  org:%@   regionName:%@   status:%@]",
             ipAndISP.as, ipAndISP.zip, ipAndISP.query, ipAndISP.lat, ipAndISP.lon,
             ipAndISP.country, ipAndISP.countryCode, ipAndISP.isp, ipAndISP.city, ipAndISP.region,
             ipAndISP.timezone, ipAndISP.org, ipAndISP.regionName, ipAndISP.status);
    return ipAndISP;
}

@end