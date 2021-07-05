//
//  ContactModel.h
//  ExtremeFramework
//
//  Created by Fredericoyang on 2017/8/1.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@interface ContactInfoModel : BaseDataModel

@property (copy, nonatomic, nullable) NSString *dataContent;

@end

@protocol ContactInfoModel <NSObject>

@end


@interface ContactModel : BaseDataModel

@property (strong, nonatomic, nullable) NSArray<ContactInfoModel, Optional>* contactInfo;
/**
 联系人姓名
 */
@property (copy, nonatomic, nullable) NSString<Optional>* contactName;

@end
