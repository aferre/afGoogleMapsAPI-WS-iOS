//
//  SettingsViewController.h
//  afGMDemo
//
//  Created by adrien ferré on 02/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController{
    
    UISegmentedControl *avoidSeg;
    UISegmentedControl *travelSeg;
    UISegmentedControl *unitsSeg;
    UISwitch *httpsSw;
    UISwitch *sensorSw;
    UIButton *languageBtn;
    UIButton *regionBtn;
    UISwitch *sensorsChanged;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *avoidSeg;
@property (nonatomic, retain) IBOutlet UISegmentedControl *travelSeg;
@property (nonatomic, retain) IBOutlet UISegmentedControl *unitsSeg;
@property (nonatomic, retain) IBOutlet UISwitch *httpsSw;
@property (nonatomic, retain) IBOutlet UISwitch *sensorSw;
@property (nonatomic, retain) IBOutlet UIButton *languageBtn;
@property (nonatomic, retain) IBOutlet UIButton *regionBtn;

- (IBAction)sensorChanged:(id)sender;

- (IBAction)avoid:(UISegmentedControl *) sender;

- (IBAction)travel:(UISegmentedControl *) sender;

- (IBAction)units:(UISegmentedControl *) sender;

- (IBAction)language:(id)sender;

- (IBAction)region:(id)sender;

- (IBAction)httpsTouched:(id)sender;

@end
