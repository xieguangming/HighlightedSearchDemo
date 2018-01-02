//
//  UserModel.h
//  FamChat
//
//  Created by xgm on 17/9/5.
//  Copyright © 2017年 www.auratech.hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic, copy) NSString *name;         //昵称
@property (nonatomic, copy) NSString *accountNo;    //账户(唯一的)
@property (nonatomic,strong)NSData *imgData;      //头像
@property (nonatomic, strong)NSString *isOnLine;      //是否在线

@property (nonatomic, assign)BOOL isRepeat;

@end
