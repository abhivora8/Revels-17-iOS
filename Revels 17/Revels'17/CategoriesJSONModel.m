//
//  CategoriesJSONModel.m
//  Revels'17
//
//  Created by Abhishek Vora on 22/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "CategoriesJSONModel.h"

@implementation CategoriesJSONModel

-(instancetype)initWithData:(id)myData
{
    self = [super init];
    
    if(self) {
        if (myData && [myData isKindOfClass:[NSDictionary class]]) {
            self.catId = [myData objectForKey:@"cid"];
            self.catName = [myData objectForKey:@"cname"];
            self.catDesc = [myData objectForKey:@"cdesc"];
        }
    }
    return self;
}

+ (NSMutableArray *)getArrayFromJson:(id)myData
{
    NSMutableArray *array = [NSMutableArray new];
    for(NSDictionary *dict in myData)
    {
        CategoriesJSONModel *mod = [[CategoriesJSONModel alloc] initWithData:dict];
        [array addObject:mod];
    }
    return array;
}

@end

