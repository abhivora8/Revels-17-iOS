//
//  RegisterWebViewController.h
//  Revels'17
//
//  Created by Abhishek Vora on 18/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface RegisterWebViewController : UIViewController

@property (nonatomic, strong) NSURL *passedURL;
@property (nonatomic, strong) NSString *passedTitle;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backwardBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forewardBackButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadBarButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@end

