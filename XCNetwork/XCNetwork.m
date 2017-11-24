//
//  BaseNetwork.m
//  XiaoYiService
//
//  Created by 樊小聪 on 2017/4/19.
//  Copyright © 2017年 樊小聪. All rights reserved.
//



/*
 *  备注：网络请求父类，基于 AFN 的封装 🐾
 */


#import "XCNetwork.h"
#import "XCNetworkStatus.h"



#if DEBUG
#define DLog(format, ...) do {                                             \
fprintf(stderr, "<%s : line(%d)> %s\n",     \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                        \
printf("%s\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);           \
fprintf(stderr, "-------------------\n");   \
} while (0)
#else
#define DLog(format, ...) nil
#endif



@interface XCNetwork ()

/** 👀 下载管理类 👀 */
@property (strong, nonatomic) AFURLSessionManager *downloadManager;

/** 👀 下载任务 👀 */
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;

@end


@implementation XCNetwork

- (void)setManager:(AFHTTPSessionManager *)manager
{
    _manager = manager;
}


#pragma mark - 🔓 👀 Public Method 👀


- (BOOL)configureRequest:(BOOL)isRequestSerializer
      responseSerializer:(BOOL)isResponseSerializer
{
    DLog(@"设置请求配置开始。");
    
    if (![[XCNetworkStatus shareInstance] haveNetwork]) {
        
        return NO;
    }
    
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer.acceptableContentTypes = [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    self.manager.requestSerializer.timeoutInterval = 30;
    
    // 请求参数是否需要序列化。
    if (isRequestSerializer) {
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    // 返回参数是否需要序列化。
    if (isResponseSerializer) {
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    DLog(@"设置请求配置  结束。");
    return YES;
}

/**
 *  @brief  通过POST方式请求服务器。
 *
 *  @param url                  接口请求地址
 *  @param parameters           参数
 *  @param success              成功时候的回调
 *  @param failure              失败时候的回调
 *  @param isRequestSerializer  请求参数是否序列化
 *  @param isResponseSerializer 响应参数是否序列化
 */
- (void)sendPostRequestToServiceByPostWithURL:(NSString *)url
                                   parameters:(NSDictionary *)parameters
                                      success:(NetworkSuccess)success
                                      failure:(NetworkFailure)failure
                            requestSerializer:(BOOL)isRequestSerializer
                           responseSerializer:(BOOL)isResponseSerializer
{
    DLog(@"请求开始，请求方式为 *********************** ：POST");
    
    BOOL b = [self configureRequest:isRequestSerializer responseSerializer:isResponseSerializer];
    
    if (!b)
    {
        // 请检查您的网络设置 , 网络断开
        failure(FAIL_MESSAGE_OF_NETWORK_ERROR);
        
        DLog(@"请求结束，请求方式为 ***********************：POST");
        
        return ;
    }
    
    DLog(@"请求地址：%@", url);
    
    DLog(@"请求参数：%@", parameters);
    
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"responseObject:  %@", responseObject);
                
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"请求结果失败 原因:%@", error.localizedDescription);
        DLog(@"请求结束，请求方式为：POST");
        
        failure(FAIL_MESSAGE_OF_REQUEST_FAIL);
    }];
}


/**
 *  @brief  通过GET方式请求服务器。
 *
 *  @param url                  接口请求地址
 *  @param parameters           参数
 *  @param success              成功时候的回调
 *  @param failure              失败时候的回调
 *  @param isRequestSerializer  请求参数是否序列化
 *  @param isResponseSerializer 响应参数是否序列化
 */
- (void)sendGetRequestToServiceByPostithURL:(NSString *)url
                                 parameters:(NSDictionary *)parameters
                                    success:(NetworkSuccess)success
                                    failure:(NetworkFailure)failure
                          requestSerializer:(BOOL)isRequestSerializer
                         responseSerializer:(BOOL)isResponseSerializer
{
    DLog(@"请求开始，请求方式为 *********************** ：GET");
    
    BOOL b = [self configureRequest:isRequestSerializer responseSerializer:isResponseSerializer];
    
    if (!b) {
        // 请检查您的网络设置 , 网络断开
        failure(FAIL_MESSAGE_OF_NETWORK_ERROR);
        
        DLog(@"请求结束，请求方式为 *********************** ：GET");
        
        return ;
    }
    
    DLog(@"请求地址：%@", url);
    
    DLog(@"请求参数：%@", parameters);
    
    [self.manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"responseObject:  %@", responseObject);
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"请求结果失败 原因:%@", error.localizedDescription);
        DLog(@"请求结束，请求方式为：GET");
        
        failure(FAIL_MESSAGE_OF_REQUEST_FAIL);
    }];
    
    DLog(@"GET请求结束");
}


