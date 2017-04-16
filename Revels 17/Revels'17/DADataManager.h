//
//  DADataManager.h
//  Revels'17
//
//  Created by Abhishek Vora on 17/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DADataManager : NSObject

- (NSString *)documentsPathForFileName:(NSString *)name;
- (NSString *)imagesPathForFileName:(NSString *)name;

- (BOOL)saveData:(NSData *)data toDocumentsFile:(NSString *)name;
- (BOOL)saveObject:(id)object toDocumentsFile:(NSString *)name;
- (BOOL)fileExistsInDocuments:(NSString *)name;
- (id)fetchJSONFromDocumentsFileName:(NSString *)name;

+ (DADataManager *)sharedManager;


@end
