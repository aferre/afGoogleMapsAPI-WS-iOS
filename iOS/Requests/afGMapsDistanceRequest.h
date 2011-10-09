//
//  afGoogleMapsDistanceWS.h
//  g2park
//
//  Created by adrien ferré on 29/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGoogleMapsAPIRequest.h"

#define GOOGLE_DISTANCE_API_PATH_COMPONENT @"distancematrix"

#define METER_TO_MILE 0.000621371192

@protocol afGoogleMapsDistanceDelegate;

@interface afGMapsDistanceRequest : afGoogleMapsAPIRequest {
    
    id <afGoogleMapsDistanceDelegate> afDelegate;
    
    //provided
    
    NSArray *origins;
    
    NSArray *destinations;

    TravelMode travelMode;
    
    AvoidMode avoidMode;
    
    UnitSystem unitsSystem;
    
}

@property (nonatomic,assign) id<afGoogleMapsDistanceDelegate> afDelegate;
@property (nonatomic,retain) NSArray *origins;
@property (nonatomic,retain) NSArray *destinations;
@property (nonatomic,assign) TravelMode travelMode;
@property (nonatomic,assign) AvoidMode avoidMode;
@property (nonatomic,assign) UnitSystem unitsSystem;

- (id) initDefault;

+ (id) request;

- (NSURL *)makeURL;

@end

@protocol afGoogleMapsDistanceDelegate <NSObject>

@optional

-(void) afDistanceWSStarted:(afGMapsDistanceRequest *)ws ;

-(void) afDistanceWS:(afGMapsDistanceRequest *)ws gotDistance:(NSNumber *) distance unit:(UnitSystem)unit;

-(void) afDistanceWSFailed:(afGMapsDistanceRequest *)ws withError:(NSError *)er;

-(void) afDistanceWS:(afGMapsDistanceRequest *)ws origin:(NSString *) origin destination:(NSString *)destination failedWithError:(NSError *) err;

-(void) afDistanceWS:(afGMapsDistanceRequest *)ws distance:(NSNumber *) distance origin:(NSString *) origin destination:(NSString *)destination unit:(UnitSystem)unit;


-(void) afDistanceWS:(afGMapsDistanceRequest *)ws distance:(NSNumber *) distance textDistance:(NSString *)textDistance origin:(NSString *) origin returnedOrigin:(NSString *)returnedOrigin destination:(NSString *)destination returnedDestination:(NSString *)returnedDest duration:(NSNumber *)durationInSec textDuration:(NSString *)textDuration unit:(UnitSystem)unit;

@end