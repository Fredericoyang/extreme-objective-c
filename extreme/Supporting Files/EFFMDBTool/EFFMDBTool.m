//
//  EFFMDBTool.m
//  SmartBarrier
//
//  Created by Fredericoyang on 2019/3/7.
//  Copyright © 2017-2021 www.xfmwk.com. All rights reserved.
//

#import "EFFMDBTool.h"
#import "AttributedModel.h"

@interface EFFMDBTool ()

@end

@implementation EFFMDBTool

+ (instancetype _Nonnull)sharedTool {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *sqlFilePath = [path stringByAppendingPathComponent:[MDBName stringByAppendingString:@".sqlite"]];
    BOOL isDirectory = YES;
    BOOL tag = [manager fileExistsAtPath:sqlFilePath isDirectory:&isDirectory];
    
    static EFFMDBTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        if (!tag) {
            [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        FMDatabase *dataBase = [FMDatabase databaseWithPath:sqlFilePath];
        instance->_mdb = dataBase;
    });
    
    return instance;
}

- (FMDatabase *_Nonnull)mdb {
    return _mdb;
}


//MARK: - 数据库操作 Database open, close, ...

- (BOOL)canOpen_mdb {
    return [_mdb open];
}

- (void)close_mdb {
    [_mdb close];
}

- (BOOL)tableExistsWithModel:(Class _Nonnull)cls {
    id model = [[cls alloc] init];
    NSAssert([model isKindOfClass:[BaseDataModel class]], STRING_FORMAT(@"Model:%@ 不合规，原因：没有继承自 BaseDataModel。", [model class]));
    
    NSString *modelClass_string = NSStringFromClass([model class]);
    FMResultSet *rs = [_mdb executeQuery:@"select count(*) as 'countNum' from 'sqlite_master' where type = 'table' and name = ?", modelClass_string];
    if ([rs next]) {
        NSInteger count = [rs intForColumn:@"countNum"];
        if (count == 1) {
            return YES;
        }
    }
    return NO;
}


//MARK: - 解析 SQL 方法 Get the SQL String

- (NSString *_Nonnull)query:(Class _Nonnull)cls {
    id model = [[cls alloc] init];
    NSAssert([model isKindOfClass:[BaseDataModel class]], STRING_FORMAT(@"Model:%@ 不合规，原因：没有继承自 BaseDataModel。", cls));
    NSString *modelClass_string = NSStringFromClass([model class]);
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM '%@'", modelClass_string];
    return sql;
}

- (NSString *_Nonnull)query:(Class _Nonnull)cls dataID:(NSInteger)dataID {
    id model = [[cls alloc] init];
    NSAssert([model isKindOfClass:[BaseDataModel class]], STRING_FORMAT(@"Model:%@ 不合规，原因：没有继承自 BaseDataModel。", cls));
    NSString *modelClass_string = NSStringFromClass([model class]);
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM '%@' WHERE %@_dataID = %ld", modelClass_string, modelClass_string, (long)dataID];
    return sql;
}

- (NSString *_Nonnull)query:(Class _Nonnull)cls dataName:(NSString *_Nonnull)dataName {
    id model = [[cls alloc] init];
    NSAssert([model isKindOfClass:[BaseDataModel class]], STRING_FORMAT(@"Model:%@ 不合规，原因：没有继承自 BaseDataModel。", cls));
    NSString *modelClass_string = NSStringFromClass([model class]);
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM '%@' WHERE %@_dataName = '%@'", modelClass_string, modelClass_string, dataName];
    return sql;
}

- (NSString *_Nonnull)query:(Class _Nonnull)cls dataID:(NSInteger)dataID dataName:(NSString *_Nullable)dataName {
    id model = [[cls alloc] init];
    NSAssert([model isKindOfClass:[BaseDataModel class]], STRING_FORMAT(@"Model:%@ 不合规，原因：没有继承自 BaseDataModel。", cls));
    NSString *modelClass_string = NSStringFromClass([model class]);
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT %@.* FROM %@, AttributedModel WHERE %@.%@_dataID = AttributedModel.AttributedModel_attributedModelID AND AttributedModel.AttributedModel_dataID = %ld AND AttributedModel.AttributedModel_dataName = '%@'", modelClass_string, modelClass_string, modelClass_string, modelClass_string, (long)dataID, dataName];
    return sql;
}

