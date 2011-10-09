//
//  DirectionsViewController.h
//  afGMDemo
//
//  Created by adrien ferré on 02/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afGMapsDirectionsRequest.h"

@interface DirectionsViewController : UIViewController <UITextFieldDelegate, afGoogleMapsDirectionsDelegate>{
   
    UITextField *originTF;
    UITextField *destinationTF;
    UITextField *waypointsTF;
    UISwitch *alternativesSw;
    UITextView *txtView;
    UIButton *launchBtn;
}

@property (nonatomic, retain) IBOutlet UIButton *launchBtn;
@property (nonatomic, retain) IBOutlet UITextField *originTF;
@property (nonatomic, retain) IBOutlet UITextField *destinationTF;
@property (nonatomic, retain) IBOutlet UITextField *waypointsTF;
@property (nonatomic, retain) IBOutlet UISwitch *alternativesSw;
@property (nonatomic, retain) IBOutlet UITextView *txtView;

- (IBAction)launchReq:(id)sender;

@end
