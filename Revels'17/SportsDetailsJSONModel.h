//
//  SportsDetailsJSONModel.h
//  Revels'17
//
//  Created by Abhishek Vora on 28/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportsDetailsJSONModel : NSObject

@property (nonatomic) NSString *teamID;
@property (nonatomic) NSString *eventName;
@property (nonatomic) NSString *round;
@property (nonatomic) NSString *pos;
@property (nonatomic) NSString *teamSize;
@property (nonatomic) NSString *day;

-(instancetype)initWithData:(id)myData;
+(NSMutableArray *)getArrayFromJson:(id)myData;

@end
