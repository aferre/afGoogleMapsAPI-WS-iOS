//
//  PlacesCheckinViewController.h
//  afGMDemo
//
//  Created by adrien ferré on 06/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afGMapsPlaceCheckinRequest.h"

@interface PlacesCheckinViewController : UIViewController <UITextFieldDelegate, afGoogleMapsPlaceCheckinDelegate>{
    UITextField *refTF;
    UIButton *goBtn;
}

@property (nonatomic, retain) IBOutlet UITextField *refTF;
@property (nonatomic, retain) IBOutlet UIButton *goBtn;
- (IBAction)goBtnPressed:(id)sender;

@end
