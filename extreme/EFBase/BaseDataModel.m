//
//  BaseDataModel.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2018/12/28.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "BaseDataModel.h"
#import "EFMacros.h"
#import "NSObject+Class.h"

@implementation BaseDataModel

//MARK: Coding
CodingImplmentation

//MARK: Parser
- (void)enumerateBaseDataModelProperties:(EnumerateBaseDataModelProperties)enumerateBaseDataModelPropertiesBlock finish:(EnumerateBaseDataModelPropertiesFinish)finishBlock {
    [self enumerateClass:^(__unsafe_unretained Class cls, BOOL *stop) {
        if (cls == [JSONModel class]) {
            if (finishBlock) {
                finishBlock();
            }
            return;
        }
        [self enumerateProperties:cls finish:^(PropertyModel *pModel) {
            NSString *attributeTypeString = pModel.propertyType;
            NSString *name = pModel.propertyName;
            Class attributeClass;
            Class attributeModelClass;
            if ([attributeTypeString hasPrefix:@"@\""]) {
                attributeTypeString = [attributeTypeString substringWithRange:NSMakeRange(2, attributeTypeString.length-3)];
                if ([attributeTypeString containsString:@"<"]) {
                    NSArray *separate_classes = [attributeTypeString componentsSeparatedByString:@"<"];
                    attributeTypeString = separate_classes[0];
                    NSString *attributeModelTypeString;
                    if (separate_classes.count > 2) {
                        attributeModelTypeString = separate_classes[1];
                        attributeModelTypeString = [attributeModelTypeString substringToIndex:attributeModelTypeString.length-1];
                        attributeModelClass = NSClassFromString(attributeModelTypeString);
                    }
                }
                attributeClass = NSClassFromString(attributeTypeString);
            }
            if (attributeClass && enumerateBaseDataModelPropertiesBlock) {
                enumerateBaseDataModelPropertiesBlock(attributeClass, attributeModelClass, name, [self valueForKey:name]);
            }
        }];
    }];
}

@end
