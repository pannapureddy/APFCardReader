//
//  ViewController.m
//  APFCardReader
//
//  Created by Purna Annapureddy on 6/21/13.
//  Copyright (c) 2013 Purna Annapureddy. All rights reserved.
//

#import "ParentViewController.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>

@interface ParentViewController ()
{
    BOOL status;
}

@end

@implementation ParentViewController
@synthesize apfWebView, progressHUD;
@synthesize card = _card;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.apfWebView.delegate = self;
    dtdev = [DTDevices sharedDevice];
    dtdev.delegate = self;
    [dtdev connect];
    [self connectionState:dtdev.connstate];
    NSURL *apfURL = [NSURL URLWithString:@"http://www.asfint.com/asfposnew/login.aspx"];
    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:apfURL];
    self.apfWebView.scrollView.bounces = NO;
    [self.apfWebView setBackgroundColor:[UIColor blackColor]];
    [self.apfWebView loadRequest:requestURL];
    [self drawStatusView];
    status = NO;
    NSTimer *timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(blinkStatus:) userInfo:nil repeats:YES];
    
}

- (void)connectionState:(int)state
{
    switch (state) {
        case CONN_CONNECTED:
            self.statusLabel.text = @"Connected";
            status = YES;
            self.statusButton.backgroundColor = [UIColor greenColor];
            break;
        case CONN_DISCONNECTED:
        case CONN_CONNECTING:
            status = NO;
            self.statusLabel.text = @"Not Connected";
            self.statusButton.backgroundColor = [UIColor redColor];
            break;
        default:
            break;
    }
}

- (void)blinkStatus:(NSTimer *)timer
{
    if (status) {
        if ([self.statusButton.backgroundColor isEqual:[UIColor greenColor]]) {
            self.statusButton.backgroundColor = [UIColor blackColor];
        } else {
            self.statusButton.backgroundColor = [UIColor greenColor];
        }
    } else {
        if ([self.statusButton.backgroundColor isEqual:[UIColor redColor]]) {
            self.statusButton.backgroundColor = [UIColor blackColor];
        } else {
            self.statusButton.backgroundColor = [UIColor redColor];
        }
    }
    return;
}

- (void)magneticCardData:(NSString *)track1 track2:(NSString *)track2 track3:(NSString *)track3
{
    NSString *javascript = @"$('[name=ctl00$MainContentPlaceHolder$ucOrderTender$ucPaymentMethodSelector$drpPaymentMethod]').length";
    if ([[self.apfWebView stringByEvaluatingJavaScriptFromString:javascript] integerValue] != 0) {
        int sound[]={2730,150,0,30,2730,150};
        [dtdev playSound:100 beepData:sound length:sizeof(sound) error:nil];
        _card = [[NSDictionary alloc] initWithDictionary:[dtdev msProcessFinancialCard:track1 track2:track2]];
        NSString *javascript = @"$('[name=ctl00$MainContentPlaceHolder$ucOrderTender$ucPaymentMethodSelector$drpPaymentMethod]').val('CreditCard').change();";
        [self.apfWebView stringByEvaluatingJavaScriptFromString:javascript];
    } else {
        [self showAlertForCheckoutPage];
    }
}

- (void)showAlertViewWithTitle: (NSString *)title withMessage:(NSString *)message
{
    UIAlertView *displayAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [displayAlertView show];
}

- (void)showAlertForCheckoutPage
{
    NSString *currentPageURL = self.apfWebView.request.URL.absoluteString;
    NSRange range = [currentPageURL rangeOfString:@"login.aspx" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        [self showAlertViewWithTitle:@"Error" withMessage:@"Please login and proceed to the checkout page"];
    } else {
        [self showAlertViewWithTitle:@"Error" withMessage:@"Please proceed to the checkout page after selecting the items by clicking the tendered button"];
    }
}

- (void)displayCreditCardDetails
{
    NSString *javascript = [NSString stringWithFormat:@"$('#ctl00_MainContentPlaceHolder_ucOrderTender_ucPaymentMethodSelector_txtFirstName').val('%@'); $('#ctl00_MainContentPlaceHolder_ucOrderTender_ucPaymentMethodSelector_txtLastName').val('%@'); $('#ctl00_MainContentPlaceHolder_ucOrderTender_ucPaymentMethodSelector_txtCardNumber').val('%@'); $('#ctl00_MainContentPlaceHolder_ucOrderTender_ucPaymentMethodSelector_drpExpireMonth').val('%@'); $('#ctl00_MainContentPlaceHolder_ucOrderTender_ucPaymentMethodSelector_drpExpireYear').val('%@');", [_card objectForKey:@"firstName"], [_card objectForKey:@"lastName"], [_card objectForKey:@"accountNumber"], [_card objectForKey:@"expirationMonth"], [_card objectForKey:@"expirationYear"]];
    [self.apfWebView stringByEvaluatingJavaScriptFromString:javascript];
}

- (void)drawStatusView
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:self.statusView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10.0f, 10.0f)];
    maskLayer.path = [roundPath CGPath];
    [self.statusView.layer setMask:maskLayer];
    self.statusButton.layer.cornerRadius = 5.0f;
}

- (void)showProgressHUD
{
    [self.view addSubview:self.progressHUD];
    self.progressHUD.labelText = @"Loading...";
    self.progressHUD.delegate = self;
    [self.progressHUD show:YES];
}

- (void)hideProgressHUD
{
    [self.progressHUD hide:YES];
    [self.progressHUD removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Optional UIWebViewDelegate delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showProgressHUD];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([webView.request.URL.absoluteString isEqualToString:@"http://www.asfint.com/asfposnew/Checkout.aspx"]) {
        NSString *javascript = @"$('[name=ctl00$MainContentPlaceHolder$ucOrderTender$ucPaymentMethodSelector$drpPaymentMethod]').val()";
        NSString *paymentMode = [webView stringByEvaluatingJavaScriptFromString:javascript];
        if ([paymentMode isEqualToString:@"CreditCard"]) {
            [self displayCreditCardDetails];
        }
    }
    [self hideProgressHUD];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)showStatusView {
    StatusView *statusView = [StatusView instance];
    statusView setFrame:CGRectMake();
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideProgressHUD];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)viewDidUnload {
    [self setStatusLabel:nil];
    [self setStatusView:nil];
    [self setStatusButton:nil];
    [super viewDidUnload];
}
@end
