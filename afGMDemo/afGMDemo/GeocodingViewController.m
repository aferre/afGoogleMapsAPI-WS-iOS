//
//  RootViewController.m
//  afGMDemo
//
//  Created by adrien ferré on 29/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "GeocodingViewController.h"

@implementation GeocodingViewController
@synthesize revGeocodingSw;
@synthesize addressTF;
@synthesize latTF;
@synthesize longTF;
@synthesize boundsSw;
@synthesize p1latTF;
@synthesize p1lngTF;
@synthesize p2latTF;
@synthesize p2lngTF;
@synthesize launchBtn;
@synthesize txtView;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reverseSw:revGeocodingSw];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [self setRevGeocodingSw:nil];
    [self setAddressTF:nil];
    [self setLatTF:nil];
    [self setLongTF:nil];
    [self setBoundsSw:nil];
    [self setP1latTF:nil];
    [self setP1lngTF:nil];
    [self setP2latTF:nil];
    [self setP2lngTF:nil];
    [self setLaunchBtn:nil];
    [self setTxtView:nil];
    [super viewDidUnload];
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [revGeocodingSw release];
    [addressTF release];
    [latTF release];
    [longTF release];
    [boundsSw release];
    [p1latTF release];
    [p1lngTF release];
    [p2latTF release];
    [p2lngTF release];
    [launchBtn release];
    [txtView release];
    [super dealloc];
}

- (IBAction)launchReq:(id)sender {
    
    afGMapsGeocodingRequest *req =[afGMapsGeocodingRequest request];
    req.afDelegate = self;
    
    BOOL useHTTPS = [[NSUserDefaults standardUserDefaults] boolForKey:@"HTTPS"];
    BOOL useSensor = [[NSUserDefaults standardUserDefaults] boolForKey:@"Sensor"];
    
    [req setUseSensor:useSensor];
    [req setUseHTTPS:useHTTPS];
    [req setReverseGeocoding:self.revGeocodingSw.on];
    
    if (self.revGeocodingSw.on)
        [req setLatitude:[latTF.text doubleValue] andLongitude:[longTF.text doubleValue]];
    else
        [req setTheAddress:[NSString stringWithString: self.addressTF.text]];
    
    if (self.boundsSw.on){
        [req setBoundsP1:CGPointMake([self.p1latTF.text doubleValue], [self.p1lngTF.text doubleValue])];
        [req setBoundsP1:CGPointMake([self.p2latTF.text doubleValue], [self.p2lngTF.text doubleValue])];
    }
    
    [req startAsynchronous];
}

- (IBAction)reverseSw:(UISwitch *)sender {
    addressTF.enabled = !sender.on;
    latTF.enabled = sender.on;
    longTF.enabled = sender.on;
}

- (IBAction)boundsChanged:(UISwitch *)sender {
    p1latTF.enabled = sender.on;
    p1lngTF.enabled = sender.on;
    p2latTF.enabled = sender.on;
    p2lngTF.enabled = sender.on;
}

-(void) afGeocodingWSStarted:(afGMapsGeocodingRequest *)ws {
    txtView.text = @"";
}

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotCoordinates:(CLLocationCoordinate2D) coordinates fromAddress:(NSString *)address{
    txtView.text = [NSString stringWithFormat:@"Got latitude and longitude : %f %f from address %@",coordinates.latitude,coordinates.longitude,address]; 

}

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotAddress:(NSString *)address fromLatitude:(double)latitude andLongitude:(double)longitud{
    txtView.text = [NSString stringWithFormat:@"Got laddress : %@ from lat %f and long %f",address,latitude,longitud]; 
}

-(void) afGeocodingWSFailed:(afGMapsGeocodingRequest *)ws withError:(NSError *)er{
    
    txtView.text = [NSString stringWithFormat:@"Failed with error %@",[er localizedDescription]]; 
}

@end
