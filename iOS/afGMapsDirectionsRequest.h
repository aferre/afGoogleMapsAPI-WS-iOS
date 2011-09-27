//
//  afGoogleMapsDIrectionsWS.h
//  g2park
//
//  Created by adrien ferré on 20/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "afGoogleMapsAPIRequest.h"

#define GOOGLE_DIRECTIONS_API_PATH_COMPONENT @"directions"

@protocol afGoogleMapsDirectionsDelegate;

typedef enum DirectionsRequestStatusCode { 
    DirectionsRequestStatusCodeOK = 0,
    DirectionsRequestStatusCodeNotFound,
    DirectionsRequestStatusCodeZeroResults,
    DirectionsRequestStatusCodeMaxWaypointsExceeded,
    DirectionsRequestStatusCodeInvalidRequest,
    DirectionsRequestStatusCodeOverQueryLimit,
    DirectionsRequestStatusCodeRequestDenied,
    DirectionsRequestStatusCodeUnknowError
} DirectionsRequestStatusCode;

@interface afGMapsDirectionsRequest : afGoogleMapsAPIRequest {
    
    id<afGoogleMapsDirectionsDelegate>  afDelegate;
    
    //provided
    NSString *origin;
    
    NSString *destination;
    
    TravelMode travelMode;
    
    AvoidMode avoidMode;
    
    NSArray *waypoints;
    
    BOOL alternatives;
    
    UnitsSystem unitsSystem;
    
    //returned
    
    NSArray *routes;
    
    DirectionsRequestStatusCode directionsRequestStatusCode;
    
}

@property (nonatomic, assign) id<afGoogleMapsDirectionsDelegate> afDelegate;
@property (nonatomic, assign) TravelMode travelMode;
@property (nonatomic, assign) AvoidMode avoidMode;
@property (nonatomic, retain) NSArray *waypoints;
@property (nonatomic, assign) BOOL alternatives;
@property (nonatomic, assign) UnitsSystem unitsSystem;
@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *destination;
@property (nonatomic, assign) DirectionsRequestStatusCode directionsRequestStatusCode;
@property (nonatomic, retain) NSArray *routes;

+(id) directionsRequest;

-(id) initDefault;

@end

@protocol afGoogleMapsDirectionsDelegate <NSObject>

@optional

-(void) afDirectionsWSStarted:(afGMapsDirectionsRequest *)ws ;

-(void) afDirectionsWS:(afGMapsDirectionsRequest *)ws gotRoutes:(NSArray *)routes;

-(void) afDirectionsWSFailed:(afGMapsDirectionsRequest *)ws withError:(NSError *)er;

@end

@interface Route : NSObject {
    NSString *summary;
    NSArray *legs;
    NSArray *waypointsOrder;
    NSString *copyrights;
    NSArray *warnings;
}

@property (nonatomic,retain) NSString *summary;
@property (nonatomic,retain) NSArray *legs;
@property (nonatomic,retain) NSArray *waypointsOrder;
@property (nonatomic,retain) NSString *copyrights;
@property (nonatomic,retain) NSArray *warnings;

+ (Route *) parseJsonDico:(NSDictionary *)routeDico;

@end

@interface Step : NSObject {
    NSString *htmlInstructions;
    NSNumber *distanceValue;
    NSNumber *durationValue;
    NSString *durationText;
    NSString *distanceText;
    CLLocationCoordinate2D startLocation;
    CLLocationCoordinate2D endLocation;
}

@property (nonatomic,retain) NSString *htmlInstructions;
@property (nonatomic,retain) NSNumber *distanceValue;
@property (nonatomic,retain) NSNumber *durationValue;
@property (nonatomic,retain) NSString *distanceText;
@property (nonatomic,retain) NSString *durationText;
@property (nonatomic,assign) CLLocationCoordinate2D startLocation;
@property (nonatomic,assign) CLLocationCoordinate2D endLocation;

+ (Step *) parseJsonDico:(NSDictionary *)stepDico;

@end

@interface Leg : NSObject {
    NSArray *steps;
    NSNumber *distanceValue;
    NSString *distanceText;
    NSNumber *durationValue;
    NSString *durationText;
    CLLocationCoordinate2D startLocation;
    CLLocationCoordinate2D endLocation;
    NSString *startAddress;
    NSString *endAddress;
}

@property (nonatomic,retain) NSArray *steps;
@property (nonatomic,retain) NSNumber *distanceValue;
@property (nonatomic,retain) NSString *distanceText;
@property (nonatomic,retain) NSNumber *durationValue;
@property (nonatomic,retain) NSString *durationText;
@property (nonatomic,assign) CLLocationCoordinate2D startLocation;
@property (nonatomic,assign) CLLocationCoordinate2D endLocation;
@property (nonatomic,retain) NSString *startAddress;
@property (nonatomic,retain) NSString *endAddress;

+ (Leg *) parseJsonDico:(NSDictionary *)legDico;

@end
