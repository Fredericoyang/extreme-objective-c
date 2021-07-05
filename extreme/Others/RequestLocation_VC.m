//
//  RequestLocation_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/9.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "RequestLocation_VC.h"

@interface RequestLocation_VC () <CLLocationManagerDelegate>

@end

@implementation RequestLocation_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestLocationAuthorization:YES];
}


- (IBAction)showLocationName:(id)sender {
    [self requestLocationSuccessHandler:^(CLLocationManager *locationManager) {
        locationManager.delegate = self;
        
        if (@available(iOS 14, *)) {
            [self requestLocationTemporaryFullAccuracyAuthorizationWithPurposeKey:temporaryFullAccuracyPurposeKey1 authorizedHandler:^{
                [locationManager startUpdatingLocation];
                [self->_location_button setTitle:@"开始定位" forState:UIControlStateNormal];
            } deniedHandler:^{
                [SVProgressHUD showErrorWithStatus:@"要使用此功能必须开启精确定位"];
                [self->_location_button setTitle:@"重新尝试" forState:UIControlStateNormal];
            }];
        } else {
//            [locationManager requestLocation]; // location once
            [locationManager startUpdatingLocation];
            [self->_location_button setTitle:@"开始定位" forState:UIControlStateNormal];
        }
    } failureHandler:^(CLLocationManager *locationManager, CLAuthorizationStatus authorizationStatus) {
        switch (authorizationStatus) {
            case kCLAuthorizationStatusRestricted:
                [self->_location_button setTitle:@"访问限制已开启" forState:UIControlStateNormal];
                break;
                
            case kCLAuthorizationStatusDenied:
                [self->_location_button setTitle:@"定位权限已禁止" forState:UIControlStateNormal];
                break;
                
            default:
                [self->_location_button setTitle:@"未知错误" forState:UIControlStateNormal];
                break;
        }
    }];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError *_Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.firstObject;
            [self->_location_button setTitle:STRING_FORMAT(@"%@%@%@%@ %@", placemark.country, placemark.administrativeArea, placemark.locality, placemark.subLocality, placemark.name) forState:UIControlStateNormal];
        }
        else {
            [self->_location_button setTitle:@"位置信息不详" forState:UIControlStateNormal];
        }
        [manager stopUpdatingLocation];
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self->_location_button setTitle:STRING_FORMAT(@"定位失败，%@", error.localizedDescription) forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
