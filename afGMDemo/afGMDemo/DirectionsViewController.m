//
//  DirectionsViewController.m
//  afGMDemo
//
//  Created by adrien ferré on 02/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "DirectionsViewController.h"


@implementation DirectionsViewController
@synthesize launchBtn;
@synthesize originTF;
@synthesize destinationTF;
@synthesize waypointsTF;
@synthesize alternativesSw;
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
    [originTF release];
    [destinationTF release];
    [waypointsTF release];
    [alternativesSw release];
    [originTF release];
    [destinationTF release];
    [waypointsTF release];
    [alternativesSw release];
    [txtView release];
    [launchBtn release];
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
    [originTF release];
    originTF = nil;
    [destinationTF release];
    destinationTF = nil;
    [waypointsTF release];
    waypointsTF = nil;
    [alternativesSw release];
    alternativesSw = nil;
    [self setOriginTF:nil];
    [self setDestinationTF:nil];
    [self setWaypointsTF:nil];
    [self setAlternativesSw:nil];
    [self setTxtView:nil];
    [self setLaunchBtn:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)launchReq:(id)sender {
    
    [originTF resignFirstResponder];
    [destinationTF resignFirstResponder];
    [waypointsTF resignFirstResponder];
    
    afGMapsDirectionsRequest *req = [afGMapsDirectionsRequest request];
    req.afDelegate = self;
    
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
    
    [req setOrigin:self.originTF.text];
    
    [req setDestination:self.destinationTF.text];
    
    [req setAlternatives:self.alternativesSw.on];
    if (![self.waypointsTF.text isEqualToString:@""])
        [req setWaypoints:[NSArray arrayWithObject:self.waypointsTF.text]];
    
    [req startAsynchronous];
}

#pragma mark ------------------------------------------
#pragma mark ------ afGMaps Direction delegates
#pragma mark ------------------------------------------

-(void) afDirectionsWSStarted:(afGMapsDirectionsRequest *)ws{
    self.txtView.text = @"";
}

-(void) afDirectionsWS:(afGMapsDirectionsRequest *)ws gotRoutes:(NSArray *)res{
    
    Route *r = [res objectAtIndex:0];
    NSMutableString *str = [NSMutableString stringWithFormat:@"Got %u routes %@",[res count], res];
    [str appendFormat:@"Route 1"];
    for (Leg *leg in r.legs){
        for (Step *step in leg.steps){
            [str appendFormat:@"\n%@",step.htmlInstructions];
        }
    }
    self.txtView.text = str;
}

-(void) afDirectionsWSFailed:(afGMapsDirectionsRequest *)ws withError:(NSError *)er{
    self.txtView.text = [NSString stringWithFormat:@"Failed with error %@",[er localizedDescription]];
}


@end
