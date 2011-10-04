//
//  afGMapsPlaceReportRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlacesRequest.h"

@protocol afGoogleMapsPlaceReportDelegate;

@interface afGMapsPlaceReportRequest : afGMapsPlacesRequest    

//provided 

@property (nonatomic,assign) CLLocationCoordinate2D location;
//meters
@property (nonatomic,assign) double accuracy;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *reference;
@property (nonatomic,retain) NSArray *types;
@property (nonatomic,assign) id<afGoogleMapsPlaceReportDelegate> afDelegate;

//computed
@property (nonatomic,assign) BOOL isDeleting;

@end

@protocol afGoogleMapsPlaceReportDelegate <NSObject>

@optional

-(void) afPlaceReportWSStarted:(afGMapsPlaceReportRequest *)ws ;

-(void) afPlaceReportWSSucceeded:(afGMapsPlaceReportRequest *)ws;

-(void) afPlaceReportWS:(afGMapsPlaceReportRequest *)ws succesfullyAdded:(NSString *)ref withId:(NSString *)theid;

-(void) afPlaceReportWS:(afGMapsPlaceReportRequest *)ws succesfullyDeleted:(NSString *)ref;

-(void) afPlaceReportWSFailed:(afGMapsPlaceReportRequest *)ws withError:(NSError *)er;

-(void) afPlaceReportWSFailed:(afGMapsPlaceReportRequest *)ws toAdd:(NSString *)ref withError:(NSError *)er;

-(void) afPlaceReportWSFailed:(afGMapsPlaceReportRequest *)ws toDelete:(NSString *)ref withError:(NSError *)er;

@end