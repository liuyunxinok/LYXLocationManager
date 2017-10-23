//
//  ViewController.m
//  定位
//
//  Created by liuyunxin on 2017/10/23.
//  Copyright © 2017年 liuyunxin. All rights reserved.
//

#import "ViewController.h"
#import "LYXLocationManager.h"


@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.locationLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.locationLabel];
    self.locationLabel.center = self.view.center;
    
    //请求授权
    [LYXLocationManager lyx_requestWhenInUseAuthorization];
    [LYXLocationManager lyx_requestAlwaysAuthorization];
    //请求用户位置信息
    [LYXLocationManager lyx_requestLocationWithController:self completeBlock:^(NSString *cityName, NSError *error) {
        if (error == nil) {
            self.locationLabel.text = cityName ?: @"未获取到位置信息";
        }else{
            self.locationLabel.text = @"获取位置错误";
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
