//
//  StatusView.m
//  APFCardReader
//
//  Created by Purna Annapureddy on 6/21/13.
//  Copyright (c) 2013 Purna Annapureddy. All rights reserved.
//

#import "StatusView.h"

@implementation StatusView
@synthesize statusTextLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.statusTextLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.statusTextLabel];
    }
    return self;
}

+ (StatusView *)instance
{
    static StatusView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[StatusView alloc] init];
    });
    return instance;
}

- (void)setStatusTextLabelWithText:(NSString *)statusText
{
    self.statusTextLabel.text = statusText;
    self.statusTextLabel.textColor = [UIColor clearColor];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
