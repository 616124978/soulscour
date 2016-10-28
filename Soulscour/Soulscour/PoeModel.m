//
//  PoeModel.m
//  Poe
//
//  Created by lanou on 16/10/26.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "PoeModel.h"

@implementation PoeModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqual:@"id"]) {
        self.poe_id = [NSString stringWithFormat:@"%@",value];
    }
}

@end
