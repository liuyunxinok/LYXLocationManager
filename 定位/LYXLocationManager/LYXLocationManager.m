//
//  LYXLocationManager.m
//  定位
//
//  Created by liuyunxin on 2017/10/23.
//  Copyright © 2017年 liuyunxin. All rights reserved.
//

#import "LYXLocationManager.h"

@interface LYXLocationManager()

@property (nonatomic, copy) LYXGetDetailBlock detailBlock;
@property (nonatomic, copy) LYXGetCountryBlock countryBlock;
@property (nonatomic, copy) LYXGetProvinceBlock provinceBlock;
@property (nonatomic, copy) LYXGetCityBlock cityBlock;
@property (nonatomic, copy) LYXGetDistrictBlock districtBlock;

@end

@implementation LYXLocationManager

+ (instancetype)manager{
    static LYXLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LYXLocationManager alloc] init];
        manager.lyx_locManager = [[CLLocationManager alloc] init];
        manager.lyx_locManager.delegate = manager;
        manager.lyx_locManager.distanceFilter = 100;// 设置定位距离过滤参数 (当本次定位和上次定位之间的距离大于或等于这个值时，调用代理方法)
        manager.lyx_locManager.desiredAccuracy = kCLLocationAccuracyBest; // 设置定位精度(精度越高越耗电)
    });
    return manager;
}

+ (void)lyx_requestAlwaysAuthorization{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
        [[LYXLocationManager manager].lyx_locManager requestAlwaysAuthorization];
    }
}

+ (void)lyx_requestWhenInUseAuthorization{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
        [[LYXLocationManager manager].lyx_locManager requestWhenInUseAuthorization];
    }
}

+ (void)lyx_requestLocationWith:(LYXGetDetailBlock)completeBlock{
    [LYXLocationManager manager].detailBlock = completeBlock;
}

+ (void)lyx_requestCountryWith:(LYXGetCountryBlock)completeBlock{
    [LYXLocationManager manager].countryBlock = completeBlock;
}

+ (void)lyx_requestProvinceWith:(LYXGetProvinceBlock)completeBlock{
    [LYXLocationManager manager].provinceBlock = completeBlock;
}

+ (void)lyx_requestCityWith:(LYXGetCityBlock)completeBlock{
    [LYXLocationManager manager].cityBlock = completeBlock;
}

+(void)lyx_requestDistrictWith:(LYXGetDistrictBlock)completeBlock{
    [LYXLocationManager manager].districtBlock = completeBlock;
}


- (void)updateLocation{
    if ([CLLocationManager locationServicesEnabled]) {
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
            [[LYXLocationManager manager].lyx_locManager requestLocation];
        }else if([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
            [[LYXLocationManager manager].lyx_locManager startUpdatingLocation];
        }
    }
}


/** 定位服务状态改变时调用*/
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定授权");
//            [self jumpSystemSetting];
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
//            [self jumpSystemSetting];
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
                [self jumpSystemSetting];
            } else {
                NSLog(@"定位服务关闭，不可用");
                [self jumpSystemSetting];
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获得前后台授权");
            [self updateLocation];
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台授权");
            [self updateLocation];
            break;
        }
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    // 反地理编码(经纬度---地址)
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:manager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];
            NSString *locationInfo = [NSString stringWithFormat:@"%@%@%@%@%@%@",pl.country,pl.administrativeArea,pl.locality,pl.subLocality,pl.thoroughfare,pl.subThoroughfare];
            self.detailBlock ? self.detailBlock(locationInfo, pl, nil) : nil;
            self.provinceBlock ? self.provinceBlock(pl.administrativeArea, pl, nil): nil;
            self.cityBlock ? self.cityBlock(pl.locality,pl,nil) : nil;
            self.districtBlock ? self.districtBlock(pl.thoroughfare, pl, nil) : nil;
            
        }else
        {
            NSLog(@"错误");
            self.detailBlock ? self.detailBlock(nil, nil, error) : nil;
            self.provinceBlock ? self.provinceBlock(nil, nil, error): nil;
            self.cityBlock ? self.cityBlock(nil, nil, error) : nil;
            self.districtBlock ? self.districtBlock(nil, nil, error) : nil;
        }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations firstObject];
    NSLog(@"%@", location);
    
    // 反地理编码(经纬度---地址)
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error == nil)
        {
            CLPlacemark *pl = [placemarks firstObject];
            NSString *locationInfo = [NSString stringWithFormat:@"%@%@%@%@%@%@",pl.country,pl.administrativeArea ?: @"",pl.locality,pl.subLocality,pl.thoroughfare,pl.subThoroughfare];
            self.detailBlock ? self.detailBlock(locationInfo, pl, nil) : nil;
            self.provinceBlock ? self.provinceBlock(pl.administrativeArea, pl, nil): nil;
            self.cityBlock ? self.cityBlock(pl.locality,pl,nil) : nil;
            self.districtBlock ? self.districtBlock(pl.thoroughfare, pl, nil) : nil;        }else
        {
            NSLog(@"错误");
            self.detailBlock ? self.detailBlock(nil, nil, error) : nil;
            self.provinceBlock ? self.provinceBlock(nil, nil, error): nil;
            self.cityBlock ? self.cityBlock(nil, nil, error) : nil;
            self.districtBlock ? self.districtBlock(nil, nil, error) : nil;                }
    }];
}

#pragma mark - SystemSetting

- (void)jumpSystemSetting{
    //跳转系统定位设置
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"该应用没有权限获取您的位置信息" message:@"是否跳转系统设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转到“系统设置”->“隐私”->“定位服务”界面。
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    [[LYXLocationManager currentViewController] presentViewController:alertVC animated:YES completion:nil];
}



#pragma mark - helper

+ (UIViewController *)currentViewController {
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self atPersentViewController:viewController];
}

+ (UIViewController *)atPersentViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        return [self atPersentViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self atPersentViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self atPersentViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self atPersentViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        return vc;
    }
    
}

@end
