//
//  ContactModel.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactInfoModel

@end


@implementation ContactModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
        @"dataID": @"ContactID",          // dataID用作 ContactID
        @"dataName": @"ContactMobile",    // dataName用作 ContactMobile
        @"contactName": @"ContactName",
        @"contactInfo": @"ContactInfo"
    }];
}

@end
