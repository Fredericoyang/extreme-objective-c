//
//  EFFMDBTool.h
//  SmartBarrier
//
//  Created by Fredericoyang on 2019/3/7.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

@interface EFFMDBTool : NSObject

/**
 FMDatabase 实例
 */
@property (strong, nonatomic, nonnull) FMDatabase *mdb;

/**
 创建 MDB 实例，如果数据库不存在会自动创建，数据库名 MDBName 在 AppConfig 配置。(Get instance of EFFMDBTool, create database named in AppConfig if not exist.)

 @return EFFMDBTool 实例
 */
+ (instancetype _Nonnull)sharedTool;

/**
 FMDatabase 实例，通过方法获取。(Get instance of FMDatabase with method style.)

 @return FMDatabase 实例
 */
- (FMDatabase *_Nonnull)mdb;


//MARK: - 数据库操作 Database open, close, ...
/**
 打开数据库是否成功。(Open the database successed or not.)

 @return 操作执行结果，YES 成功 NO 失败
 */
- (BOOL)canOpen_mdb;
/**
 关闭数据库。(Close the database.)
 */
- (void)close_mdb;
/**
 Model(基于 BaseDataModel)  对应的表是否已创建。(The table named of the model's name based on BaseDataModel was created or not.)

 @param cls Class of model based on BaseDataModel
 @return 检查结果，YES 已创建，NO 未创建
 */
- (BOOL)tableExistsWithModel:(Class _Nonnull)cls;

//MARK: - 解析 SQL 方法 Get the SQL String
/**
 解析为 SELECT SQL，提供 model(基于 BaseDataModel) 的类。(Get the SQL like "SELECT * FROM modelName" with class of a model based on BaseDataModel.)

 @param cls Class of model based on BaseDataModel
 @return sql string
 */
- (NSString *_Nonnull)query:(Class _Nonnull)cls;
/**
 解析为 SELECT SQL，提供 model(基于 BaseDataModel) 的类和 dataID。(Get the SQL like "SELECT * FROM modelName WHERE modelName_dataID = 99" with class and dataID of a model based on BaseDataModel.)

 @param cls Class of model based on BaseDataModel
 @param dataID "dataID" of model based on BaseDataModel
 @return sql string
 */
- (NSString *_Nonnull)query:(Class _Nonnull)cls dataID:(NSInteger)dataID;
/**
 解析为 SELECT SQL，提供 model(基于 BaseDataModel) 的类和 dataName。(Get the SQL like "SELECT * FROM modelName WHERE modelName_dataName = 'Color'" with class and dataName of a model based on BaseDataModel.)
 
 @param cls Class of model based on BaseDataModel
 @param dataName "dataName" of model based on BaseDataModel
 @return sql string
 */
- (NSString *_Nonnull)query:(Class _Nonnull)cls dataName:(NSString *_Nonnull)dataName;
/**
 解析为 DELETE SQL，提供 model(基于 BaseDataModel) 的类和 dataID。(Get the SQL like "DELETE FROM modelName WHERE modelName_dataID = 99" with class and dataID of a model based on BaseDataModel.)

 @param cls Class of model based on BaseDataModel
 @param dataID "dataID" of model based on BaseDataModel
 @return sql string
 */
- (NSString *_Nonnull)remove:(Class _Nonnull)cls dataID:(NSInteger)dataID;

//MARK: - Parser(Model based on BaseDataModel encode and decode)
typedef void (^_Nullable ParserSQLFinish)(NSString *_Nonnull sql, BOOL success);
typedef void (^_Nullable ParserModelFinish)(NSArray *_Nonnull model_array);
/**
 Model(基于 BaseDataModel) 存入，支持嵌入模型的属性，但嵌入的模型也要基于 BaseDataModel。(Model based on BaseDataModel encode by database, and embed model based on BaseDataModel also supported.)
 
 @param model Model based on BaseDataModel
 @param finish 解析完成回调，ParserSQLFinishBlock 实例
 */
- (void)parserSQL:(id _Nullable)model finish:(ParserSQLFinish)finish;
/**
 Model(基于 BaseDataModel) 取出，提供 model(基于 BaseDataModel)的类。(Model based on BaseDataModel decode from database with class of a model based on BaseDataModel.)
 
 @param cls Class of model based on BaseDataModel
 @param finish 解析完成回调，ParserModelFinishBlock 实例
 */
- (void)parserModel:(Class _Nonnull)cls finish:(ParserModelFinish)finish;
/**
 Model(基于 BaseDataModel) 取出，提供 model(基于 BaseDataModel) 的类和 dataID。(Model based on BaseDataModel decode from database with class and dataID of a model based on BaseDataModel.)
 
 @param cls Class of model based on BaseDataModel
 @param dataID "dataID" of model based on BaseDataModel
 @param finish 解析完成回调，ParserModelFinishBlock 实例
 */
- (void)parserModel:(Class _Nonnull)cls dataID:(NSInteger)dataID finish:(ParserModelFinish)finish;
/**
 Model(基于 BaseDataModel) 取出，提供 model(基于 BaseDataModel) 的类和 dataName。(Model based on BaseDataModel decode from database with class and dataName of a model based on BaseDataModel.)
 
 @param cls Class of model based on BaseDataModel
 @param dataName "dataName" of model based on BaseDataModel
 @param finish 解析完成回调，ParserModelFinishBlock 实例
 */
- (void)parserModel:(Class _Nonnull)cls dataName:(NSString *_Nonnull)dataName finish:(ParserModelFinish)finish;

@end
