//
//  ASMutableURLRequest.h
//  Revels'17
//
//  Created by Abhishek Vora on 17/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASMutableURLRequest : NSMutableURLRequest

+ (instancetype)getRequestWithURL:(NSURL *)URL;
+ (instancetype)postRequestWithURL:(NSURL *)URL;
+ (instancetype)putRequestWithURL:(NSURL *)URL;
+ (instancetype)deleteRequestWithURL:(NSURL *)URL;

@end
