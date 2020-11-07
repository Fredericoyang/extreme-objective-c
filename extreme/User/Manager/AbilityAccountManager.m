//
//  AbilityAccountManager.m
//  ExtremeFramework
//
//  Created by Fredericoyang on 2019/9/5.
//  Copyright © 2017-2019 www.xfmwk.com. All rights reserved.
//

#import "AbilityAccountManager.h"

@implementation AbilityAccountManager

+ (NSURLSessionDataTask *)loginWithUserName:(NSString *)username password:(NSString *)password result:(RequestResultBlock)result {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:username forKey:@"username"];
    [paramDict setObject:password forKey:@"password"];
    
    return [AppHTTPTool HTTPRequestWithPOST:RU_login params:paramDict result:result];
}

+ (NSURLSessionDataTask *)myNickNameResult:(RequestResultBlock)result {
    return [AppHTTPTool HTTPRequestWithGET:RU_myNickName params:nil authorized:YES result:result];
}

@end
