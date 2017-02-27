//
//  ResultsJSONModel.h
//  Revels'17
//
//  Created by Abhishek Vora on 27/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultsJSONModel : NSObject

@property (nonatomic) NSString *teamID;
@property (nonatomic) NSString *catID;
@property (nonatomic) NSString *eventID;
@property (nonatomic) NSString *round;
@property (nonatomic) NSString *pos;

-(instancetype)initWithData:(id)myData;
+(NSMutableArray *)getArrayFromJson:(id)myData;

@end
