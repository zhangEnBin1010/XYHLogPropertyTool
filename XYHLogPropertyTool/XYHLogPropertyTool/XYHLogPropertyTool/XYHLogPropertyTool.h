//
//  XYHLogPropertyTool.h
//  XYHLogPropertyTool
//
//  Created by ydjh-apple on 2017/9/1.
//  Copyright © 2017年 zeb-apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYHLogPropertyTool : NSObject

//打印出模型分组所有属性
/**
 传入模型生成对应.h .m文件

 @param object 需要解析的模型
 @param filename 需要保存的文件名 文件名不传将默认为ResponseModel
 */
+(void)logAllPropertyWithObject:(NSObject *) object filename:(NSString *)filename;

/**
 传入data生成对应.h .m文件

 @param data 需要解析的data
 @param filename 需要保存的文件名 文件名不传将默认为ResponseModel
 */
+(void)logAllPropertyWithData:(NSData *) data filename:(NSString *)filename;

@end
