//
//  SocialActivity.m
//  SocialShare
//
//  Created by Dennis Nguyen on 8/14/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "SocialActivity.h"

// Class SocialActivity - This creates a custom button in the activity panel
// which creates a custom photo based off of an image and text when pressed.

@interface SocialActivity()

@property (strong, nonatomic) UIImage *activityImage;
@property (copy, nonatomic) NSString *activityText;

// Methods to override for custom activity
- (UIImage *)activityImage; // Image to be shown
- (NSString *)activityTitle; // Title to be shown
- (NSString *)activityType; // Identifier for unique activity
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems; // Array to check for support
- (void)prepareWithActivityItems:(NSArray *)activityItems; // If supported, prepare items
- (void)performActivity; // Execute custom activity


@end
@implementation SocialActivity


#pragma mark - Override
// Set B/W alpha image (similar to tabbar)
- (UIImage *)activityImage {
    return [UIImage imageNamed:@"activity"];
}

// Custom activity title
- (NSString *)activityTitle {
    return @"Save text to Photos";
}

// Custom identifier
- (NSString *)activityType {
    return @"net.dnwin.SocialShare.textView";
}

// Verify array that it contains correct types
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    // Check for images and strings
    for (id item in activityItems) {
        if ([item class] == [UIImage class]
            || [item isKindOfClass:[NSString class]]) {
            // Do nothing
        } else {
            return NO;
        }
    }
    return YES;
}

// Go through array and assign to properties
- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id item in activityItems) {
        if ([item class] == [UIImage class]) {
            self.activityImage = item;
            NSLog(@"Saving image to activity: %@", item);
        } else if ([item isKindOfClass:[NSString class]]) {
            self.activityText = item;
            NSLog(@"Saving text to activity: %@", item);
        }
    }
}

- (void)performActivity {
    CGSize quoteSize = CGSizeMake(640, 960);
    UIGraphicsBeginImageContext(quoteSize);

    // Make a new quote view
    UIView *quoteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, quoteSize.width, quoteSize.height)];
    quoteView.backgroundColor = [UIColor blackColor];
    
    // Make an image view
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.activityImage];
    imageView.frame = CGRectMake(20, 20, 600, 320);
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    // Make a label
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 600, 600)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 10;
    textLabel.font = [UIFont fontWithName:@"HelvelticaNeue-Bold" size:44];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = self.activityText;
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    
    // Add imageview and label to quoteview
    [quoteView addSubview:imageView];
    [quoteView addSubview:textLabel];
    
    // Save the view to current graphics content as a photo
    [quoteView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageToSave = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil);
    
    // Notifiy activty that it is done
    [self activityDidFinish:YES];
}

@end
