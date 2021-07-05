//
//  NSObject+Class.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2019/3/5.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyModel : NSObject

@property (copy, nonatomic, nonnull) NSString *propertyName;
@property (copy, nonatomic, nonnull) NSString *propertyType;

@end


@interface NSObject (Class)

typedef void (^_Nullable EnumerateClass)(Class _Nonnull cls, BOOL *_Nonnull stop);
typedef void (^_Nullable EnumeratePropertiesFinish)(PropertyModel *_Nonnull pModel);
/**
 遍历所有的父类。(Enumerate every class of every super class.)

 @param enumerateClass EmunClassBlock 实例
 */
- (void)enumerateClass:(EnumerateClass)enumerateClass;
/**
 遍历所有的属性。(Enumerate every property of a class.)

 @param cls class
 @param finish EnumeratePropertiesFinish 实例
 */
- (void)enumerateProperties:(Class _Nonnull)cls finish:(EnumeratePropertiesFinish)finish;

@end
