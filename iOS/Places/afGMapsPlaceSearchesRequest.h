//
//  afGMapsPlaceSearchesRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlacesRequest.h"
#import "Place.h"

@protocol afGoogleMapsPlaceSearchesDelegate;

@interface afGMapsPlaceSearchesRequest : afGMapsPlacesRequest


@property (nonatomic,assign) id<afGoogleMapsPlaceSearchesDelegate> afDelegate;
//provided

@property (nonatomic,assign) CLLocationCoordinate2D location;
//meters
@property (nonatomic,assign) double radius;
@property (nonatomic,retain) NSArray *types;
@property (nonatomic,retain) NSString *name;
//returned
@property (nonatomic,retain) NSMutableArray *places;
@property (nonatomic, retain) NSArray *htmlAttributions;
@end

@protocol afGoogleMapsPlaceSearchesDelegate <NSObject>
@optional
-(void) afPlaceSearchesWSStarted:(afGMapsPlaceSearchesRequest *)ws ;

-(void) afPlaceSearchesWS:(afGMapsPlaceSearchesRequest *)ws foundPlaces:(NSArray *)placesArray htmlAttributions:(NSArray *)htmlAttributions;

-(void) afPlaceSearchesWSFailed:(afGMapsPlaceSearchesRequest *)ws withError:(NSError *)er;

@end