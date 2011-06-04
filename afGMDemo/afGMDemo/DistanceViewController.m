//
//  DistanceViewController.m
//  afGMDemo
//
//  Created by adrien ferré on 02/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "DistanceViewController.h"


@implementation DistanceViewController
@synthesize origin1TF;
@synthesize origin2TF;
@synthesize origin3TF;
@synthesize dest1TF;
@synthesize dest2TF;
@synthesize dest3TF;
@synthesize launchBtn;
@synthesize txtView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [origin1TF release];
    [origin2TF release];
    [origin3TF release];
    [dest1TF release];
    [dest2TF release];
    [dest3TF release];
    [launchBtn release];
    [txtView release];
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
    [self setOrigin1TF:nil];
    [self setOrigin2TF:nil];
    [self setOrigin3TF:nil];
    [self setDest1TF:nil];
    [self setDest2TF:nil];
    [self setDest3TF:nil];
    [self setLaunchBtn:nil];
    [self setTxtView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)startReq:(id)sender {
    afGMapsDistanceRequest *req = [afGMapsDistanceRequest distanceRequest];
    
    req.afDelegate = self;
    
    [req setOrigins:[NSArray arrayWithObject:origin1TF.text]];
    
    [req setDestinations:[NSArray arrayWithObject:dest1TF.text]];
    
    BOOL useHTTPS = [[NSUserDefaults standardUserDefaults] boolForKey:@"HTTPS"];
    BOOL useSensor = [[NSUserDefaults standardUserDefaults] boolForKey:@"Sensor"];
    
    [req setUseSensor:useSensor];
    [req setUseHTTPS:useHTTPS];
    
    NSString *avoid = [[NSUserDefaults standardUserDefaults] objectForKey:@"AvoidMode"];
    
    if ([avoid isEqualToString:@"None"])
        [req setAvoidMode:AvoidModeNone];
    else if ([avoid isEqualToString:@"Tolls"])
        [req setAvoidMode:AvoidModeTolls];
    else if ([avoid isEqualToString:@"Highways"])
        [req setAvoidMode:AvoidModeHighway];
    
    NSString *units = [[NSUserDefaults standardUserDefaults] objectForKey:@"Units"];
    
    if ([units isEqualToString:@"Default"])
        [req setUnitsSystem:UnitsDefault];
    else if ([units isEqualToString:@"Metric"])
        [req setUnitsSystem:UnitsMetric];
    else if ([units isEqualToString:@"Imperial"])
        [req setUnitsSystem:UnitsImperial];
    
    NSString *travel = [[NSUserDefaults standardUserDefaults] objectForKey:@"TravelMode"];
    
    if ([travel isEqualToString:@"Driving"])
        [req setTravelMode:TravelModeDriving];
    else if ([travel isEqualToString:@"Walking"])
        [req setTravelMode:TravelModeWalking];
    else if ([travel isEqualToString:@"Bicylcing"])
        [req setTravelMode:TravelModeBicycling];
    
    [req startAsynchronous];
}

-(void) afDistanceWSStarted:(afGMapsDistanceRequest *)ws {
    
}

-(void) afDistanceWS:(afGMapsDistanceRequest *)ws gotDistance:(NSString *) dist{
    txtView.text = [NSString stringWithFormat:@"Got distance: %@",dist];   
}

-(void) afDistanceWSFailed:(afGMapsDistanceRequest *)ws withError:(NSString *)er{
    txtView.text = [NSString stringWithFormat:@"Failed with error : %@",er];  
}

@end
