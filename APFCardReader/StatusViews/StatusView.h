//
//  StatusView.h
//  APFCardReader
//
//  Created by Purna Annapureddy on 6/21/13.
//  Copyright (c) 2013 Purna Annapureddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusView : UIView

@property (strong, nonatomic) IBOutlet UILabel * statusTextLabel;

+ (StatusView *)instance;

@end
