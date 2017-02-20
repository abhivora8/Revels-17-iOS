//
//  EasterEggViewController.h
//  Revels'17
//
//  Created by Abhishek Vora on 17/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PresentationType) {
    PresentationTypeXY,
    PresentationTypeYZ,
    PresentationTypeZX,
};

@interface EasterEggViewController : UIViewController

@property (nonatomic) PresentationType ptype;

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIImage *centerImage;

@property (nonatomic, strong) NSString *lugText;
@property (nonatomic, strong) NSString *manipalText;

@property (nonatomic, strong) NSString *quote;

@end
