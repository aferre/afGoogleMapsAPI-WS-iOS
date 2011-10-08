//
//  afGMapsPlaceSearchesRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlacesRequest.h"

@protocol afGoogleMapsPlaceSearchesDelegate;

@interface afGMapsPlaceSearchesRequest : afGMapsPlacesRequest

@property (nonatomic,assign) id<afGoogleMapsPlaceSearchesDelegate> afDelegate;

#pragma mark ------------------------------------------
#pragma mark ------ Provided
#pragma mark ------------------------------------------
@property (nonatomic,assign) CLLocationCoordinate2D location;
@property (nonatomic,assign) double radius; //meters
@property (nonatomic,retain) NSMutableArray *types;
@property (nonatomic,retain) NSString *name;

#pragma mark ------------------------------------------
#pragma mark ------ Returned
#pragma mark ------------------------------------------
@property (nonatomic,retain) NSMutableArray *places;
@property (nonatomic,retain) NSArray *htmlAttributions;

+(id)request;

-(void) addTypeString:(NSString *) typeString;

-(void) addTypeEnum:(PlacesType1) type;

@end

@protocol afGoogleMapsPlaceSearchesDelegate <NSObject>
@optional
-(void) afPlaceSearchesWSStarted:(afGMapsPlaceSearchesRequest *)ws ;

-(void) afPlaceSearchesWS:(afGMapsPlaceSearchesRequest *)ws foundPlaces:(NSArray *)placesArray htmlAttributions:(NSArray *)htmlAttributions;

-(void) afPlaceSearchesWSFailed:(afGMapsPlaceSearchesRequest *)ws withError:(NSError *)er;

@end