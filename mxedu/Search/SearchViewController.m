//
//  SearchViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/10/20.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "SearchViewController.h"

#import "SysCommon.h"
#import "SearchTableCell.h"
#import "CourseManager.h"

#import "Keyword.h"
#import "SearchResultController.h"

@interface SearchViewController ()<UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate,KeywordCellDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataArray;
@property (nonatomic) UISearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self serupNav];
    
    UILabel *headerLabel = [[UILabel alloc]init];
    if (iPhone6Plus) {
        headerLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    }else if(iPhone6){
        headerLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    }else{
        headerLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    }
    headerLabel.text = @"热门搜索";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont systemFontOfSize:20.0];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.separatorStyle = NO;
    _tableView.tableHeaderView = headerLabel;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self setUpForDismissKeyboard];
 
}

-(void)viewWillAppear:(BOOL)animated{
    if ([_dataArray count]==0) {
        [self setupData];
    }
}

-(void)serupNav{
    self.title = @"搜索";
    _searchBar = [UISearchBar new];
    _searchBar.showsCancelButton = NO;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    _searchBar.barStyle = UIBarStyleBlackTranslucent;
    [_searchBar sizeToFit];
    self.navigationItem.titleView = _searchBar;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    SearchResultController *resultVC = [[SearchResultController alloc]init];
    resultVC.keyword = _searchBar.text;
    resultVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resultVC animated:YES];
}

/**
 *  获取推荐关键词
 */
-(void)setupData{
    CourseManager *cm = [[CourseManager alloc]init];
    [cm fetchKeywordListSuccess:^(KeywordListResult *result) {
        _dataArray = result.keywordList;
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableCell *cell = [[SearchTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchTableCell"];
    Keyword *key = [_dataArray objectAtIndex:indexPath.row];
    [cell setCellWithModel:key];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(iPhone6Plus) {
        return 45;
    }else if(iPhone6){
        return 40;
    }else{
        return 35;
    }
}

#pragma cell delegate

-(void)searchTableCell:(SearchTableCell *)cell didTapLabel:(NSString *)keyword{
    SearchResultController *resultVC = [[SearchResultController alloc]init];
    resultVC.keyword = keyword;
    resultVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resultVC animated:YES];
}

// 隐藏软键盘
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [_searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
