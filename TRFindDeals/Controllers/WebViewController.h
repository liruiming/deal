//
//  WebViewController.h
//  TRFindDeals
//
//  Created by apple on 15/12/21.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong)NSURLRequest *request;
@end
