//
//  MemberViewCell.h
//  FamChat
//
//  Created by xgm on 17/9/5.
//  Copyright © 2017年 www.auratech.hk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong)  UIImageView *iconImageView;

+ (CGFloat)fixedHeight;

@end
