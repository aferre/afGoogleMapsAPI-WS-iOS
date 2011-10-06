//
//  PlacesViewController.m
//  afGMDemo
//
//  Created by adrien ferré on 06/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "PlacesViewController.h"

@implementation PlacesViewController
@synthesize checkinBtn;
@synthesize detailsBtn;
@synthesize reportBtn;
@synthesize searchBtn;

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
    
    self.navigationItem.title = @"Places";
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setCheckinBtn:nil];
    [self setDetailsBtn:nil];
    [self setReportBtn:nil];
    [self setSearchBtn:nil];
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
    [checkinBtn release];
    [detailsBtn release];
    [reportBtn release];
    [searchBtn release];
    [super dealloc];
}

- (IBAction)checkinBtnPressed:(id)sender {
    PlacesCheckinViewController *vc = [[PlacesCheckinViewController alloc] initWithNibName:@"PlacesCheckinViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [vc release];
}

- (IBAction)detailsBtnPressed:(id)sender {
    PlacesDetailsViewController *vc = [[PlacesDetailsViewController alloc] initWithNibName:@"PlacesDetailsViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [vc release];
}

- (IBAction)reportBtnPressed:(id)sender {
    PlacesReportViewController *vc = [[PlacesReportViewController alloc] initWithNibName:@"PlacesReportViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [vc release];
}

- (IBAction)serachBtnPressed:(id)sender {
    PlacesSearchViewController *vc = [[PlacesSearchViewController alloc] initWithNibName:@"PlacesSearchViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [vc release];
}

@end
