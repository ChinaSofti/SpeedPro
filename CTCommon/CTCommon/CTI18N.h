//
//  CTInternationalControl.h
//  Localizable
//
//  Created by 许彦彬 on 16/1/22.
//  Copyright © 2016年 HuaWei. All rights reserved.
//
#define CTi18n CTI18N valueForKey
#define SetUserLanguage CTI18N setUserlanguage

#import <Foundation/Foundation.h>

@interface CTI18N : NSObject

typedef enum {
  English, //英语
  Chinese, //汉语
  System   //系统
} Language;

//设置当前语言
+ (void)setUserlanguage:(Language)language;

//根据key获取值
+ (NSString *)valueForKey:(NSString *)key;

@end
