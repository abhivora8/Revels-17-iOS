//
//  CoreDataHelper.m
//  Revels'17
//
//  Created by Avikant Saini on 2/26/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

+ (CategoryStore *)createNewCategoryWithDict:(NSDictionary *)dict inEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	CategoryStore *category = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryStore" inManagedObjectContext:context];
	
	if (dict != nil) {
		
		@try {
			category.catID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cid"]];
			category.catName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cname"]];
			category.catDesc = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cdesc"]];
		} @catch (NSException *exception) {
			NSLog(@"Exception: %@", exception.reason);
		}
		
	}
	
	return category;
	
}

+ (NSMutableArray<CategoryStore *> *)getCategoriesFromJSONData:(id)data storeIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	NSMutableArray <CategoryStore *> *categories = [NSMutableArray new];
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CategoryStore"];
	[request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"catName" ascending:YES]]];
	NSError *error;
	NSArray *fetchedCats = [context executeFetchRequest:request error:&error];
	if (error) {
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	}
	
	for (NSDictionary *dict in data) {
		
		NSString *identifier;
		
		@try {
			identifier = [dict objectForKey:@"cid"];
		} @catch (NSException *exception) {
			NSLog(@"Exception: %@", exception.description);
			continue;
			
		}
		CategoryStore *category = [[fetchedCats filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@", identifier]] firstObject];
		
		if (category != nil ) {
			// Update existing
			
			NSLog(@"Updating existsing %@", identifier);
			
			@try {
				
				category.catName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cname"]];
				category.catDesc = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cdesc"]];
				
			}
			@catch (NSException *exception) {
				NSLog(@"Exception: %@", exception.description);
			}
			
		} else {
			// Insert
			
			NSLog(@"Insering new %@", identifier);
			
			[CoreDataHelper createNewCategoryWithDict:dict inEntity:[NSEntityDescription entityForName:@"CategoryStore" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
			
		}
		
	}
	
	categories = [[context executeFetchRequest:request error:&error] mutableCopy];
	if (error) {
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	}
	
	return categories;
	
}


// ---------

+ (EventStore *)createNewEventWithDict:(NSDictionary *)dict inEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	EventStore *event = [NSEntityDescription insertNewObjectForEntityForName:@"EventStore" inManagedObjectContext:context];
	
	if (dict != nil) {
		
		@try {
			event.eventName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"ename"]];
			event.eventID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"eid"]];
			event.eventDesc = [NSString stringWithFormat:@"%@", [dict objectForKey:@"edesc"]];
			event.eventMaxTeamSize = [NSString stringWithFormat:@"%@", [dict objectForKey:@"emaxteamsize"]];
			event.catID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cid"]];
			event.catName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cname"]];
			event.contactName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cntctname"]];
			event.contactNumber = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cntctno"]];
			event.hashtag = [NSString stringWithFormat:@"%@", [dict objectForKey:@"hash"]];
			event.type = [NSString stringWithFormat:@"%@", [dict objectForKey:@"type"]];
			event.day = [NSString stringWithFormat:@"%@", [dict objectForKey:@"day"]];
			event.isFavorite = NO;

		} @catch (NSException *exception) {
			NSLog(@"Exception: %@", exception.reason);
		}
		
	}
	
	return event;
	
}

