//
//  PlacesDetailsViewController.m
//  afGMDemo
//
//  Created by adrien ferré on 06/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "PlacesDetailsViewController.h"

@implementation PlacesDetailsViewController
@synthesize refTF;
@synthesize goBtn;
@synthesize resultTV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    
    self.navigationItem.title = @"Detail places";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setRefTF:nil];
    [self setGoBtn:nil];
    [self setResultTV:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [refTF release];
    [goBtn release];
    [resultTV release];
    [super dealloc];
}

- (IBAction)goBtnPressed:(id)sender {
    
    if([refTF.text isEqualToString:@""]){
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Missing ref" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
        [al release];
        return;
    }
    
    afGMapsPlaceDetailsRequest *req = [afGMapsPlaceDetailsRequest request];
    BOOL useSensor = [[NSUserDefaults standardUserDefaults] boolForKey:@"Sensor"];
    
    [req setUseSensor:useSensor];
    req.afDelegate = self;
    req.reference = refTF.text;
    
    [req startAsynchronous];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ------------------------------------------
#pragma mark ------ afDelegates
#pragma mark ------------------------------------------

-(void) afPlaceDetailsWSStarted:(afGMapsPlaceDetailsRequest *)ws{
     resultTV.text = @"";
    
}

-(void) afPlaceDetailsWS:(afGMapsPlaceDetailsRequest *)ws gotDetails:(PlaceDetails *)details htmlAttributions:(NSArray *)htmlAttributions{
    
    NSString *str = [details textualDesc];
    
    resultTV.text = str;
}

-(void) afPlaceDetailsWSFailed:(afGMapsPlaceDetailsRequest *)ws withError:(NSError *)er{
    
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:er.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [al show];
    [al release];
}

@end
