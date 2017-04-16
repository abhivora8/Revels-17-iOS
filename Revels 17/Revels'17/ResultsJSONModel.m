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
    
    if (self) {
		@try {
            self.catID = [NSString stringWithFormat:@"%@", [myData objectForKey:@"cat"]];
            self.eventID = [NSString stringWithFormat:@"%@", [myData objectForKey:@"eve"]];
            self.round = [NSString stringWithFormat:@"%@", [myData objectForKey:@"round"]];
            self.pos = [NSString stringWithFormat:@"%@", [myData objectForKey:@"pos"]];
			self.eventName = [NSString stringWithFormat:@"%@", [myData objectForKey:@"evename"]];
            self.teamID = [NSString stringWithFormat:@"%@", [myData objectForKey:@"tid"]];
		} @catch (NSException *exception) {
			NSLog(@"Exc: %@", exception.reason);
		}
    }
    return self;
    
}

+ (NSMutableArray *)getArrayFromJson:(id)myData {
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dict in myData) {
        ResultsJSONModel *mod = [[ResultsJSONModel alloc] initWithData:dict];
        [array addObject:mod];
    }
	[array sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"catID" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"eventID" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"round" ascending:YES]]];
    return array;
}


@end
