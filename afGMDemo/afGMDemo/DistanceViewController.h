//
//  DistanceViewController.h
//  afGMDemo
//
//  Created by adrien ferré on 02/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afGMapsDistanceRequest.h"

@interface DistanceViewController : UIViewController <afGoogleMapsDistanceDelegate>{
    
    UITextField *origin1TF;
    UITextField *origin2TF;
    UITextField *origin3TF;
    UITextField *dest1TF;
    UITextField *dest2TF;
    UITextField *dest3TF;
    UIButton *launchBtn;
    UITextView *txtView;
}
@property (nonatomic, retain) IBOutlet UITextField *origin1TF;
@property (nonatomic, retain) IBOutlet UITextField *origin2TF;
@property (nonatomic, retain) IBOutlet UITextField *origin3TF;
@property (nonatomic, retain) IBOutlet UITextField *dest1TF;
@property (nonatomic, retain) IBOutlet UITextField *dest2TF;
@property (nonatomic, retain) IBOutlet UITextField *dest3TF;
@property (nonatomic, retain) IBOutlet UIButton *launchBtn;
@property (nonatomic, retain) IBOutlet UITextView *txtView;
- (IBAction)startReq:(id)sender;

@end
