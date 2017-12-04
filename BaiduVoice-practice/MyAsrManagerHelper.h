//
//  MyAsrManagerHelper.h
//  BaiduVoice-practice
//
//  Created by 欧阳昌帅 on 2017/11/16.
//  Copyright © 2017年 0easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAsrManagerHelper : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign) BOOL autoStop;

@property (nonatomic, copy) void(^asrBlock)(NSString *resultStr);

- (void)start;

- (void)stop;

@end
