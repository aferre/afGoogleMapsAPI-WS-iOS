//
//  PlacesViewController.h
//  afGMDemo
//
//  Created by adrien ferré on 06/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlacesCheckinViewController.h"
#import "PlacesDetailsViewController.h"
#import "PlacesSearchViewController.h"
#import "PlacesReportViewController.h"

@interface PlacesViewController : UIViewController {
    UIButton *checkinBtn;
    UIButton *detailsBtn;
    UIButton *reportBtn;
    UIButton *searchBtn;
}

@property (nonatomic, retain) IBOutlet UIButton *checkinBtn;
@property (nonatomic, retain) IBOutlet UIButton *detailsBtn;
@property (nonatomic, retain) IBOutlet UIButton *reportBtn;
@property (nonatomic, retain) IBOutlet UIButton *searchBtn;

- (IBAction)checkinBtnPressed:(id)sender;
- (IBAction)detailsBtnPressed:(id)sender;
- (IBAction)reportBtnPressed:(id)sender;
- (IBAction)serachBtnPressed:(id)sender;

@end
