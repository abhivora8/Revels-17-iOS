//
//  CategoriesJSONModel.h
//  Revels'17
//
//  Created by Abhishek Vora on 22/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoriesJSONModel : NSObject

@property (strong,nonatomic) NSString *catId;
@property (strong,nonatomic) NSString *catName;
@property (strong,nonatomic) NSString *catDesc;

-(instancetype)initWithData:(id)data;
+(NSMutableArray *)getArrayFromJson:(id)myData;

@end
