//
//  MemberViewCell.m
//  FamChat
//
//  Created by xgm on 17/9/5.
//  Copyright © 2017年 www.auratech.hk. All rights reserved.
//

#import "MemberViewCell.h"
#import "UIView+SDAutoLayout.h"
#define Width  [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height


@implementation MemberViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       // self.contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        [self setupView];
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    frame.size.width = Width;
    [super setFrame:frame];
}

- (void)setupView
{
    _iconImageView = [[UIImageView alloc]init];
    [_iconImageView.layer setMasksToBounds:YES];
    _iconImageView.layer.cornerRadius = 18.0;
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
    
    CGFloat margin = 8;
    
    
    _iconImageView.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .widthIs(36)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconImageView, margin)
    .centerYEqualToView(_iconImageView)
    .rightSpaceToView(self.contentView, margin)
    .heightIs(30);
    
}

//-(void)setModel:(UserModel *)model
//{
//    _model = model;
//    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
//    _nameLabel.textColor = [UIColor  blackColor];
//}

+ (CGFloat)fixedHeight
{
    return 50;
}

@end
