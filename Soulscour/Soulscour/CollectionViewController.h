//
//  CollectionViewController.h
//  Soulscour
//
//  Created by lanou on 16/10/28.
//  Copyright © 2016年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController


@property(nonatomic,copy)void (^sendBlock)(NSString *collecedPoe_id);

@end
