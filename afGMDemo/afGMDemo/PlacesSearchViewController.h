//
//  PlacesSearchViewController.h
//  afGMDemo
//
//  Created by adrien ferré on 06/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afGMapsPlaceSearchesRequest.h"

@interface PlacesSearchViewController : UIViewController <UITextFieldDelegate,afGoogleMapsPlaceSearchesDelegate> {
    UITextField *latTf;
    UITextField *lngTf;
    UITextField *radiusTF;
    UITextField *nameTF;
    UITextField *type1TF;
    UITextField *type2TF;
    UITextField *type3TF;
    UIButton *goBtn;
    UITextView *resultTV;
    UIButton *typesInfoBtn;
}
@property (nonatomic, retain) IBOutlet UIButton *typesInfoBtn;
- (IBAction)typesInfoBtnPressed:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField *latTf;
@property (nonatomic, retain) IBOutlet UITextField *lngTf;
@property (nonatomic, retain) IBOutlet UITextField *radiusTF;
@property (nonatomic, retain) IBOutlet UITextField *nameTF;
@property (nonatomic, retain) IBOutlet UITextField *type1TF;
@property (nonatomic, retain) IBOutlet UITextField *type2TF;
@property (nonatomic, retain) IBOutlet UITextField *type3TF;
@property (nonatomic, retain) IBOutlet UIButton *goBtn;
@property (nonatomic, retain) IBOutlet UITextView *resultTV;
 
- (IBAction)goBtnPressed:(id)sender;

@end
