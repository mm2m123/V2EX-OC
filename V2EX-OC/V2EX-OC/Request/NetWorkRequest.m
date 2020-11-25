//
//  NetWorkRequest.m
//  MyBus
//
//  Created by yytmzys on 15/3/16.
//  Copyright (c) 2015年 Beijing Fengyangtianshun Technology Co., Ltd. All rights reserved.
//

#import "NetWorkRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImage+Extension.h"
#import "AppDelegate.h"

static UIAlertController *alvc;

@implementation NetWorkRequest

/// 1.检测网络状态
- (void)netWorkStatus {
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {}];
}

/// 2.JSON方式获取数据
+ (void)JSONDataWithUrl:(NSString *)url success:(void (^)(id json))success fail:(void (^)(id error))fail netWorkStatus:(void(^)(NSInteger status))statusChange {
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (statusChange) {
            statusChange(status);
        }
    }];
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{@"format": @"json"};
    [manager GET:url parameters:dict headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
}

/// 3.xml方式获取数据
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)(id error))fail {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 返回的数据格式是XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    NSDictionary *dict = @{@"format": @"xml"};
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:urlStr parameters:dict headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
}

+ (void)getJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(id error))fail {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NetWorkRequest getReady:manager And:parameters And:urlStr];
    [manager GET:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success([NetWorkRequest NetworkSuccessHandlyAndCallBack:task And:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail([NetWorkRequest NetworkFailureHandlyAndCallBack:task And:error And:urlStr]);
        }
    }];
}

+ (void)getJSONWithUrlNoBase:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(id error))fail {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString *url = [NetWorkRequest getReady:manager And:parameters And:urlStr];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = 30;
    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Contsetent-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    [manager GET:urlStr parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success([NetWorkRequest NetworkSuccessHandlyAndCallBack:task And:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail([NetWorkRequest NetworkFailureHandlyAndCallBack:task And:error And:urlStr]);
        }
    }];
}

/// 4.post提交json数据
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(NSError *error))fail {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    // 设置返回格式
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@", HTTP_BaseURL, urlStr];
    if ([urlStr isEqualToString:@"https://itunes.apple.com/lookup?bundleId=com.CCPPH.DSHFinal.Tedren"]) {
        url = urlStr;
    }
    NSMutableString *para = [NSMutableString new];
    for (NSString *key in [parameters allKeys]) {
        NSString *value = parameters[key];
//        if ([NSString validateContainsEmoji:value]) {
//            SHOWERROR(@"不能含有emoji字符")
//            return;
//        }
        if (para.length == 0) {
            [para appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        }else
        [para appendString:[NSString stringWithFormat:@"&%@=%@",key,value]];
    }
    NSLog(@"🐻URLString == %@?%@", url, para);
    [manager POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success([NetWorkRequest NetworkSuccessHandlyAndCallBack:task And:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail([NetWorkRequest NetworkFailureHandlyAndCallBack:task And:error And:urlStr]);
        }
    }];
}

//put
+ (void)putJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(id error))fail {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    manager.requestSerializer  = [AFHTTPRequestSerializer serializer];
    // 设置返回格式
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    NSString *string = parameters[KAuthorization];
    //    if (string.length > 0) {
    //        [manager.requestSerializer setValue:string forHTTPHeaderField:KAuthorization];
    //        [parameters removeObjectForKey:KAuthorization];
    //    }
    NSString *url = [NSString stringWithFormat:@"%@%@", HTTP_BaseURL, urlStr];
    NSMutableString *para = [NSMutableString new];
    for (NSString *key in [parameters allKeys]) {
        NSString *value = parameters[key];
        if (para.length == 0) {
            [para appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        }else
            [para appendString:[NSString stringWithFormat:@"&%@=%@",key,value]];
    }
    NSLog(@"🐻URLString == %@?%@", url, para);
    
    [manager PUT:url parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success([NetWorkRequest NetworkSuccessHandlyAndCallBack:task And:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail([NetWorkRequest NetworkFailureHandlyAndCallBack:task And:error And:urlStr]);
        }
    }];
}

//delete
+ (void)deleteJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(id error))fail {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NetWorkRequest getReady:manager And:parameters And:urlStr];
    [manager DELETE:url parameters:parameters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success([NetWorkRequest NetworkSuccessHandlyAndCallBack:task And:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail([NetWorkRequest NetworkFailureHandlyAndCallBack:task And:error And:urlStr]);
    }];
}

/// 5.下载文件
+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSString *fileURL))success fail:(void (^)(id error))fail {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        //        NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        [NetWorkRequest getdd:[NSString stringWithFormat:@"%@", fileURL]];
        //        NSLog(@"== %@ |||| %@", fileURL1, fileURL);
        if (success) {
            success(path);
        }
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"下载失败 %@ %@", filePath, error);
        [NetWorkRequest getdd:[NSString stringWithFormat:@"%@", filePath]];
        if (fail) {
            fail(error);
        }
    }];
    
    [task resume];
}

