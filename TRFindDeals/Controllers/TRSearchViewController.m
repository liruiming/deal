//
//  TRSearchViewController.m
//  TRFindDeals
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRSearchViewController.h"
#import "UIBarButtonItem+TRBarItem.h"
@interface TRSearchViewController ()<UISearchBarDelegate>

@end

@implementation TRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //item
    UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"icon_back" withHighLightedImage:@"icon_back_highlighted" withTarget:self withAction:@selector(clickBackItem)];
    //searchBar
    UISearchBar *bar = [UISearchBar new];
    bar.placeholder = @"请输入要搜索的关键字";
    bar.delegate = self;
    
    
    //添加
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationItem.titleView = bar;
    
    
    //设置View的颜色
    self.collectionView.backgroundColor = [UIColor whiteColor];
   
}
- (void)clickBackItem
{

    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - searchBarDelegate
//监听用户点击软键盘的搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
   //发送请求
    [self loadNewDeals];
   
    //键盘收回
    [self resignFirstResponder];
}

//实现父类声明的设置参数的方法
- (void)settingRequestParams:(NSMutableDictionary *)params
{
    //City
    params[@"city"] = self.cityName;
    
    //keyword
    UISearchBar *bar = (UISearchBar*)self.navigationItem.titleView;
    params[@"keyword"] = bar.text;


}


@end
