//
//  INNetworkStatus.m
//  OA
//
//  Created by Yigol on 16/3/22.
//  Copyright © 2016年 Injoinow. All rights reserved.
//

#import "XCNetworkStatus.h"


static XCNetworkStatus *_instance = nil;

@implementation XCNetworkStatus

#pragma mark - Custom methods
+ (XCNetworkStatus *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XCNetworkStatus alloc] init];
    });
    return _instance;
}

- (BOOL)haveNetwork
{
    [self currentInternetStatus];
    return  self.isHaveNetwork;
}

#pragma mark - System methods
- (void)dealloc
{
    self.reachDetector = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initCurrentNetwork];
    }
    return self;
}

- (void)initCurrentNetwork
{
    self.reachDetector = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [self.reachDetector startNotifier];
    [self currentInternetStatus];
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *currentReach = [notification object];
    [self refreshCurrentNetworkStatus:currentReach];
}

- (void)currentInternetStatus
{
    [self refreshCurrentNetworkStatus:self.reachDetector];
}

- (void)refreshCurrentNetworkStatus:(Reachability *)currentReach
{
    if ([currentReach isKindOfClass:[Reachability class]]) {
        NetworkStatus netStatus = [currentReach currentReachabilityStatus];
        
        switch (netStatus) {
            case NotReachable:
            {
                self.isHaveNetwork = NO;
                if (!_isTellMe)
                {
                    _isTellMe = YES;
                    _isPushNotification = NO;
                    //                    [currentReach stopNotifier];
                }
            }
                break;
            case ReachableViaWiFi:
            {
                self.isHaveNetwork = YES;
                if (!_isPushNotification)
                {
                    _isPushNotification = YES;
                    _isTellMe = NO;
                }
            }
                break;
            case ReachableViaWWAN:
            {
                self.isHaveNetwork = YES;
                if (!_isPushNotification)
                {
                    _isPushNotification = YES;
                    _isTellMe = NO;
                }
            }
                break;
                
            default:
                break;
        }
    }
}


@end
