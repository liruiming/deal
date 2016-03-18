//
//  WebViewController.m
//  TRFindDeals
//
//  Created by apple on 15/12/21.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "WebViewController.h"
#import "TRDeal.h"
@interface WebViewController ()


@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(aaa)];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.title = @"订单详情";
    NSURLRequest *request = self.request;
[self.webView loadRequest:request];
}
- (void)aaa
{
    [self dismissViewControllerAnimated:YES completion:nil];

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
