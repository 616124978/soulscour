//
//  CHCardItemModel.h
//  CHCardView
//
//  Created by yaoxin on 16/10/8.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHCardItemModel : NSObject
@property (nonatomic, copy) NSString *localImagename;

@property (nonatomic, copy) NSString *pic;
//显示内容
@property(nonatomic,copy)NSString *title;
//更新时间
@property(nonatomic,copy)NSString *timeStr;
@end
