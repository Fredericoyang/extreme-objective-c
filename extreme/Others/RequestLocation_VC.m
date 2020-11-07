//
//  RequestLocation_VC.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/6/9.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "RequestLocation_VC.h"

@interface RequestLocation_VC () <CLLocationManagerDelegate>

@end

@implementation RequestLocation_VC {
    __block CLLocationManager *_locationManager;
    __block CLAuthorizationStatus _authorizationStatus;
    CLGeocoder *_geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestLocationAuthorization:YES];
}


- (IBAction)showLocationName:(id)sender {
    _geocoder = nil;
    _locationManager = nil;
    _authorizationStatus = kCLAuthorizationStatusNotDetermined;
    [self requestLocationSuccess:^(CLLocationManager *locationManager) {
        self->_geocoder = [[CLGeocoder alloc] init];
        self->_locationManager = locationManager;
        self->_locationManager.delegate = self;
        [self->_locationManager startUpdatingLocation];
        [self->_location_button setTitle:@"开始定位" forState:UIControlStateNormal];
    } failure:^(CLLocationManager *locationManager, CLAuthorizationStatus authorizationStatus) {
        self->_locationManager = locationManager;
        self->_authorizationStatus = authorizationStatus;
        switch (self->_authorizationStatus) {
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
    [_geocoder reverseGeocodeLocation:locations[0] completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError *_Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *locationName = placemark.addressDictionary[@"FormattedAddressLines"][0];
            RUN_AFTER(1, ^{
                [self->_location_button setTitle:locationName forState:UIControlStateNormal];
            });
        }
        else {
            [self->_location_button setTitle:@"位置信息不详" forState:UIControlStateNormal];
        }
    }];
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self->_location_button setTitle:FORMAT_STRING(@"定位失败，%@", error.localizedDescription) forState:UIControlStateNormal];
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
