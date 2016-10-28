//
//  PoeTool.h
//  Poe
//
//  Created by lanou on 16/10/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoeModel.h"
#import <UIKit/UIKit.h>

@interface PoeTool : NSObject

//增加
+(void)addPoe:(PoeModel *)poe;

//删除
+(void)deletePoe:(PoeModel *)poe;

//查询
+(NSArray *)searchPoe:(NSString *)poeID;

//获取全部
+(NSArray *)searchAllpoe;

@end
