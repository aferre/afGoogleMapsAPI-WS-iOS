//
//  PlacesDetailsViewController.h
//  afGMDemo
//
//  Created by adrien ferré on 06/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afGMapsPlaceDetailsRequest.h"

@interface PlacesDetailsViewController : UIViewController <UITextFieldDelegate,afGoogleMapsPlaceDetailsDelegate>{
    UITextField *refTF;
    UIButton *goBtn;
    UITextView *resultTV;
}

@property (nonatomic, retain) IBOutlet UITextField *refTF;

@property (nonatomic, retain) IBOutlet UIButton *goBtn;

@property (nonatomic, retain) IBOutlet UITextView *resultTV;


- (IBAction)goBtnPressed:(id)sender;

@end
