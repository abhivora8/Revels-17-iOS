//
//  WorkshopsModel.h
//  Revels'17
//
//  Created by Avikant Saini on 2/27/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkshopsModel : NSObject

@property (nonatomic) NSString *wid;
@property (nonatomic) NSString *wname;
@property (nonatomic) NSString *wcost;
@property (nonatomic) NSString *wdate;
@property (nonatomic) NSString *wshuru;		// lel
@property (nonatomic) NSString *wkhatam;	// lel
@property (nonatomic) NSString *wdesc;
@property (nonatomic) NSString *wvenue;
@property (nonatomic) NSString *cname;
@property (nonatomic) NSString *wnumb;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSArray <WorkshopsModel *> *)getAllWorkshopsFromJSONArray:(id)jsonArray;

@end
