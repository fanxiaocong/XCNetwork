//
//  INNetworkStatus.h
//  OA
//
//  Created by Yigol on 16/3/22.
//  Copyright © 2016年 Injoinow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"


@interface XCNetworkStatus : NSObject
{
    Reachability *_reachDetector;
    BOOL         _isHaveNetwork;
    BOOL         _isTellMe;
    BOOL         _isPushNotification;
}

/** 网络监测 */
@property (nonatomic, retain) Reachability *reachDetector;
/** 是否联网 */
@property BOOL isHaveNetwork;

+ (XCNetworkStatus *)shareInstance;

- (BOOL)haveNetwork;

@end