- (NSString *_Nonnull)remove:(Class _Nonnull)cls dataID:(NSInteger)dataID {
    id model = [[cls alloc] init];
    NSAssert([model isKindOfClass:[BaseDataModel class]], STRING_FORMAT(@"Model:%@ 不合规，原因：没有继承自 BaseDataModel。", cls));
    NSString *modelClass_string = NSStringFromClass([model class]);
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM '%@' WHERE %@_dataID = %ld", modelClass_string, modelClass_string, (long)dataID];
    return sql;
}


//MARK: - Parser(Model based on BaseDataModel encode and decode)

- (void)parserSQL:(id _Nullable)model finish:(ParserSQLFinish)finish {
    NSAssert([model isKindOfClass:[BaseDataModel class]], STRING_FORMAT(@"Model:%@ 不合规，原因：没有继承自 BaseDataModel。", [model class]));
    NSString *modelClass_string = NSStringFromClass([model class]);
    
    NSMutableString *sql;
    //TODO: 模型对应的表不存在则建表
    if (![self tableExistsWithModel:[model class]]) {
        sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@_id' INTEGER PRIMARY KEY AUTOINCREMENT)", modelClass_string, modelClass_string];
        [((BaseDataModel *)model) enumerateBaseDataModelProperties:^(Class attribute_class, Class model_class, id key, id value) {
            if (model_class) {
                return;
            }
            if([[key substringToIndex:1] isEqualToString:@"_"]){
                key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
            }
            NSString *propertyType = @"";
            if (attribute_class == [NSString class]) {
                propertyType = @"TEXT";
            }
            else if (attribute_class == [NSNumber class]) {
                if (strcmp([value objCType], @encode(BOOL)) == 0) {
                    propertyType = @"INTEGER";
                }
                else if (strcmp([value objCType], @encode(int)) == 0) {
                    propertyType = @"INTEGER";
                }
                else if (strcmp([value objCType], @encode(float)) == 0) {
                    propertyType = @"REAL";
                }
                else {
                    propertyType = @"REAL";
                }
            }
            [sql insertString:STRING_FORMAT(@", '%@_%@' %@", modelClass_string, key, propertyType) atIndex:sql.length-1];
        } finish:^{
            BOOL success = [MDB executeUpdate:sql];
            if (finish) {
                finish(sql, success);
            }
        }];
    }
    FMResultSet *rs = [_mdb executeQuery:[self query:[model class] dataID:((BaseDataModel *)model).dataID.integerValue]];
    if (![rs next]) { //TODO: 模型对应的记录不存在则插入
        NSMutableString *columns_list = [NSMutableString string];
        NSMutableString *values_list = [NSMutableString string];
        
        sql = [NSMutableString stringWithFormat:@"INSERT INTO '%@' () VALUES ()", modelClass_string];
        __block NSInteger i = 0;
        [((BaseDataModel *)model) enumerateBaseDataModelProperties:^(Class attribute_class, Class model_class, id key, id value) {
            if([[key substringToIndex:1] isEqualToString:@"_"]){
                key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
            }
            if (model_class) { // TODO: 处理嵌入模型的属性
                AttributedModel *attributedModel = [[AttributedModel alloc] init];
                if (![self tableExistsWithModel:[attributedModel class]]) { //TODO: 先创表
                    NSString *sql_create = @"CREATE TABLE IF NOT EXISTS 'AttributedModel' ('AttributedModel_id' INTEGER PRIMARY KEY AUTOINCREMENT, 'AttributedModel_dataID' INTEGER, 'AttributedModel_dataName' TEXT, 'AttributedModel_attributedModelClass' TEXT, 'AttributedModel_attributedModelID' INTEGER)";
                    BOOL success = [self->_mdb executeUpdate:sql_create];
                    if (finish) {
                        finish(sql_create, success);
                    }
                }
                for (id embed_model in value) { //TODO: 再一一记录属性中嵌入的模型特征与标识
                    NSAssert([embed_model isKindOfClass:[BaseDataModel class]], STRING_FORMAT(@"Model:%@ 不合规，原因：没有继承自 BaseDataModel。", [model class]));
                    NSString *sql_insert = STRING_FORMAT(@"INSERT INTO 'AttributedModel' (AttributedModel_dataID, AttributedModel_dataName, AttributedModel_attributedModelClass, AttributedModel_attributedModelID) VALUES (%ld, '%@', '%@', %ld)", (long)((BaseDataModel *)model).dataID.integerValue, key, NSStringFromClass(model_class), (long)((BaseDataModel *)embed_model).dataID.integerValue);
                    BOOL success = [self->_mdb executeUpdate:sql_insert];
                    if (finish) {
                        finish(sql_insert, success);
                    }
                    if (success) { //TODO: 最后记录每个模型
                        [self parserSQL:embed_model finish:finish];
                    }
                }
            }
            else {
                if (i == 0) {
                    i = 1;
                    [columns_list appendString:STRING_FORMAT(@"%@_%@", modelClass_string, key)];
                    [values_list appendString:STRING_FORMAT(@"%@", (attribute_class == [NSString class]) ? [NSString stringWithFormat:@"'%@'", value]:value)];
                }
                else{
                    [columns_list appendString:STRING_FORMAT(@", %@_%@", modelClass_string, key)];
                    [values_list appendString:STRING_FORMAT(@", %@", (attribute_class == [NSString class]) ? [NSString stringWithFormat:@"'%@'", value]:value)];
                }
            }
        } finish:^{
            [sql insertString:columns_list atIndex:sql.length-11];
            [sql insertString:values_list atIndex:sql.length-1];
            
            BOOL success = [MDB executeUpdate:sql];
            if (finish) {
                finish(sql, success);
            }
        }];
    }
    else { //TODO: 模型对应的记录存在则更新
        sql = [NSMutableString stringWithFormat:@"UPDATE '%@' SET ", modelClass_string];
        __block NSInteger i = 0;
        @WeakObject(model);
        [((BaseDataModel *)model) enumerateBaseDataModelProperties:^(Class attribute_class, Class model_class, id key, id value) {
            if([[key substringToIndex:1] isEqualToString:@"_"]){
                key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
            }
            if (model_class) { // TODO: 处理嵌入模型的属性
                for (id embed_model in value) {
                    NSAssert([embed_model isKindOfClass:[BaseDataModel class]], STRING_FORMAT(@"Model:%@ 不合规，原因：没有继承自 BaseDataModel。", [model class]));
                    FMResultSet *rs = [self->_mdb executeQuery:[self query:[embed_model class] dataID:((BaseDataModel *)embed_model).dataID.integerValue]];
                    if (![rs next]) {
                        NSString *sql_insert = STRING_FORMAT(@"INSERT INTO 'AttributedModel' (AttributedModel_dataID, AttributedModel_dataName, AttributedModel_attributedModelClass, AttributedModel_attributedModelID) VALUES (%ld, '%@', '%@', %ld)", (long)((BaseDataModel *)model).dataID.integerValue, key, NSStringFromClass(model_class), (long)((BaseDataModel *)embed_model).dataID.integerValue);
                        BOOL success = [self->_mdb executeUpdate:sql_insert];
                        if (finish) {
                            finish(sql_insert, success);
                        }
                    }
                    [self parserSQL:embed_model finish:finish];
                }
            }
            else {
                if (i == 0) {
                    i = 1;
                    [sql appendString:STRING_FORMAT(@"%@_%@ = %@", modelClass_string, key, (attribute_class == [NSString class]) ? [NSString stringWithFormat:@"'%@'", value]:value)];
                }
                else{
                    [sql appendString:STRING_FORMAT(@", %@_%@ = %@", modelClass_string, key, (attribute_class == [NSString class]) ? [NSString stringWithFormat:@"'%@'", value]:value)];
                }
            }
        } finish:^{
            @StrongObject(model);
            [sql appendString:STRING_FORMAT(@" WHERE %@_dataID = %ld", modelClass_string, (long)((BaseDataModel *)model).dataID.integerValue)];
            
            BOOL success = [MDB executeUpdate:sql];
            if (finish) {
                finish(sql, success);
            }
        }];
    }
}