/**
 *  @brief  通过POST方式上传图片
 *
 *  @param url                  接口请求地址
 *  @param parameters           参数
 *  @param images               图片数组
 *  @param directoryName        服务器文件夹名称
 *  @param progress             上传进度
 *  @param success              成功时候的回调
 *  @param failure              失败时候的回调
 *  @param isRequestSerializer  请求参数是否序列化
 *  @param isResponseSerializer 响应参数是否序列化
 */
- (void)uploadImgaeToServiceByPostWithURL:(NSString *)url
                               parameters:(NSDictionary *)parameters
                                   images:(NSArray *)images
                            directoryName:(NSString *)directoryName
                                 progress:(NetworkUploadProgress)progress
                                  success:(NetworkSuccess)success
                                  failure:(NetworkFailure)failure
                        requestSerializer:(BOOL)isRequestSerializer
                       responseSerializer:(BOOL)isResponseSerializer
{
    DLog(@"请求开始...上传图片，请求方式为：POST");
    BOOL b = [self configureRequest:isRequestSerializer responseSerializer:isResponseSerializer];
    if (!b) {
        
        DLog(@"请求结束，请求方式为：POST");
        
        failure(FAIL_MESSAGE_OF_NETWORK_ERROR);
        
        return;
    }
    
    DLog(@"请求地址：%@", url);
    DLog(@"请求参数：%@", parameters);
    
    
    /// 服务器上存储图片的文件夹的名称
    NSMutableArray *directoryNames = [NSMutableArray array];
    /// 图片名称
    NSMutableArray *fileNames = [NSMutableArray array];
    if (images)
    {
        for (NSInteger i = 0 ;i < images.count; i ++)
        {
            // 生成一个唯一的图片名称
            NSString *imgName = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
            
            DLog(@"fileName:  %@", [NSString stringWithFormat:@"fileName_%@_%ld.png",imgName,(long)i]);
            
            [directoryNames addObject:directoryName];
            [fileNames addObject:imgName];
        }
    }
    
    [self uploadImgaeToServiceByPostWithURL:url
                                 parameters:parameters
                                     images:images
                             directoryNames:directoryNames
                                  fileNames:fileNames
                                   progress:progress
                                    success:success
                                    failure:failure
                          requestSerializer:isRequestSerializer
                         responseSerializer:isResponseSerializer];
    
//    [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        if (images)
//        {
//            for (NSInteger i = 0 ;i < images.count; i ++)
//            {
//                // 生成一个唯一的图片名称
//                NSString *imgName = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
//
//                DLog(@"fileName:  %@", [NSString stringWithFormat:@"fileName_%@_%ld.png",imgName,(long)i]);
//
//                NSData *imageData = UIImagePNGRepresentation(images[i]);
//                [formData appendPartWithFileData:imageData name:directoryName fileName:[NSString stringWithFormat:@"fileName_%@_%ld.png",imgName,(long)i] mimeType:@"image/png"];
//            }
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
////        DLog(@"上传进度:%@", uploadProgress);
//        progress(uploadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DLog(@"请求结束，请求方式为：POST");
//        DLog(@"responseObject:  %@", responseObject);
//
//        success(responseObject);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        DLog(@"请求结果失败 原因:%@", error.localizedDescription);
//        DLog(@"请求结束，请求方式为：POST");
//
//        failure(FAIL_MESSAGE_OF_REQUEST_FAIL);
//    }];
//    DLog(@"请求结束 ...上传图片，请求方式为：POST");
}


