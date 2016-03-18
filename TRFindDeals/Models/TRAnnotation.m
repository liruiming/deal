
//
//  TRAnnotation.m
//  TRFindDeals
//
//  Created by apple on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRAnnotation.h"

@implementation TRAnnotation
+ (TRAnnotation *)changeAnnotationClass:(id<MKAnnotation>)annotation
{
    TRAnnotation *anno = (TRAnnotation*)annotation;

    return anno;
}
@end