- (void)parserModel:(Class _Nonnull)cls finish:(ParserModelFinish)finish {
    [self parserModel:cls dataID:0 dataName:nil finish:finish];
}

- (void)parserModel:(Class _Nonnull)cls dataID:(NSInteger)dataID finish:(ParserModelFinish)finish {
    [self parserModel:cls dataID:dataID dataName:nil finish:finish];
}

- (void)parserModel:(Class _Nonnull)cls dataName:(NSString *_Nonnull)dataName finish:(ParserModelFinish)finish {
    [self parserModel:cls dataID:0 dataName:dataName finish:finish];
}

- (void)parserModel:(Class _Nonnull)cls dataID:(NSInteger)dataID dataName:(NSString *_Nullable)dataName finish:(ParserModelFinish)finish {
    NSAssert([[[cls alloc] init] isKindOfClass:[BaseDataModel class]], STRING_FORMAT(@"Model:%@ 不合规，原因：没有继承自 BaseDataModel。", cls));
    
    NSString *modelClass_string = NSStringFromClass(cls);
    NSString *sql;
    if (dataID > 0) {
        if (dataName) {
            sql = [self query:cls dataID:dataID dataName:dataName];
        }
        else {
            sql = [self query:cls dataID:dataID];
        }
    }
    else {
        if (dataName) {
            sql = [self query:cls dataName:dataName];
        }
        else {
            sql = [self query:cls];
        }
    }
    NSMutableArray *model_mArray = [NSMutableArray array];
    FMResultSet *rs = [_mdb executeQuery:sql];
    while ([rs next]) {
        id model = [[cls alloc] init];
        [((BaseDataModel *)model) enumerateBaseDataModelProperties:^(Class attribute_class, Class model_class, id key, id value) {
            if (model_class) {
                NSInteger dataID = [rs intForColumn:STRING_FORMAT(@"%@_dataID", modelClass_string)];
                NSString *dataName = key;
                [self parserModel:model_class dataID:dataID dataName:dataName finish:^(NSArray *_Nonnull model_array) {
                    [model setValue:model_array forKey:key];
                }];
            }
            else {
                NSString *column_name = STRING_FORMAT(@"%@_%@", modelClass_string, key);
                value = [rs objectForColumn:column_name];
                if (attribute_class == [NSString class]) {
                    if (![rs columnIsNull:column_name]) {
                        value = [rs stringForColumn:column_name];
                    }
                }
                else if (attribute_class == [NSNumber class]) {
                    if (strcmp([value objCType], @encode(BOOL)) == 0) {
                        if (![rs columnIsNull:column_name]) {
                            value = @([rs boolForColumn:column_name]);
                        }
                    }
                    else if (strcmp([value objCType], @encode(int)) == 0) {
                        if (![rs columnIsNull:column_name]) {
                            value = @([rs intForColumn:column_name]);
                        }
                    }
                    else if (strcmp([value objCType], @encode(long)) == 0) {
                        if (![rs columnIsNull:column_name]) {
                            value = @([rs longForColumn:column_name]);
                        }
                    }
                    else {
                        if (![rs columnIsNull:column_name]) {
                            value = @([rs doubleForColumn:column_name]);
                        }
                    }
                }
                [model setValue:value forKey:key];
            }
        } finish:^{
            [model_mArray addObject:model];
        }];
    }
    if (finish) {
        finish(model_mArray);
    }
}

@end
