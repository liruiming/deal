//
//  MKAnnotationViewController.m
//  TRFindDeals
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "MKAnnotationViewController.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"
@interface MKAnnotationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
@property (weak, nonatomic) IBOutlet UILabel *dealTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *dealDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentListLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;

@end

@implementation MKAnnotationViewController

- (IBAction)selectedDeal:(id)sender {
    WebViewController *wvc = [WebViewController new];
     wvc.request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:wvc];
    [self presentViewController:navi animated:YES completion:nil];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(340, 250);
    
    
    self.dealTitleLabel.text = self.deal.title;
    self.dealDescLabel.text = self.deal.desc;
    self.currentListLabel.text = [NSString stringWithFormat:@"¥:%@",self.deal.current_price] ;
    //获取小数点位置
    NSInteger dotLocation = [self.currentListLabel.text rangeOfString:@"."].location;
    if (dotLocation != NSNotFound)
    {
        
        // 超过保存小数点后两位
        if (self.currentListLabel.text.length - dotLocation > 3)
        {
            self.currentListLabel.text = [self.currentListLabel.text substringToIndex:dotLocation + 3];
        }
        
    }

    self.listPriceLabel.text = [NSString stringWithFormat:@"%@", self.deal.list_price];
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售:%@",self.deal.purchase_count];
    [self.dealImageView sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
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
