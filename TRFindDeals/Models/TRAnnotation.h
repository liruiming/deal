//
//  TRAnnotation.h
//  TRFindDeals
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "TRDeal.h"
@interface TRAnnotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *dealUrlStr;
+ (TRAnnotation*)changeAnnotationClass:(id <MKAnnotation>)annotation;
@property (nonatomic, strong) TRDeal *deal;

@end
