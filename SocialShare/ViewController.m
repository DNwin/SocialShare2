//
//  ViewController.m
//  SocialShare
//
//  Created by Dennis Nguyen on 8/14/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "ViewController.h"
#import "SocialActivity.h"
@import Social;
@import QuartzCore;

// Used to easily check tags of buttons
typedef NS_ENUM(NSInteger, SocialButtonTags) {
    SocialButtonTagFacebook,
    SocialButtonTagTwitter
    // SocialButtonTagSinaWeibo,
};

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)socialTapped:(id)sender {
    NSString *serviceType = @"";
    
    // Set service type depending on which button is pressed
    switch (((UIButton *)sender).tag) {
        case SocialButtonTagFacebook:
            serviceType = SLServiceTypeFacebook;
            break;
        case SocialButtonTagTwitter:
            serviceType = SLServiceTypeTwitter;
            break;
        default:
            break;
    }
    
    // Present an alert if chosen social account isn't found
    if (![SLComposeViewController isAvailableForServiceType:serviceType]) {
        [self showUnavailableAlertForServiceType: serviceType];
    } else {
        // Compose a social post using text from textview and image.
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        [composeViewController addImage:self.imageView.image];
        
        NSString *initialTextString = [NSString stringWithFormat:@"Info: %@", self.textView.text];
        [composeViewController setInitialText:initialTextString];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    
}

- (void)showUnavailableAlertForServiceType:(NSString *)serviceType {
    NSString *serviceName = @"";
    
    if (serviceType == SLServiceTypeFacebook) {
        serviceName = @"Facebook";
    } else if (serviceType == SLServiceTypeTwitter) {
        serviceName = @"Twitter";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Account" message:[NSString stringWithFormat:@"Please go to the device Settings and add a %@ account in order to share through that service.", serviceName]  preferredStyle:UIAlertControllerStyleAlert];
    
    // Add a cancel button
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)actionTapped:(id)sender {
    SocialActivity *socialActivity = [[SocialActivity alloc] init];
    
    NSString *initialTextString = [NSString stringWithFormat:@"Text: %@", self.textView.text];
    
    // Send image and text to activity view controller with a custom activity;
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageView.image, initialTextString] applicationActivities:@[socialActivity]];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
