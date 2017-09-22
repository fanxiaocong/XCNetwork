//
//  BaseNetwork.h
//  XiaoYiService
//
//  Created by 樊小聪 on 2017/4/19.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


/*
 *  备注：网络请求父类，基于 AFN 的封装 🐾
 */

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>




#define FAIL_MESSAGE_OF_NETWORK_ERROR   @"请检查您的网络设置"    /// 没有网络
#define FAIL_MESSAGE_OF_REQUEST_FAIL    @"获取数据失败"         /// 请求失败



/**
 *  @brief  网络操作成功的block处理。
 *
 *  @param result 结果, 是个泛型,具体回调依据业务层注释说明。
 */
typedef void(^NetworkSuccess)(id result);


/**
 *  @brief  网络操作失败的block处理。
 *
 *  @param reason 原因。
 */
typedef void(^NetworkFailure)(id reason);

/**
 *  网络上传进度
 *
 *  @param proress 进度
 */
typedef void (^NetworkUploadProgress)(NSProgress *proress);


/**
 *   网络下载进度
 *
 *  @param proress 进度
 */
typedef void (^NetworkDownloadProgress)(NSProgress *proress);


@interface XCNetwork : NSObject


/** 👀 服务器的请求总地址 👀 */
@property (copy, nonatomic) NSString *serviceURL;


/**
 *  关于网络请求的一些配置设置：比如请求头的设置、超时时间、是否需要序列化
 *
 *  注：父类会有一些默认的实现方式，如有需要，子类可以重写该方法。子类不需要主动调用
 */
- (BOOL)configureRequest:(BOOL)isRequestSerializer
      responseSerializer:(BOOL)isResponseSerializer;


/**
 *  @brief  通过POST方式请求服务器。
 *
 *  @param actionName           接口名字
 *  @param parameters           参数
 *  @param success              成功时候的回调
 *  @param failure              失败时候的回调
 *  @param isRequestSerializer  请求参数是否序列化
 *  @param isResponseSerializer 响应参数是否序列化
 */
- (void)sendPostRequestToServiceByPostWithAction:(NSString *)actionName
                                      parameters:(NSDictionary *)parameters
                                         success:(NetworkSuccess)success
                                         failure:(NetworkFailure)failure
                               requestSerializer:(BOOL)isRequestSerializer
                              responseSerializer:(BOOL)isResponseSerializer;


/**
 *  @brief  通过GET方式请求服务器。
 *
 *  @param actionName           接口名字
 *  @param parameters           参数
 *  @param success              成功时候的回调
 *  @param failure              失败时候的回调
 *  @param isRequestSerializer  请求参数是否序列化
 *  @param isResponseSerializer 响应参数是否序列化
 */
- (void)sendGetRequestToServiceByPostWithAction:(NSString *)actionName
                                     parameters:(NSDictionary *)parameters
                                        success:(NetworkSuccess)success
                                        failure:(NetworkFailure)failure
                              requestSerializer:(BOOL)isRequestSerializer
                             responseSerializer:(BOOL)isResponseSerializer;


/**
 *  @brief  通过POST方式上传图片
 *
 *  @param actionName           接口名字
 *  @param parameters           参数
 *  @param images               图片数组
 *  @param progress             上传进度
 *  @param success              成功时候的回调
 *  @param failure              失败时候的回调
 *  @param isRequestSerializer  请求参数是否序列化
 *  @param isResponseSerializer 响应参数是否序列化
 */
- (void)uploadImgaeToServiceByPostWithAction:(NSString *)actionName
                                  parameters:(NSDictionary *)parameters
                                      images:(NSArray *)images
                                    progress:(NetworkUploadProgress)progress
                                     success:(NetworkSuccess)success
                                     failure:(NetworkFailure)failure
                           requestSerializer:(BOOL)isRequestSerializer
                          responseSerializer:(BOOL)isResponseSerializer;


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
     responseSerializer:(BOOL)isResponseSerializer;


/**
 *  @brief  取消当前的连接。
 */
- (void)requestCancel;

@end