+ (NSMutableArray<EventStore *> *)getEventsFromJSONData:(id)data storeIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	NSMutableArray <EventStore *> *events = [NSMutableArray new];
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"EventStore"];
	[request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"catName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"eventName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES]]];
	NSError *error;
	NSArray *fetchedEvents = [context executeFetchRequest:request error:&error];
	if (error) {
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	}
	
	for (NSDictionary *dict in data) {
		
		NSString *catID, *eventID;
		
		@try {
			catID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cid"]];
			eventID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"eid"]];
		} @catch (NSException *exception) {
			NSLog(@"Exception: %@", exception.description);
			continue;
			
		}
		EventStore *event = [[fetchedEvents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@", catID, eventID]] firstObject];
		
		if (event != nil ) {
			// Update existing
			
			NSLog(@"Updating existsing %@ - %@", catID, eventID);
			
			@try {
				
				event.eventName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"ename"]];
				event.eventDesc = [NSString stringWithFormat:@"%@", [dict objectForKey:@"edesc"]];
				event.eventMaxTeamSize = [NSString stringWithFormat:@"%@", [dict objectForKey:@"emaxteamsize"]];
				event.catName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cname"]];
				event.contactName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cntctname"]];
				event.contactNumber = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cntctno"]];
				event.hashtag = [NSString stringWithFormat:@"%@", [dict objectForKey:@"hash"]];
				event.type = [NSString stringWithFormat:@"%@", [dict objectForKey:@"type"]];
				event.day = [NSString stringWithFormat:@"%@", [dict objectForKey:@"day"]];
				
			}
			@catch (NSException *exception) {
				NSLog(@"Exception: %@", exception.description);
			}
			
		} else {
			// Insert
			
			NSLog(@"Inserting new %@ - %@", catID, eventID);
			
			[CoreDataHelper createNewEventWithDict:dict inEntity:[NSEntityDescription entityForName:@"EventStore" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
			
		}
		
	}
	
	events = [[context executeFetchRequest:request error:&error] mutableCopy];
	if (error) {
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	}
	
	return events;
	
}

// --------

+ (ScheduleStore *)createNewScheduleWithDict:(NSDictionary *)dict inEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	ScheduleStore *schedule = [NSEntityDescription insertNewObjectForEntityForName:@"ScheduleStore" inManagedObjectContext:context];
	
	if (dict != nil) {
		
		@try {
			schedule.eventID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"eid"]];
			schedule.catID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"catid"]];
			schedule.day = [NSString stringWithFormat:@"%@", [dict objectForKey:@"day"]];
			schedule.stime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"stime"]];
			schedule.etime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"etime"]];
			schedule.venue = [NSString stringWithFormat:@"%@", [dict objectForKey:@"venue"]];
			schedule.round = [NSString stringWithFormat:@"%@", [dict objectForKey:@"round"]];
			schedule.date = [NSString stringWithFormat:@"%@", [dict objectForKey:@"date"]];
			
		} @catch (NSException *exception) {
			NSLog(@"Exception: %@", exception.reason);
		}
		
	}
	
	return schedule;
	
}

+ (NSMutableArray<ScheduleStore *> *)getScheduleFromJSONData:(id)data storeIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	NSMutableArray <ScheduleStore *> *events = [NSMutableArray new];
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ScheduleStore"];
	[request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"eventID" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"stime" ascending:YES]]];
	NSError *error;
	NSArray *fetchedSchedule = [context executeFetchRequest:request error:&error];
	if (error) {
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	}
	
	for (NSDictionary *dict in data) {
		
		NSString *catID, *eventID, *round, *date;
		
		@try {
			catID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"catid"]];
			eventID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"eid"]];
			round = [NSString stringWithFormat:@"%@", [dict objectForKey:@"round"]];
			date = [NSString stringWithFormat:@"%@", [dict objectForKey:@"date"]];
		} @catch (NSException *exception) {
			NSLog(@"Exception: %@", exception.description);
			continue;
			
		}
		ScheduleStore *schedule = [[fetchedSchedule filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"catID == %@ AND eventID == %@ AND round == %@ AND date == %@", catID, eventID, round, date]] firstObject];
		
		if (schedule != nil ) {
			// Update existing
			
			NSLog(@"Updating existsing %@, %@, %@, %@", catID, eventID, round, schedule.day);
			
			@try {
				
				schedule.stime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"stime"]];
				schedule.etime = [NSString stringWithFormat:@"%@", [dict objectForKey:@"etime"]];
				schedule.venue = [NSString stringWithFormat:@"%@", [dict objectForKey:@"venue"]];
				schedule.day = [NSString stringWithFormat:@"%@", [dict objectForKey:@"day"]];
			}
			@catch (NSException *exception) {
				NSLog(@"Exception: %@", exception.description);
			}
			
		} else {
			// Insert
			
			NSLog(@"Inserting new %@, %@, %@", catID, eventID, round);
			
			[CoreDataHelper createNewScheduleWithDict:dict inEntity:[NSEntityDescription entityForName:@"ScheduleStore" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
			
		}
		
	}
	
	events = [[context executeFetchRequest:request error:&error] mutableCopy];
	if (error) {
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	}
	
	return events;
	
}

@end
