//
//  TRDataManager.m
//  TRFindDeals
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRDataManager.h"
#import "TRDeal.h"
#import "TRSort.h"
#import "TRCategory.h"
#import "TRCity.h"
#import "TRRegion.h"
#import "TRCityGroup.h"
#import "TRBusiness.h"
@implementation TRDataManager

+ (NSArray *)parseDealsResult:(id)result {
    
    NSArray *dealsArray = result[@"deals"];
    //循环解析(Dictionary -> TRDeal)
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dealDic in dealsArray) {
        //声明空的模型对象
        TRDeal *deal = [TRDeal new];
        //KVC解析
        [deal setValuesForKeysWithDictionary:dealDic];
        [mutableArray addObject:deal];
    }
    
    return [mutableArray copy];
}

static NSArray *_sortsArray = nil;
+ (NSArray *)getAndParseSort {
    if (!_sortsArray) {
        //从sorts.plist读取;sortsArray[TRSort]
        _sortsArray = [[self alloc] getPlistData:@"sorts.plist" withClass:[TRSort class]];
    }
    return _sortsArray;
}

static NSArray *_categoryArray = nil;
+ (NSArray *)getAndParseCategory {
    if (!_categoryArray) {
        _categoryArray = [[self alloc] getPlistData:@"categories.plist" withClass:[TRCategory class]];
    }
    return  _categoryArray;
}

static NSArray *_cityArray = nil;
+ (NSArray *)getAndParseCity {
    if (!_cityArray) {
        _cityArray = [[self alloc] getPlistData:@"cities.plist" withClass:[TRCity class]];
    }
    return _cityArray;
}


static NSArray *_cityGroupArray = nil;
+ (NSArray *)getAndParseCityGroup {
    if (!_cityGroupArray) {
        _cityGroupArray = [[self alloc] getPlistData:@"cityGroups.plist" withClass:[TRCityGroup class]];
    }
    return _cityGroupArray;
}




+ (NSArray *)getAndParseBusiness:(TRDeal *)deal
{
//dic --> TRBusiness
    NSArray *businessArr = deal.businesses;
    NSMutableArray *marr = [NSMutableArray array];
    for (NSDictionary *dic in businessArr)
    {
        TRBusiness *business = [TRBusiness new];
        [business setValuesForKeysWithDictionary:dic];
        [marr addObject:business];
        
    }


    return [marr copy];
}

+ (TRCategory *)getCategoryWithDeal:(TRDeal *)deal
{
    //获取订单所属的分类数组
    NSArray *categoryArr = deal.categories;
   
    //获取整个分类的数据
    NSArray *categoryArrayFromPlist = [self getAndParseCategory];
    
    //订单所属的分类数组
    for (NSString *categoryStr in categoryArr) {
        //分类plist
        for (TRCategory *category in categoryArrayFromPlist) {
            //从主分类找
            if ([category.name isEqualToString:categoryStr])
            {
                return category;
            }
         
           //从子分类找(如果数组中含有categoryStr)
            if ([category.subcategories containsObject:categoryStr]) {
                
                return category;
                
            }
        }
    }
//没有找到分类
    return nil;

}

- (NSArray *)getPlistData:(NSString *)plistName withClass:(Class)modelClass {
    //从plistName中读取数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
    //array[Dic, Dic....]
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    //循环转换:Dictionary -> modelClass
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        //创建modelClass对象
        id modelInstance = [[modelClass alloc] init];
        [modelInstance setValuesForKeysWithDictionary:dic];
        [mutableArray addObject:modelInstance];
    }
    return [mutableArray copy];
}


+ (NSArray *)getRegionsByCityName:(NSString *)cityName {
    //获取整个城市数组(TRCity)
    NSArray *cityArray = [self getAndParseCity];
    //找寻cityName对应的item
    TRCity *findedCity = [TRCity new];
    for (TRCity *city in cityArray) {
        if ([city.name isEqualToString:cityName]) {
            findedCity = city;
            break;
        }
    }
    //[regionDic...] -> [TRRegion...]
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *regionDic in findedCity.regions) {
        TRRegion *region = [TRRegion new];
        [region setValuesForKeysWithDictionary:regionDic];
        [mutableArray addObject:region];
    }
    return [mutableArray copy];
}

@end
