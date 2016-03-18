//
//  TRCollectionViewCell.m
//  TRFindDeals
//
//  Created by tarena on 15/12/21.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@interface TRCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
@property (weak, nonatomic) IBOutlet UILabel *dealTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentListLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;




@end


@implementation TRCollectionViewCell
- (void)setDeal:(TRDeal *)deal
{
    //背景图片
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
    
    
    _deal = deal;
    self.dealTitleLabel.text = deal.title;
     self.dealDescLabel.text =  deal.desc;
     self.currentListLabel.text = [NSString stringWithFormat:@"¥:%@",deal.current_price] ;
    //处理 89.0000001->89.90(小数点后保留两位)
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
    
    self.listPriceLabel.text = [NSString stringWithFormat:@"%@", deal.list_price];
     self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售:%@",deal.purchase_count];
    [self.dealImageView sd_setImageWithURL:[NSURL URLWithString:_deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
   
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

@end
