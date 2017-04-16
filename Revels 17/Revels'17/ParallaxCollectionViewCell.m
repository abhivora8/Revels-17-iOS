//
//  ParallaxCollectionViewCell.m
//  Revels'17
//
//  Created by Abhishek Vora on 21/02/17.
//  Copyright © 2017 Abhishek Vora. All rights reserved.
//

#import "ParallaxCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ParallaxCollectionViewCell()

@property (nonatomic, strong, readwrite) UIImageView *parallaxImageView;

@end

@implementation ParallaxCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
        [self setupImageView];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
        [self setupImageView];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!self.parallaxImageView)
        [self setupImageView];
}

- (void)setupImageView {
    self.clipsToBounds = YES;
    self.parallaxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x - 4, self.frame.origin.y - 4, self.frame.size.width + 24, IMAGE_HEIGHT + 24)];
    self.parallaxImageView.backgroundColor = [UIColor clearColor];
    self.parallaxImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.parallaxImageView.clipsToBounds = NO;
    [self insertSubview:self.parallaxImageView atIndex:0];
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    [self.parallaxImageView sd_setImageWithURL:self.imageURL placeholderImage:placeholderImage];
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset {
    _imageOffset = imageOffset;
    CGRect frame = self.parallaxImageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, 0, _imageOffset.y);
    self.parallaxImageView.frame = offsetFrame;
}

@end
