# LYXLocationManager
在我们使用app的过程中，很普遍的见到请求我们所在的位置信息，用来匹配附近，同城的展示信息。为以后重复造轮子，方便使用，抽出来封装了LYXLocationManager. 里面的api可以方便的获取用户的详细位置信息，独立的county, province, city, district等信息获取。

# 集成方式：

## 1.由于比较轻量，下载下来，当做一个工具类，导入项目中。

## 2.在需要使用的vc中导入下面的头文件

      #import "LYXLocationManager.h"

## 3.使用下的方法获取用户位置信息

      //请求授权
      [LYXLocationManager lyx_requestWhenInUseAuthorization];
      [LYXLocationManager lyx_requestAlwaysAuthorization];
      //请求用户位置信息
      [LYXLocationManager lyx_requestLocationWith:^(NSString *locationDetail, CLPlacemark *placemark, NSError *error) {
            if (error == nil) {
                self.locationLabel.text = locationDetail ?: @"未获取到位置信息";
            }else{
                self.locationLabel.text = @"获取位置错误";
            }
      }];
