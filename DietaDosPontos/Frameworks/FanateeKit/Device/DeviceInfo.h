//
//  DeviceInfo.h
//  Letter Zap
//
//  Created by Rafael Moris on 07/03/15.
//  Copyright (c) 2015 Fanatee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/utsname.h>
#import <netinet/in.h>
#import <sys/socket.h>

@interface DeviceInfo : NSObject

+ (NSString *)model;
+ (BOOL)hasNetworkConnection;

@end