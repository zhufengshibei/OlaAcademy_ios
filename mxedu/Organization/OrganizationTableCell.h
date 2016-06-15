//
//  OrganizationTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 15/10/19.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Organization.h"

@protocol OrgizationCellDelegate <NSObject>

- (void)cell:(Organization*)org local:(NSIndexPath*)localPath didTapButton:(UIButton *)button;
- (void)showLoginView;

@end

@interface OrganizationTableCell : UITableViewCell

@property (nonatomic) id<OrgizationCellDelegate> delegate;

@property (nonatomic) NSIndexPath *indexPath;
-(void)setCellWithModel:(Organization*)org Path:(NSIndexPath*)indexPath;

@end