/**
 *  @brief  通过POST方式上传图片
 *
 *  @param url                  接口请求地址
 *  @param parameters           参数
 *  @param images               图片数组
 *  @param directoryNames       服务器文件夹名称
 *  @param fileNames            图片文件名称
 *  @param progress             上传进度
 *  @param success              成功时候的回调
 *  @param failure              失败时候的回调
 *  @param isRequestSerializer  请求参数是否序列化
 *  @param isResponseSerializer 响应参数是否序列化
 */
- (void)uploadImgaeToServiceByPostWithURL:(NSString *)url
                               parameters:(NSDictionary *)parameters
                                   images:(NSArray *)images
                           directoryNames:(NSArray *)directoryNames
                                fileNames:(NSArray *)fileNames
                                 progress:(NetworkUploadProgress)progress
                                  success:(NetworkSuccess)success
                                  failure:(NetworkFailure)failure
                        requestSerializer:(BOOL)isRequestSerializer
                       responseSerializer:(BOOL)isResponseSerializer
{
    DLog(@"请求开始...上传图片，请求方式为：POST");
    BOOL b = [self configureRequest:isRequestSerializer responseSerializer:isResponseSerializer];
    if (!b) {
        
        DLog(@"请求结束，请求方式为：POST");
        
        failure(FAIL_MESSAGE_OF_NETWORK_ERROR);
        
        return;
    }
    
    DLog(@"请求地址：%@", url);
    DLog(@"请求参数：%@", parameters);
    
    [self.manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (images)
        {
            for (NSInteger i = 0 ;i < images.count; i ++)
            {
                /// 图片名称、图片所在文件夹名称（与服务上保持一致）
                NSString *fileName  = fileNames[i]; // 图片所在文件夹名称
                NSString *name = directoryNames[i]; // 图片名称
                
                NSData *imageData = UIImagePNGRepresentation(images[i]);
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        DLog(@"上传进度:%@", uploadProgress);
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"请求结束，请求方式为：POST");
        DLog(@"responseObject:  %@", responseObject);
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"请求结果失败 原因:%@", error.localizedDescription);
        DLog(@"请求结束，请求方式为：POST");
        
        failure(FAIL_MESSAGE_OF_REQUEST_FAIL);
    }];
    DLog(@"请求结束 ...上传图片，请求方式为：POST");
}


/**
 *  @brief  下载文件
 *
 *  @param url                  文件地址
 *  @param path                 要存储的路径
 *  @param progress             下载进度
 *  @param success              成功时候的回调
 *  @param failure              失败时候的回调
 *  @param isRequestSerializer  请求参数是否序列化
 *  @param isResponseSerializer 响应参数是否序列化
 *
 */
- (void)downloadWithURL:(NSString *)url
        destinationPath:(NSString *)path
               progress:(NetworkDownloadProgress)progress
                success:(NetworkSuccess)success
                failure:(NetworkFailure)failure
      requestSerializer:(BOOL)isRequestSerializer
     responseSerializer:(BOOL)isResponseSerializer
{
    // 远程地址
    NSURL *URL = [NSURL URLWithString:url];
    
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    if (![[XCNetworkStatus shareInstance] haveNetwork])
    {
        failure(FAIL_MESSAGE_OF_NETWORK_ERROR);
        
        DLog(@"没有网络");
        return ;
    }
    
    self.downloadManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // 下载Task操作
    [self.downloadManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // 下载进度
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        // 文件的下载路径
        NSString *filePath = [path stringByAppendingPathComponent:response.suggestedFilename];
        
        DLog(@"文件下载路径：   %@", filePath);
        
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        // 下载完成
        if (!error)
        {
            // 下载成功
            success(response);
        }
        else
        {
            // 下载失败
            failure(error);
        }
    }];
    
    //开始启动任务
    [self.downloadTask resume];
}


/**
 *  @brief  取消当前的连接。
 */
- (void)requestCancel
{
    if (self.downloadTask)
    {
        [self.downloadTask cancel];
    }

    DLog(@"取消请求  结束。");
}


@end
