//
//  CustomStatus.m
//  APFCardReader
//
//  Created by Purna Annapureddy on 6/21/13.
//  Copyright (c) 2013 Purna Annapureddy. All rights reserved.
//

#import "CustomStatus.h"
#import "StatusView.h"

@implementation CustomStatus

- (id)init
{
    self = [super init];
    if (self) {
        statusViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addStatusViewToParentView:(UIView *)view withMessage:(NSString *)statusMesg
{
    StatusView *statusView = [[StatusView alloc] init];
    StatusView *prevStatusView = nil;
    if ([statusViews count] == 0) {
        [statusView setFrame:CGRectMake(725, -90, 380, 90)];
    } else {
        prevStatusView = [statusViews objectAtIndex:statusViews.count-1];
        [statusView setFrame:CGRectMake(725, prevStatusView.frame.size.height-90, 380, 90)];
    }
    [statusViews addObject:statusView];
}

- (void)showStatusView

@end
