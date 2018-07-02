//
//  SearchViewController.m
//  HQZSearch
//
//  Created by huangqizai on 2018/7/2.
//  Copyright © 2018年 FYCK. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate>

//搜索框
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.title = @"搜索框";
    
    [self initTableView];
    [self configureSearchController];
}

- (void)initTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SearchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
    return cell;
}

#pragma mark 设置搜索框
- (void)configureSearchController
{
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.placeholder = @"搜索任务";
    _searchController.definesPresentationContext = YES;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        _searchController.searchBar.tintColor = [UIColor whiteColor];
        _searchController.searchBar.barTintColor = [UIColor whiteColor];
        
        UITextField *searchBarTextField = [self.searchController.searchBar valueForKey:@"searchField"];
        searchBarTextField.textColor = [UIColor grayColor];
        searchBarTextField.tintColor = [UIColor lightGrayColor];
        
        UIView *backgroundview = [searchBarTextField.subviews firstObject];
        backgroundview.backgroundColor = [UIColor whiteColor];
        backgroundview.layer.cornerRadius = 10;
        backgroundview.clipsToBounds = true;
        
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
//                                                     forBarPosition:UIBarPositionAny
//                                                         barMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        
        //向上滑动Scroll，隐藏搜索栏
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationItem.searchController = _searchController;
        
    } else {
        [[UISearchBar appearance] setBackgroundImage:[self imageWithColor:[UIColor clearColor] size:_searchController.searchBar.bounds.size]];
        _searchController.searchBar.backgroundColor = [UIColor whiteColor];//选中后搜索框周边颜色
        _searchController.searchBar.backgroundImage = [self imageWithColor:[UIColor whiteColor] size:_searchController.searchBar.bounds.size];//没选择，搜索框周边颜色
//        _searchController.searchBar.tintColor = KColorBlue;
        _searchController.hidesNavigationBarDuringPresentation = NO;//不让searchControlle移动
        [self.view addSubview:_searchController.searchBar];
        
        for (UIView *subView in _searchController.searchBar.subviews)
        {
            for (UIView *secondLevelSubview in subView.subviews){
                if ([secondLevelSubview isKindOfClass:[UITextField class]]){
                    UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
//                    searchBarTextField.backgroundColor = KColorBackground;//搜索框颜色
//                    searchBarTextField.textColor = [UIColor colorWithHexString:@"333333"];//搜索框字的颜色
                    break;
                }
            }
        }
    }
}

#pragma mark 取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (@available(iOS 11.0, *)) {
    } else {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
        line.tag = 10;
        line.backgroundColor = [UIColor whiteColor];
        [self.searchController.searchBar addSubview:line];
    }
    
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTintColor:[UIColor grayColor]];
//            cancel.titleLabel.font = [UIFont fontWithName:KFontNormal size:16];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchController dismissViewControllerAnimated:YES completion:^{
        if (@available(iOS 11.0, *)) {
        } else {
            UIView *line = [self.searchController.searchBar viewWithTag:10];
            [line removeFromSuperview];
        }
//        self.accurate_taskName = nil;
//        [self getDataSource];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchController.searchBar resignFirstResponder];
//    self.accurate_taskName = self.searchController.searchBar.text;
//    self.dim_taskName = self.searchController.searchBar.text;
//    self.taskTime = nil;
//    [self getDataSource];
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController
{
    if (@available(iOS 11.0, *)) {
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self changeSearchBarColor];
        });
    }
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    if (@available(iOS 11.0, *)) {
    } else {
        [self changeSearchBarColor];
    }
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    if (@available(iOS 11.0, *)) {
    }
}

- (void)changeSearchBarColor
{
    for (UIView *view in _searchController.searchBar.subviews) {
        for (UIView *subview in view.subviews) {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UISearchBarBackground"]) {
                [subview removeFromSuperview];
            }
        }
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
