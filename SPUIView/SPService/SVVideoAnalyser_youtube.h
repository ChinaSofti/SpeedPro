//
//  TSVideoAnalyser_Youtube.h
//  TaskService
//
//  Created by Rain on 1/29/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "SVVideoAnalyser.h"

@interface SVVideoAnalyser_youtube : SVVideoAnalyser


/**
 *  对视频URL进行分析
 */
- (SVVideoInfo *)analyse;

/**
 *  修改Signarture
 *
 *  @param signature 旧Signarture
 *
 *  @return 新Signarture
 */
- (NSString *)modifySignarture:(NSString *)signature;

@end
