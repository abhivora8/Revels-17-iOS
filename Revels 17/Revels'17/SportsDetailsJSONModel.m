//
//  SportsDetailsJSONModel.m
//  Revels'17
//
//  Created by Abhishek Vora on 28/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "SportsDetailsJSONModel.h"

@implementation SportsDetailsJSONModel

-(instancetype)initWithData:(id)myData;
{
    self = [super init];
    
    if(self) {
        if (myData && [myData isKindOfClass:[NSDictionary class]]) {
            self.teamID = [myData objectForKey:@"teamid"];
			self.catID = [myData objectForKey:@"catid"];
			self.eventID = [myData objectForKey:@"eveid"];
            self.eventName = [myData objectForKey:@"evename"];
            self.round = [myData objectForKey:@"roundno"];
            self.pos = [myData objectForKey:@"position"];
            self.day = [myData objectForKey:@"day"];
            self.teamSize = [myData objectForKey:@"teamsize"];
        }
    }
    return self;
    
}

+(NSMutableArray *)getArrayFromJson:(id)myData
{
    NSMutableArray *array = [NSMutableArray new];
    for(NSDictionary *dict in myData)
    {
        SportsDetailsJSONModel *mod = [[SportsDetailsJSONModel alloc] initWithData:dict];
        [array addObject:mod];
    }
	[array sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"catID" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"eventID" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"round" ascending:YES]]];
    return array;
}


@end
