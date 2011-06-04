//
//  SettingsViewController.m
//  afGMDemo
//
//  Created by adrien ferré on 02/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController
@synthesize regionBtn;
@synthesize avoidSeg;
@synthesize travelSeg;
@synthesize unitsSeg;
@synthesize httpsSw;
@synthesize sensorSw;
@synthesize languageBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)sensorChanged:(UISwitch *)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"Sensor"];
}

-(IBAction)avoid:(UISegmentedControl *) sender{
    switch (sender.selectedSegmentIndex){
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:@"None" forKey:@"AvoidMode"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@"Highways" forKey:@"AvoidMode"];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setObject:@"Tolls" forKey:@"AvoidMode"];
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(IBAction)travel:(UISegmentedControl *) sender{
    switch (sender.selectedSegmentIndex){
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:@"Walking" forKey:@"TravelMode"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@"Driving" forKey:@"TravelMode"];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setObject:@"Bicycling" forKey:@"TravelMode"];
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(IBAction)units:(UISegmentedControl *) sender{
    switch (sender.selectedSegmentIndex){
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:@"Default" forKey:@"Units"];
            break;
        case 1:
            [[NSUserDefaults standardUserDefaults] setObject:@"Metric" forKey:@"Units"];
            break;
        case 2:
            [[NSUserDefaults standardUserDefaults] setObject:@"Imperial" forKey:@"Units"];
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)language:(id)sender {
}

- (IBAction)region:(id)sender {
    
}

- (IBAction)httpsTouched:(UISwitch *)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool: sender.on forKey:@"HTTPS"];
}

- (void)dealloc
{
    [avoidSeg release];
    [travelSeg release];
    [unitsSeg release];
    [regionBtn release];
    [httpsSw release];
    [sensorSw release];
    [languageBtn release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setAvoidSeg:nil];
    [self setTravelSeg:nil];
    [self setUnitsSeg:nil];
    [self setRegionBtn:nil];
    [self setHttpsSw:nil];
    [self setSensorSw:nil];
    [self setLanguageBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
