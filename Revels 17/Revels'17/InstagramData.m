//
//  InstagramData.m
//  Revels'17
//
//  Created by Abhishek Vora on 21/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "InstagramData.h"

@implementation InstagramData

- (instancetype)initWithData:(id)data {
    
    self = [super init];
    
    if (self) {
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            
            @try {
                
                self.type = [NSString stringWithFormat:@"%@", [data valueForKeyPath:@"type"]];
                
                self.instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [data valueForKeyPath:@"link"]]];
                
                self.filterName = [data valueForKeyPath:@"filter"];
                
                NSArray *tagArray = [data valueForKey:@"tags"];
                self.tags = [tagArray componentsJoinedByString:@" | "];
                
                self.commentsCount = [[data valueForKeyPath:@"comments.count"] integerValue];
                
                self.likesCount = [[data valueForKeyPath:@"likes.count"] integerValue];
                
                self.thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [data valueForKeyPath:@"images.thumbnail.url"]]];
                self.lowResURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [data valueForKeyPath:@"images.low_resolution.url"]]];
                self.highResURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [data valueForKeyPath:@"images.standard_resolution.url"]]];
                
                self.captionText = [NSString stringWithFormat:@"%@", [data valueForKeyPath:@"caption.text"]];
                
                self.username = [NSString stringWithFormat:@"%@", [data valueForKeyPath:@"user.username"]];
                self.userProfileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [data valueForKeyPath:@"user.profile_picture"]]];
                
            }
            @catch (NSException *exception) {
                NSLog(@"Parsing exc: %@", exception.reason);
            }
            
        }
        
    }
    
    return self;
}


+ (NSMutableArray *)getArrayFromJSONData:(id)data {
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSDictionary *dict in data) {
        InstagramData *igdata = [[InstagramData alloc] initWithData:dict];
        [array addObject:igdata];
    }
    
    return array;
}

@end
