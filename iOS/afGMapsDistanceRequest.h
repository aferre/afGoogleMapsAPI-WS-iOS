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
    
    NSArray *origins;
    
    NSArray *destinations;

    TravelMode travelMode;
    
    AvoidMode avoidMode;
    
    UnitsSystem unitsSystem;
}

@property (nonatomic,assign) id<afGoogleMapsDistanceDelegate> afDelegate;
@property (nonatomic,assign) NSArray *origins;
@property (nonatomic,assign) NSArray *destinations;
@property (nonatomic,assign) TravelMode travelMode;
@property (nonatomic,assign) AvoidMode avoidMode;
@property (nonatomic,assign) UnitsSystem unitsSystem;

- (id) initDefault;

+ (id) distanceRequest;

- (NSURL *)makeURL;

@end

@protocol afGoogleMapsDistanceDelegate <NSObject>

@optional

-(void) afDistanceWSStarted:(afGMapsDistanceRequest *)ws ;

-(void) afDistanceWS:(afGMapsDistanceRequest *)ws gotDistance:(NSString *) dist;

-(void) afDistanceWSFailed:(afGMapsDistanceRequest *)ws withError:(NSString *)er;

@end