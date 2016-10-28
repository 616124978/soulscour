//
//  CHCardItemCustomView.m
//  CHCardView
//
//  Created by yaoxin on 16/10/9.
//  Copyright © 2016年 Charles. All rights reserved.
//

#define kscHeight [UIScreen mainScreen].bounds.size.height
#define kscWidth  [UIScreen mainScreen].bounds.size.width

#import "CHCardItemCustomView.h"
#import "CHCardItemModel.h"

#import "UIImageView+WebCache.h"

@interface CHCardItemCustomView ()
@property (nonatomic, weak) UIImageView *imgView;
//显示文字
@property (nonatomic,weak)UILabel *label;
//显示更新时间
@property(nonatomic,weak)UILabel *timeLabel;
@end

@implementation CHCardItemCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setItemModel:(CHCardItemModel *)itemModel {
    _itemModel = itemModel;
    
    self.label.text=itemModel.title;
    self.timeLabel.text=itemModel.timeStr;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:itemModel.pic]];

    
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    CGRect imgFrame=self.imgView.frame;
//    imgFrame.size.width=self.bounds.size.width-100;
//    self.imgView.frame=imgFrame;
//    
    self.imgView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-120);
    self.label.frame=CGRectMake(0, self.bounds.size.height-110, self.bounds.size.width, 90);
    self.timeLabel.frame=CGRectMake(0, self.bounds.size.height-10, self.bounds.size.width, 10);
}


- (UIImageView *)imgView {
    if (!_imgView) {
        UIImageView *img = [[UIImageView alloc] init];
        [self addSubview:img];
        _imgView = img;
        img.clipsToBounds = YES;
    }
    return _imgView;
}

-(UILabel *)label
{
    if (!_label) {
        UILabel *label=[[UILabel alloc]init];
        [self addSubview:label];
        _label=label;
        _label.font=[UIFont systemFontOfSize:11];
        _label.numberOfLines=0;
        _label.backgroundColor=[UIColor whiteColor];
    }
    
    return _label;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel *timeLabel=[[UILabel alloc]init];
        [self addSubview:timeLabel];
        _timeLabel=timeLabel;
        _timeLabel.backgroundColor=[UIColor whiteColor];
        _timeLabel.font=[UIFont systemFontOfSize:9];
    }
    return _timeLabel;


}



@end
