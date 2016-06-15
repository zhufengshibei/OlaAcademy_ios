//
//  SearchTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 15/10/20.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keyword.h"

@class SearchTableCell;

@protocol KeywordCellDelegate <NSObject>

- (void)searchTableCell:(SearchTableCell *)cell didTapLabel:(NSString *)keyword;

@end


@interface SearchTableCell : UITableViewCell

@property (nonatomic) id<KeywordCellDelegate> delegate;

@property (nonatomic) UILabel *nameLabel;

-(void)setCellWithModel:(Keyword*)keyword;

@end
