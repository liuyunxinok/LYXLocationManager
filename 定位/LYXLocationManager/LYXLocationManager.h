//
//  LYXLocationManager.h
//  定位
//
//  Created by liuyunxin on 2017/10/23.
//  Copyright © 2017年 liuyunxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LYXGetCountryBlock)(NSString *country, CLPlacemark *placemark, NSError *error);
typedef void(^LYXGetProvinceBlock)(NSString *province,CLPlacemark *placemark, NSError *error);
typedef void(^LYXGetCityBlock)(NSString *city,CLPlacemark *placemark, NSError *error);
typedef void(^LYXGetDistrictBlock)(NSString *city,CLPlacemark *placemark, NSError *error);
typedef void(^LYXGetDetailBlock)(NSString *locationDetail,CLPlacemark *placemark, NSError *error);

@interface LYXLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *lyx_locManager;

/**
 获取单例

 @return manager
 */
+ (instancetype)manager;

/**
 请求授权:使用该应用时获取用户位置
 */
+ (void)lyx_requestWhenInUseAuthorization;

/**
 请求授权:一直获取用户位置
 */
+ (void)lyx_requestAlwaysAuthorization;


/**
 get user locationInfo
 
 @param completeBlock 用户所在详细地址/定位错误信息
 */
+ (void)lyx_requestLocationWith:(LYXGetDetailBlock)completeBlock;


/**
 get user country

 @param completeBlock country
 */
+ (void)lyx_requestCountryWith:(LYXGetCountryBlock)completeBlock;

/**
 get user provice

 @param completeBlock provice
 */
+ (void)lyx_requestProvinceWith:(LYXGetProvinceBlock)completeBlock;

/**
 get user city

 @param completeBlock city
 */
+ (void)lyx_requestCityWith:(LYXGetCityBlock)completeBlock;

/**
 get user district

 @param completeBlock district
 */
+ (void)lyx_requestDistrictWith:(LYXGetDistrictBlock)completeBlock;

@end
