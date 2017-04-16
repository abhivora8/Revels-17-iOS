//
//  ASMutableURLRequest.m
//  Revels'17
//
//  Created by Abhishek Vora on 17/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "ASMutableURLRequest.h"

@implementation ASMutableURLRequest

+ (instancetype)requestWithURL:(NSURL *)URL {
    ASMutableURLRequest *request = [super requestWithURL:URL];
    return request;
}

+ (instancetype)getRequestWithURL:(NSURL *)URL {
    ASMutableURLRequest *request = [ASMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    return request;
}

+ (instancetype)postRequestWithURL:(NSURL *)URL {
    ASMutableURLRequest *request = [ASMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    return request;
}

+ (instancetype)putRequestWithURL:(NSURL *)URL {
    ASMutableURLRequest *request = [ASMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"PUT"];
    return request;
}

+ (instancetype)deleteRequestWithURL:(NSURL *)URL {
    ASMutableURLRequest *request = [ASMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"DELETE"];
    return request;
}

@end
