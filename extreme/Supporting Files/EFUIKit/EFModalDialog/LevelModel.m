//
//  LevelModel.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/26.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "LevelModel.h"

@implementation LevelTwoModel

@end


@implementation LevelOneModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
        @"levelTwo_array": @"SecondLevel"
    }];
}

@end
