//
//  EventsDetailsJSONModel.h
//  Revels'17
//
//  Created by Abhishek Vora on 22/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsDetailsJSONModel : NSObject

@property (strong,nonatomic) NSString *eventName;
@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) NSString *eventMaxTeamSize;
@property (strong, nonatomic) NSString *categoryEventId;
@property (strong, nonatomic) NSString *categoryEventName;
@property (strong, nonatomic) NSString *cntctname;
@property (strong, nonatomic) NSString *cntctno;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *hs;
@property (strong, nonatomic) NSString *day;

-(instancetype)initWithData:(id)myData;
+(NSMutableArray *)getArrayFromJson:(id)myData;

@end
