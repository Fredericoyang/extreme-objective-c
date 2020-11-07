//
//  ContactModel.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"dataID": @"ContactID",      // dataID用作ContactID
                                                                  @"dataName": @"ContactName"   // dataName用作ContactName
                                                                  }];
}

@end
