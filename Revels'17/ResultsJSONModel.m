//
//  ResultsJSONModel.m
//  Revels'17
//
//  Created by Abhishek Vora on 27/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "ResultsJSONModel.h"

@implementation ResultsJSONModel

-(instancetype)initWithData:(id)myData;
{
    self = [super init];
    
    if(self) {
        if (myData && [myData isKindOfClass:[NSDictionary class]]) {
            self.catID = [myData objectForKey:@"cat"];
            self.eventID = [myData objectForKey:@"eve"];
            self.round = [myData objectForKey:@"round"];
            self.pos = [myData objectForKey:@"pos"];
            self.teamID = [myData objectForKey:@"tid"];
        }
    }
    return self;
    
}

+(NSMutableArray *)getArrayFromJson:(id)myData
{
    NSMutableArray *array = [NSMutableArray new];
    for(NSDictionary *dict in myData)
    {
        ResultsJSONModel *mod = [[ResultsJSONModel alloc] initWithData:dict];
        [array addObject:mod];
    }
    return array;
}


@end
