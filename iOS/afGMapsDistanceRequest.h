//
//  afGoogleMapsDistanceWS.h
//  g2park
//
//  Created by adrien ferré on 29/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "afGoogleMapsAPIRequest.h"

#define GOOGLE_DISTANCE_API_PATH_COMPONENT @"distancematrix"

@protocol afGoogleMapsDistanceDelegate;

@interface afGMapsDistanceRequest : afGoogleMapsAPIRequest {
    
    id <afGoogleMapsDistanceDelegate> afDelegate;
    
    //provided
    
    NSArray *origins;
    
    NSArray *destinations;

    TravelMode travelMode;
    
    AvoidMode avoidMode;
    
    UnitsSystem unitsSystem;
    
}

@property (nonatomic,assign) id<afGoogleMapsDistanceDelegate> afDelegate;
@property (nonatomic,retain) NSArray *origins;
@property (nonatomic,retain) NSArray *destinations;
@property (nonatomic,assign) TravelMode travelMode;
@property (nonatomic,assign) AvoidMode avoidMode;
@property (nonatomic,assign) UnitsSystem unitsSystem;

- (id) initDefault;

+ (id) request;

- (NSURL *)makeURL;

@end

@protocol afGoogleMapsDistanceDelegate <NSObject>

@optional

-(void) afDistanceWSStarted:(afGMapsDistanceRequest *)ws ;

-(void) afDistanceWS:(afGMapsDistanceRequest *)ws gotDistance:(NSNumber *) distance unit:(UnitsSystem)unit;

-(void) afDistanceWSFailed:(afGMapsDistanceRequest *)ws withError:(NSError *)er;

-(void) afDistanceWS:(afGMapsDistanceRequest *)ws origin:(NSString *) origin destination:(NSString *)destination failedWithError:(NSError *) err;

-(void) afDistanceWS:(afGMapsDistanceRequest *)ws distance:(NSNumber *) distance origin:(NSString *) origin destination:(NSString *)destination unit:(UnitsSystem)unit;


-(void) afDistanceWS:(afGMapsDistanceRequest *)ws distance:(NSNumber *) distance textDistance:(NSString *)textDistance origin:(NSString *) origin returnedOrigin:(NSString *)returnedOrigin destination:(NSString *)destination returnedDestination:(NSString *)returnedDest duration:(NSNumber *)durationInSec textDuration:(NSString *)textDuration unit:(UnitsSystem)unit;

@end