//
//  EventsDetailsJSONModel.m
//  Revels'17
//
//  Created by Abhishek Vora on 22/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "EventsDetailsJSONModel.h"

@implementation EventsDetailsJSONModel

-(instancetype)initWithData:(id)myData;
{
    self = [super init];
    
    if(self) {
        if (myData && [myData isKindOfClass:[NSDictionary class]]) {
            self.eventName = [myData objectForKey:@"ename"];
            self.eventId = [myData objectForKey:@"eid"];
            self.eventDescription = [myData objectForKey:@"edesc"];
            self.eventMaxTeamSize = [myData objectForKey:@"emaxteamsize"];
            self.categoryEventId = [myData objectForKey:@"cid"];
            self.categoryEventName = [myData objectForKey:@"cname"];
            self.cntctname = [myData objectForKey:@"cntctname"];
            self.cntctno = [myData objectForKey:@"cntctno"];
            self.hs = [myData objectForKey:@"hash"];
            self.type = [myData objectForKey:@"type"];
            self.day = [myData objectForKey:@"day"];
        }
    }
    return self;
    
}

+(NSMutableArray *)getArrayFromJson:(id)myData
{
    NSMutableArray *array = [NSMutableArray new];
    for(NSDictionary *dict in myData)
    {
        EventsDetailsJSONModel *mod = [[EventsDetailsJSONModel alloc] initWithData:dict];
        [array addObject:mod];
    }
    return array;
}


@end
