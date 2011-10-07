//
//  PlacesReportViewController.h
//  afGMDemo
//
//  Created by adrien ferré on 06/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afGMapsPlaceReportRequest.h"

@interface PlacesReportViewController : UIViewController <UITextFieldDelegate, afGoogleMapsPlaceReportDelegate>   {
    UITextField *latTF;
    UITextField *longTF;
    UITextField *nameTF;
    UITextField *refTF;
    UITextField *accuracyTF;
    UITextField *type1TF;
    UITextField *type2TF;
    UITextField *type3TF;
    UISwitch *deleteSwitch;
    UIButton *goBtn;
}

@property (nonatomic, retain) IBOutlet UITextField *latTF;
@property (nonatomic, retain) IBOutlet UITextField *longTF;
@property (nonatomic, retain) IBOutlet UITextField *nameTF;
@property (nonatomic, retain) IBOutlet UITextField *refTF;
@property (nonatomic, retain) IBOutlet UITextField *accuracyTF;
@property (nonatomic, retain) IBOutlet UITextField *type1TF;
@property (nonatomic, retain) IBOutlet UITextField *type2TF;
@property (nonatomic, retain) IBOutlet UITextField *type3TF;
@property (nonatomic, retain) IBOutlet UISwitch *deleteSwitch;
@property (nonatomic, retain) IBOutlet UIButton *goBtn;

- (IBAction)goBtnPressed:(id)sender;

- (IBAction)deleteSwitchTouched:(id)sender;

@end
