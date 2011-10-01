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
@property (nonatomic,assign) CLLocationCoordinate2D location;
//meters
@property (nonatomic,assign) double radius;
@property (nonatomic,retain) NSArray *types;
@property (nonatomic,retain) NSString *name;

@end

@protocol afGoogleMapsPlaceSearchesDelegate <NSObject>
@optional
-(void) afPlaceSearchesWSStarted:(afGMapsPlaceSearchesRequest *)ws ;

-(void) afPlaceSearchesWSSucceeded:(afGMapsPlaceSearchesRequest *)ws;

-(void) afPlaceSearchesWSFailed:(afGMapsPlaceSearchesRequest *)ws withError:(NSError *)er;

@end

@interface Place : NSObject 

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *vicinity;
@property (nonatomic,retain) NSString *reference;
@property (nonatomic,retain) NSString *theid;
@property (nonatomic,retain) NSArray *types;
@property (nonatomic,retain) NSURL *iconURL;
@property (nonatomic,retain) Geometry *geometry;

@end