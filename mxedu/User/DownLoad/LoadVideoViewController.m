//
//  LoadVideoViewController.m
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "LoadVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "JRPlayerViewController.h"
#import "SysCommon.h"

@implementation LoadVideoViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if(self.eSDMyLocalVideoCellOver == eAllinMyLocalVideoCellOver)
    {
        if(self.rootTable.editing)
        {
        
        }else
        {
        DownloadModal *modal = [self.videoArray objectAtIndex:indexPath.row];
        
        NSString* filePath = [modal stringDownloadPath];
        if ([filePath hasPrefix:@"/var"]) {
            NSRange range = [filePath rangeOfString:kVedioListPath];
            if (range.location != NSNotFound && range.length) {
                NSString* subPathString = [filePath substringFromIndex:range.location];
                filePath = [kDocPath stringByAppendingString:subPathString];
            }
        }
        else
        {
            
            filePath = [kDocPath stringByAppendingString:filePath];
        }
        if(self.eSDMyLocalVideoCellOver == eAllinMyLocalVideoCellOver)
        {
            NSString *urlString =[filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL fileURLWithPath:urlString isDirectory:NO];;
            JRPlayerViewController *playerVC = [[JRPlayerViewController alloc] initWithLocalMediaURL:url];
            playerVC.mediaTitle = modal.stringVideoName;
            if(_addHeadView){
                _addHeadView();
            }
            [self presentViewController:playerVC animated:YES completion:nil];
        }
    }
    }
}
@end
