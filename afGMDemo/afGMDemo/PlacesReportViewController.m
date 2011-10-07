//
//  PlacesReportViewController.m
//  afGMDemo
//
//  Created by adrien ferré on 06/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "PlacesReportViewController.h"

@implementation PlacesReportViewController
@synthesize latTF;
@synthesize longTF;
@synthesize nameTF;
@synthesize refTF;
@synthesize accuracyTF;
@synthesize type1TF;
@synthesize type2TF;
@synthesize type3TF;
@synthesize deleteSwitch;
@synthesize goBtn;

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
    [self deleteSwitchTouched:deleteSwitch];
    
    self.navigationItem.title = @"Report place";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setLatTF:nil];
    [self setLongTF:nil];
    [self setNameTF:nil];
    [self setRefTF:nil];
    [self setAccuracyTF:nil];
    [self setType1TF:nil];
    [self setType2TF:nil];
    [self setType3TF:nil];
    [self setGoBtn:nil];
    [self setDeleteSwitch:nil];
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
    [latTF release];
    [longTF release];
    [nameTF release];
    [refTF release];
    [accuracyTF release];
    [type1TF release];
    [type2TF release];
    [type3TF release];
    [goBtn release];
    [deleteSwitch release];
    [super dealloc];
}

- (IBAction)goBtnPressed:(id)sender {
    
    if (deleteSwitch.on){
        if ([refTF.text isEqualToString:@""]){
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Missing reference" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [al show];
            [al release];
            
            return;
        }
        afGMapsPlaceReportRequest *req = [afGMapsPlaceReportRequest request];
        [req setTheReference:[refTF.text copy]];
        
        req.afDelegate = self;
        [req startAsynchronous];
    }else{
        if ([latTF.text isEqualToString:@""] || [longTF.text isEqualToString:@""] || [accuracyTF.text isEqualToString:@""] || [nameTF.text isEqualToString:@""] || [type1TF.text isEqualToString:@""]){
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Missing parameter(s)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [al show];
            [al release];
            
            return;
        }
        
        afGMapsPlaceReportRequest *req = [afGMapsPlaceReportRequest request];
        req.location = CLLocationCoordinate2DMake([latTF.text doubleValue], [longTF.text doubleValue]);
        req.accuracy = [accuracyTF.text doubleValue];
        [req setTheName:[nameTF.text copy]];
        NSMutableArray *ar = [[NSMutableArray alloc] init];
        if (![type1TF.text isEqualToString:@""]){
            [ar addObject:type1TF.text];
        }
        if (![type2TF.text isEqualToString:@""]){
            [ar addObject:type2TF.text];
        }
        if (![type3TF.text isEqualToString:@""]){
            [ar addObject:type3TF.text];
        }
        req.types = ar;
        [ar release];
        
        req.afDelegate = self;
        [req startAsynchronous];
    }
    
}

- (IBAction)deleteSwitchTouched:(UISwitch *)sender {
    
    //ON = DELETING
    refTF.enabled = sender.on;
    latTF.enabled = !sender.on;
    longTF.enabled = !sender.on;
    nameTF.enabled = !sender.on;
    accuracyTF.enabled = !sender.on;
    type1TF.enabled = !sender.on;
    type2TF.enabled = !sender.on;
    type3TF.enabled = !sender.on;
    
}

#pragma mark ------------------------------------------
#pragma mark ------ TextField delegates
#pragma mark ------------------------------------------

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ------------------------------------------
#pragma mark ------ afDelegates
#pragma mark ------------------------------------------

-(void) afPlaceReportWSStarted:(afGMapsPlaceReportRequest *)ws{
    
}

//never called because we are implementing the other 2 (see below)
-(void) afPlaceReportWSSucceeded:(afGMapsPlaceReportRequest *)ws{
    
}

-(void) afPlaceReportWS:(afGMapsPlaceReportRequest *)ws succesfullyAdded:(NSString *)ref withId:(NSString *)theid{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfuly added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [al show];
    [al release];
}

-(void) afPlaceReportWS:(afGMapsPlaceReportRequest *)ws succesfullyDeleted:(NSString *)ref{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Successfuly deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [al show];
    [al release];
}

//never called because we are implementing the other 2 (see below)
-(void) afPlaceReportWSFailed:(afGMapsPlaceReportRequest *)ws withError:(NSError *)er{
    
}

-(void) afPlaceReportWSFailed:(afGMapsPlaceReportRequest *)ws toAdd:(NSString *)ref withError:(NSError *)er{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error when adding" message:er.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [al show];
    [al release];
}


-(void) afPlaceReportWSFailed:(afGMapsPlaceReportRequest *)ws toDelete:(NSString *)ref withError:(NSError *)er{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error when deleting" message:er.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [al show];
    [al release];
}

@end