+ (void)getdd:(NSString *)filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    NSLog(@"大小 = %llu", [[manager attributesOfItemAtPath:filePath error:nil] fileSize] / 1024);
    if ([manager fileExistsAtPath:filePath]){
        
    }
}

/**
 * 下载文件
 */ //
+ (void)downloadFileURL:(NSString *)aUrl success:(void (^)(id responseObject))success fail:(void (^)(id error))fail {
    NSString *urlString = [aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //下载附件
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
      
    } destination:^NSURL *(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *s = response.suggestedFilename;
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"下载成功 ==%@", s);
        [NetWorkRequest getdd:path];
        if (success) {
            success(path);
        }
        
        return [NSURL fileURLWithPath:path];
        
    }completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载错误 == %@", error);
        if (fail) {
            fail(error);
        }
    }];
    

}

+ (void)PostImages:(NSString *)urlStr post:(NSMutableDictionary *)dic dicImages:(NSMutableArray *) imageArray amrFilePath:(NSString *)amrFilePath  name:(NSString *)name success:(void (^)(id result))success fail:(void (^)(id error))fail {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSString *string = dic[KAuthorization];
//    if (string.length > 0) {
//        [manager.requestSerializer setValue:GETAuthorization forHTTPHeaderField:KAuthorization];
//        [dic removeObjectForKey:KAuthorization];
//    }
    NSString *url = [NSString stringWithFormat:@"%@%@", HTTP_BaseURL, urlStr];
    NSMutableString *para = [NSMutableString new];
    for (NSString *key in [dic allKeys]) {
        NSString *value = dic[key];
        if (para.length == 0) {
            [para appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        }else
            [para appendString:[NSString stringWithFormat:@"&%@=%@",key,value]];
    }
    NSLog(@"post url == %@?%@", url, para);
    
    [manager POST:url parameters:dic headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imageArray.count; i++) {
            UIImage *image = [imageArray objectAtIndex:i];
            //防止图片旋转
            image = [image fixOrientation];
            //压缩图片
            NSData *data;
            if (image.size.height >=1024 || image.size.width >= 1024) {
                CGFloat bili = image.size.height/image.size.width;
                int a = 1024*bili;
                int b = 1024/bili;
                if (bili > 1) {
                    data =[NetWorkRequest imageWithImage:[imageArray objectAtIndex:i] scaledToSize:CGSizeMake(b,1024) ];
                }else{
                    data =[NetWorkRequest imageWithImage:[imageArray objectAtIndex:i] scaledToSize:CGSizeMake(1024,a)];
                }
            }else{
                data = UIImageJPEGRepresentation(image, 1.0);
            }
            [formData appendPartWithFileData:data name:name fileName:[NSString stringWithFormat:@"image%@.jpg", [[NSUUID UUID] UUIDString]] mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success((result));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
        NSLog(@"发pic == %@", error);
    }];
}

/// 6.文件上传－自定义上传文件名
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)(id error))fail {
    // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //@"http://localhost/demo/upload.php"
    [manager POST:urlStr parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        // 要上传保存在服务器中的名称
        // 使用时间来作为文件名 2014-04-30 14:20:57.png
        // 让不同的用户信息,保存在不同目录中
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        // 设置日期格式
        //        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        //        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        
        //@"image/png"
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" fileName:fileName mimeType:fileTye error:NULL];
    }  progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success((result));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
        
        NSLog(@"发pic == %@", error);
    }];
}

/// 7.文件上传－随机生成文件名
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)(id error))fail {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // AFHTTPResponseSerializer就是正常的HTTP请求响应结果:NSData
    // 当请求的返回数据不是JSON,XML,PList,UIImage之外,使用AFHTTPResponseSerializer
    // 例如返回一个html,text...
    //
    // 实际上就是AFN没有对响应数据做任何处理的情况
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // formData是遵守了AFMultipartFormData的对象
    
    [manager POST:urlStr parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" error:NULL];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success((result));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
        
        NSLog(@"发pic == %@", error);
    }];
    
}

