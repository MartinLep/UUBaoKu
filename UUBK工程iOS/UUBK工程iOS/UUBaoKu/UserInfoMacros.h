//
//  UserInfoMacros.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#ifndef UserInfoMacros_h
#define UserInfoMacros_h

//是不是分销商
#define IS_DISTRIBUTOR [[NSUserDefaults standardUserDefaults]boolForKey:@"IsDistributor"]

//个人userid
#define gerenUserId [[NSUserDefaults standardUserDefaults]objectForKey:@"UserID"]
//个人名称(目前还没有用到)
#define gerenName [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"]

//个人名称（个人的昵称）
#define gerenNickName [[NSUserDefaults standardUserDefaults]objectForKey:@"NickName"]

#define selfParentID [[NSUserDefaults standardUserDefaults]objectForKey:@"ParentID"]

//个人电话号码 （登陆账号）
#define gerenMobile [[NSUserDefaults standardUserDefaults]objectForKey:@"Mobile"]
//个人密码（MD5）
#define gerenLoginPwd [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginPwd"]

//个人头像 地址
#define gerenfaceimage [[NSUserDefaults standardUserDefaults]objectForKey:@"FaceImg"]
//个人分销商等级名称
#define gerenDistributorDegreeName [[NSUserDefaults standardUserDefaults]objectForKey:@"DistributorDegreeName"]
//个人供货等级名称
#define gerenSupplierDegreeName [[NSUserDefaults standardUserDefaults]objectForKey:@"SupplierDegreeName"]
//可用囤货金
#define gerenBalance [[NSUserDefaults standardUserDefaults]objectForKey:@"Balance"]

//可用库币
#define gerenIntegral [[NSUserDefaults standardUserDefaults]objectForKey:@"Integral"]

#endif /* UserInfoMacros_h */
