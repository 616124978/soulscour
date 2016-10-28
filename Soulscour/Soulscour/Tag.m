//
//  Tag.m
//  Soulscour
//
//  Created by lanou on 16/10/27.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import "Tag.h"

@implementation Tag

+(Tag *)defaultUser
{
    static Tag *t=nil;
    if (t==nil) {
        t=[[Tag alloc] init];
    }
    return t;
}

@end