//图片上传
+ (void)PostImagesToServer:(NSString *) strUrl post:(NSString *)postStr andPicFile:(NSString *)file dicImages:(NSMutableDictionary *) dicImages success:(void (^)(id result))success fail:(void (^)(id error))fail {
    
    NSMutableDictionary * params=[self getPostDictWithPostStr:postStr];
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    //NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image;//=[params objectForKey:@"pic"];
    //得到图片的data
    //NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++) {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        //if(![key isEqualToString:@"pic"]) {
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //[body appendString:@"Content-Transfer-Encoding: 8bit"];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        //}
    }
    ////添加分界线，换行
    //[body appendFormat:@"%@\r\n",MPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //循环加入上传图片
    keys = [dicImages allKeys];
    for(int i = 0; i< [keys count] ; i++){
        //要上传的图片
        image = [dicImages objectForKey:[keys objectAtIndex:i ]];
        //得到图片的data
        NSData* data =  UIImageJPEGRepresentation(image, 0.0);
        NSMutableString *imgbody = [[NSMutableString alloc] init];
        //此处循环添加图片文件
        //添加图片信息字段
        //声明pic字段，文件名为boris.png
        //[body appendFormat:[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"File\"; filename=\"%@\"\r\n", [keys objectAtIndex:i]]];
        
        ////添加分界线，换行
        [imgbody appendFormat:@"%@\r\n",MPboundary];
        //        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"File%d\"; filename=\"%@.jpg\"\r\n", i, [keys objectAtIndex:i]];
        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", file,[keys objectAtIndex:i]];
        //声明上传文件的格式
        [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
        
        NSLog(@"上传的图片：%d  %@", i, [keys objectAtIndex:i]);
        
        //将body字符串转化为UTF8格式的二进制
        //[myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //[request setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    //[request setValue:@"UTF-8" forHTTPHeaderField:@"Charsert"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    //NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //设置接受response的data
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:4];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //NSString *requestStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!connectionError) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
            NSLog(@"%@",dict);
            success(dict);
        }else{
            fail(connectionError);
        }
    }];
}

/// 适用于多图片多路径上传
+ (void)upImaWithUrl:(NSString *)urlStr andPost:(NSDictionary *)dic pngArray:(NSArray *)pngArray jpgArray:(NSArray *)jpgArray success:(void (^)(id result))success fail:(void (^)(id error))fail {
    
    [[AFHTTPSessionManager manager] POST:urlStr parameters:dic headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i =  0; i < pngArray.count; i++) {
            NSData *data =  UIImageJPEGRepresentation([pngArray objectAtIndex:i], 0.5);
            [formData appendPartWithFileData:data name:@"filela" fileName:[NSString stringWithFormat:@"filepng%d.png", i] mimeType:@"image/png"];
        }
        for (int i =  0; i < jpgArray.count; i++) {
            NSData *data2 =  UIImageJPEGRepresentation([jpgArray objectAtIndex:i], 0.5);
            [formData appendPartWithFileData:data2 name:@"file" fileName:[NSString stringWithFormat:@"filejpg%d.jpg", i] mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success((result));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          fail((error));
    }];
}

+ (NSMutableDictionary *) getPostDictWithPostStr:(NSString *)postStr {
    NSArray *array=[postStr componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    for (NSString *subStr in array) {
        NSArray *subArray=[subStr componentsSeparatedByString:@"="];
        [dict setObject:[subArray lastObject] forKey:[subArray firstObject]];
    }
    return dict;
}

//压缩图片
+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

+ (NSString *)getReady:(AFHTTPSessionManager *)manager And:(NSMutableDictionary *)parameters And:(NSString *)urlStr {
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = 30;

    [manager.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Contsetent-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];

    NSString *url = [NSString stringWithFormat:@"%@%@", HTTP_BaseURL, urlStr];
    NSMutableString *para = [NSMutableString new];
    for (NSString *key in [parameters allKeys]) {
        NSString *value = parameters[key];
        if (para.length == 0) {
            [para appendString:[NSString stringWithFormat:@"%@=%@",key,value]];
        }else
            [para appendString:[NSString stringWithFormat:@"&%@=%@",key,value]];
    }
    NSLog(@"🐻URLString == %@?%@", url, para);
    return url;
}

+ (NSDictionary *)NetworkSuccessHandlyAndCallBack:(NSURLSessionDataTask * _Nonnull)task And:( id  _Nullable)responseObject {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
    NSLog(@"🙄🙄🙄response status code: %ld", (long)[httpResponse statusCode]);
    NSMutableDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    if ([[result class] isKindOfClass:[NSMutableDictionary class]]) {
        result[@"statusCode"] = [NSString stringWithFormat:@"%ld",(long)[httpResponse statusCode]];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    NSInteger code = [result[@"code"] integerValue];
    return result;
}

+ (NSDictionary *)NetworkFailureHandlyAndCallBack:(NSURLSessionDataTask * _Nonnull)task And:(NSError * _Nonnull)error And:(NSString *)urlStr {//NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) task.response;
    NSLog(@"🙄🙄🙄response status code: %ld", (long)[httpResponse statusCode]);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSString *string = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
//    dic[@"statusCode"] = [NSString stringWithFormat:@"%ld",(long)[httpResponse statusCode]];
//    dic[@"errorMessage"] = string;
    NSDictionary *d = [self dictionaryWithJsonString:string];
//    NSInteger code = (long)[httpResponse statusCode];
    return dic;
}

+ (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [self getViewControllerWindow].rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

//获取RootViewController所在的window
+ (UIWindow*)getViewControllerWindow {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [UIApplication sharedApplication].windows;
        for (UIWindow *target in windows) {
            if (target.windowLevel == UIWindowLevelNormal) {
                window = target;
                break;
            }
        }
    }
    return window;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        while ([rootVC presentedViewController]) {
            rootVC = [rootVC presentedViewController];
        }
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
