//
//  RootViewController.h
//  afGMDemo
//
//  Created by adrien ferré on 29/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "afGMapsGeocodingRequest.h"

@interface GeocodingViewController : UIViewController <afGoogleMapsGeocodingDelegate>{

    UISwitch *revGeocodingSw;
    UITextField *addressTF;
    UITextField *latTF;
    UITextField *longTF;
    UISwitch *boundsSw;
    UITextField *p1latTF;
    UITextField *p1lngTF;
    UITextField *p2latTF;
    UITextField *p2lngTF;
    UIButton *launchBtn;
    UITextView *txtView;
}

- (IBAction)launchReq:(id)sender;

@property (nonatomic, retain) IBOutlet UISwitch *revGeocodingSw;
@property (nonatomic, retain) IBOutlet UITextField *addressTF;
@property (nonatomic, retain) IBOutlet UITextField *latTF;
@property (nonatomic, retain) IBOutlet UITextField *longTF;
@property (nonatomic, retain) IBOutlet UISwitch *boundsSw;
@property (nonatomic, retain) IBOutlet UITextField *p1latTF;
@property (nonatomic, retain) IBOutlet UITextField *p1lngTF;
@property (nonatomic, retain) IBOutlet UITextField *p2latTF;
@property (nonatomic, retain) IBOutlet UITextField *p2lngTF;
@property (nonatomic, retain) IBOutlet UIButton *launchBtn;
@property (nonatomic, retain) IBOutlet UITextView *txtView;

- (IBAction)reverseSw:(id)sender;
- (IBAction)boundsChanged:(id)sender;

@end
