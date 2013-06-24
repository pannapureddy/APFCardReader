//
//  ViewController.h
//  APFCardReader
//
//  Created by Purna Annapureddy on 6/21/13.
//  Copyright (c) 2013 Purna Annapureddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DTDevices.h"

@interface ParentViewController : UIViewController<UIWebViewDelegate, MBProgressHUDDelegate, DTDeviceDelegate>
{
    DTDevices *dtdev;
}

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIWebView *apfWebView;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSDictionary *card;

@end
