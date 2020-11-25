//
//  NetWorkRequest.h
//  MyBus
//
//  Created by yytmzys on 15/3/16.
//  Copyright (c) 2015年 Beijing Fengyangtianshun Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetWorkRequest : NSObject

/**
 POST请求

 @param urlStr 请求URL
 @param parameters 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(NSError *error))fail;

/**
 PUT请求

 @param urlStr 请求URL
 @param parameters 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)putJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(id error))fail;
/**
 DELETE请求

 @param urlStr 请求URL
 @param parameters 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)deleteJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(id error))fail;
/**
 GET请求

 @param urlStr 请求URL
 @param parameters 请求参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)getJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(id error))fail;

/// 适用于多图片多路径上传
+ (void)PostImages:(NSString *)urlStr post:(NSMutableDictionary *)dic dicImages:(NSMutableArray *) imageArray amrFilePath:(NSString *)amrFilePath name:(NSString *)name success:(void (^)(id result))success fail:(void (^)(id error))fail;
/// 5.下载文件
+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSString *fileURL))success fail:(void (^)(id error))fail;
+ (void)downloadFileURL:(NSString *)aUrl success:(void (^)(id responseObject))success fail:(void (^)(id error))fail;
+ (void)getJSONWithUrlNoBase:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(id error))fail;
@end
