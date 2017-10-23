//
//  LYXLocationManager.h
//  定位
//
//  Created by liuyunxin on 2017/10/23.
//  Copyright © 2017年 liuyunxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^CompleteBlock)(NSString *, NSError *);
@interface LYXLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *lyx_locManager;
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic, weak) UIViewController *currentController;


/**
 获取单例

 @return manager
 */
+ (instancetype)sharedManager;

/**
 请求授权:使用该应用时获取用户位置
 */
+ (void)lyx_requestWhenInUseAuthorization;

/**
 请求授权:一直获取用户位置
 */
+ (void)lyx_requestAlwaysAuthorization;


/**
 请求用户位置

 @param vc 定位所在的控制器,弹框跳转设置页面用到
 @param completeBlock 用户所在城市名称/定位错误信息
 */
+ (void)lyx_requestLocationWithController:(UIViewController *)vc completeBlock:(CompleteBlock)completeBlock;




@end
