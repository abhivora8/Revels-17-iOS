//
//  CoreDataHelper.h
//  Revels'17
//
//  Created by Avikant Saini on 2/26/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CategoryStore+CoreDataClass.h"
#import "EventStore+CoreDataClass.h"
#import "ScheduleStore+CoreDataClass.h"

#import "CategoriesJSONModel.h"
#import "EventsDetailsJSONModel.h"

@interface CoreDataHelper : NSObject

+ (CategoryStore *)createNewCategoryWithDict:(NSDictionary *)dict inEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray <CategoryStore *> *)getCategoriesFromJSONData:(id)data storeIntoManagedObjectContext:(NSManagedObjectContext *)context;

// -------

+ (EventStore *)createNewEventWithDict:(NSDictionary *)dict inEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray <EventStore *> *)getEventsFromJSONData:(id)data storeIntoManagedObjectContext:(NSManagedObjectContext *)context;


// ------

+ (ScheduleStore *)createNewScheduleWithDict:(NSDictionary *)dict inEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray <ScheduleStore *> *)getScheduleFromJSONData:(id)data storeIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end
