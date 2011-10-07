//
//  PlacesSearchViewController.m
//  afGMDemo
//
//  Created by adrien ferré on 06/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "PlacesSearchViewController.h"

@implementation PlacesSearchViewController
@synthesize latTf;
@synthesize lngTf;
@synthesize radiusTF;
@synthesize nameTF;
@synthesize type1TF;
@synthesize type2TF;
@synthesize type3TF;
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
    
    self.navigationItem.title = @"Search places";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setLatTf:nil];
    [self setLngTf:nil];
    [self setRadiusTF:nil];
    [self setNameTF:nil];
    [self setType1TF:nil];
    [self setType2TF:nil];
    [self setType3TF:nil];
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
    [latTf release];
    [lngTf release];
    [radiusTF release];
    [nameTF release];
    [type1TF release];
    [type2TF release];
    [type3TF release];
    [goBtn release];
    [resultTV release];
    
    [super dealloc];
}
- (IBAction)goBtnPressed:(id)sender {
    
    if ([latTf.text isEqualToString:@""] || [lngTf.text isEqualToString:@""] || [radiusTF.text isEqualToString:@""] || [nameTF.text isEqualToString:@""]){
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Missing parameter(s)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
        [al release];
        
        return;
    }
    
    afGMapsPlaceSearchesRequest *req = [afGMapsPlaceSearchesRequest request];
    BOOL useSensor = [[NSUserDefaults standardUserDefaults] boolForKey:@"Sensor"];
    
    [req setUseSensor:useSensor];
    req.location = CLLocationCoordinate2DMake([latTf.text doubleValue], [lngTf.text doubleValue]);
    req.name = nameTF.text;
    req.radius = [radiusTF.text doubleValue];
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:3];
    if (![type1TF.text isEqualToString:@""]){
        [ar addObject:type1TF.text];
    }if (![type2TF.text isEqualToString:@""]){
        [ar addObject:type2TF.text];
    }if (![type3TF.text isEqualToString:@""]){
        [ar addObject:type3TF.text];
    }
    req.types = ar;
    req.afDelegate = self;
    [req startAsynchronous];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ------------------------------------------
#pragma mark ------ afDelegates
#pragma mark ------------------------------------------
-(void) afPlaceSearchesWSStarted:(afGMapsPlaceSearchesRequest *)ws {
    resultTV.text = @"";
}

-(void) afPlaceSearchesWS:(afGMapsPlaceSearchesRequest *)ws foundPlaces:(NSArray *)placesArray htmlAttributions:(NSArray *)htmlAttributions{
    NSString *str = resultTV.text;
    for (Place *place in placesArray)
        str = [str stringByAppendingFormat:@"\n%@",[place textualDesc]];
    for (NSString *htm in htmlAttributions)
        str = [str stringByAppendingFormat:@"\n%@",htm];
    resultTV.text = str;
}

-(void) afPlaceSearchesWSFailed:(afGMapsPlaceSearchesRequest *)ws withError:(NSError *)er{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:er.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [al show];
    [al release];
}

@end
