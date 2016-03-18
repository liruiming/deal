//
//  TRBaseCollectionViewController.h
//  TRFindDeals
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRBaseCollectionViewController : UICollectionViewController

//由父类来声明/调用,子类来实现
- (void)settingRequestParams:(NSMutableDictionary*)params;

//由子类调用,父类来实现
- (void)loadNewDeals;
@end
