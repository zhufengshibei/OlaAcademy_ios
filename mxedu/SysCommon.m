//
//  SysCommon.m
//  NTreat
//
//  Created by 田晓鹏 on 15-4-24.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//


#import "SysCommon.h"

@implementation SysCommon

AppDelegate* GetAppDelegate()
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

DataMappingManager* GetDataManager()
{
    AppDelegate* appDelegate = GetAppDelegate();
    return appDelegate.dataManager;
}



@end
