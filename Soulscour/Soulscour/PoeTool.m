//
//  PoeTool.m
//  Poe
//
//  Created by lanou on 16/10/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "PoeTool.h"
#import "FMDB.h"

static FMDatabase *_db;

@implementation PoeTool

NSString *_path;

//只会在当前类第一次使用的时候调用
+(void)initialize {
    
    //创建路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"doc = %@",doc);
    _path = [doc stringByAppendingPathComponent:@"t_poe"];
    //根据路径创建一个fmdatabase对象
    _db = [FMDatabase databaseWithPath:_path];
    
    //创建表
    if ([_db open]) {
        [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_poe(response TEXT NOT NULL, poe_id TEXT NOT NULL, title TEXT NOT NULL, artist TEXT NOT NULL, content TEXT NOT NULL);"];
    }
    [_db close];
}

+(void)addPoe:(PoeModel *)poe {
    [_db open];
    
    [_db executeUpdate:@"INSERT INTO t_poe(response, poe_id, title, artist, content)VALUES(?, ?, ?, ?, ?);",poe.response,poe.poe_id,poe.title,poe.artist,poe.content];
    
    [_db close];
}

+(void)deletePoe:(PoeModel *)poe {
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM t_poe where poe_id = ?",poe.poe_id];
    
    [_db close];
}

+(NSArray *)searchPoe:(NSString *)poeID {
    [_db open];
    
    //返回值是一个结果集
    FMResultSet *resultSet = [_db executeQuery:@"select * from t_poe where poe_id = ?;",poeID];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([resultSet next]) {
        NSString *response = [resultSet objectForColumnName:@"response"];
        NSString *poe_id = [resultSet objectForColumnName:@"poe_id"];
        NSString *title = [resultSet objectForColumnName:@"title"];
        NSString *artist = [resultSet objectForColumnName:@"artist"];
        NSString *content = [resultSet objectForColumnName:@"content"];
        
        PoeModel *poe = [[PoeModel alloc] init];
        poe.response = response;
        poe.poe_id = poe_id;
        poe.title = title;
        poe.artist = artist;
        poe.content = content;
        
        [array addObject:poe];
    }
    [_db close];
    return array;
}

+(NSArray *)searchAllpoe {
    [_db open];
    
    //返回值是一个结果集
    FMResultSet *resultSet = [_db executeQuery:@"select * from t_poe;"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([resultSet next]) {
        NSString *response = [resultSet objectForColumnName:@"response"];
        NSString *poe_id = [resultSet objectForColumnName:@"poe_id"];
        NSString *title = [resultSet objectForColumnName:@"title"];
        NSString *artist = [resultSet objectForColumnName:@"artist"];
        NSString *content = [resultSet objectForColumnName:@"content"];
        
        PoeModel *poe = [[PoeModel alloc] init];
        poe.response = response;
        poe.poe_id = poe_id;
        poe.title = title;
        poe.artist = artist;
        poe.content = content;
        
        [array addObject:poe];
    }
    [_db close];
    return array;
}

@end
