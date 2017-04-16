//
//  WorkshopsModel.m
//  Revels'17
//
//  Created by Avikant Saini on 2/27/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "WorkshopsModel.h"

@implementation WorkshopsModel

- (instancetype)initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		@try {
			self.wid = [dict objectForKey:@"wid"];
			self.wname = [dict objectForKey:@"wname"];
			self.wcost = [dict objectForKey:@"wcost"];
			self.wdate = [dict objectForKey:@"wdate"];
			self.wshuru = [dict objectForKey:@"wshuru"];
			self.wkhatam = [dict objectForKey:@"wkhatam"];
			self.wdesc = [dict objectForKey:@"wdesc"];
			self.wvenue = [dict objectForKey:@"wvenue"];
			self.wnumb = [dict objectForKey:@"wnumb"];
			self.cname = [dict objectForKey:@"cname"];
		} @catch (NSException *exception) {
			NSLog(@"Exception: %@", exception.reason);
		}
	}
	return self;
}

+ (NSArray<WorkshopsModel *> *)getAllWorkshopsFromJSONArray:(id)jsonArray {
	NSMutableArray <WorkshopsModel *> *res = [NSMutableArray new];
	for (NSDictionary *dict in jsonArray) {
		WorkshopsModel *model = [[WorkshopsModel alloc] initWithDict:dict];
		[res addObject:model];
	}
	[res sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"wdate" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"wname" ascending:YES]]];
	return res;
}

@end
