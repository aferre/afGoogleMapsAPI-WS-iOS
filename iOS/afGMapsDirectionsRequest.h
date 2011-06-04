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

/*mode (optional, defaults to driving) — specifies what mode of transport to use when calculating directions. Valid values are specified in Travel Modes.
 
 waypoints (optional) specifies an array of waypoints. Waypoints alter a route by routing it through the specified location(s). A waypoint is specified as either a latitude/longitude coordinate or as an address which will be geocoded. (For more information on waypoints, see Using Waypoints in Routes below.)
 
 alternatives (optional), if set to true, specifies that the Directions service may provide more than one route alternative in the response. Note that providing route alternatives may increase the response time from the server.
 
 avoid (optional) indicates that the calculated route(s) should avoid the indicated features. Currently, this parameter supports the following two arguments:
 tolls indicates that the calculated route should avoid toll roads/bridges.
 highways indicates that the calculated route should avoid highways.
 (For more information see Route Restrictions below.)
 
 units (optional) — specifies what unit system to use when displaying results. Valid values are specified in Unit Systems below.
 
 region (optional) — The region code, specified as a ccTLD ("top-level domain") two-character value. (For more information see Region Biasing below.)
 
 language (optional) — The language in which to return results. See the supported list of domain languages. Note that we often update supported languages so this list may not be exhaustive. If language is not supplied, the Directions service will attempt to use the native language of the browser wherever possible. See Region Biasing for more information.
 
 sensor (required) — Indicates whether or not the directions request comes from a device with a location sensor. This value must be either true or false.*/

@interface afGMapsDirectionsRequest : afGoogleMapsAPIRequest {
    
    id<afGoogleMapsDirectionsDelegate>  afDelegate;
    
    NSString *origin;
    
    NSString *destination;
    
    TravelMode travelMode;
    
    AvoidMode avoidMode;
    
    NSArray *waypoints;
    
    BOOL alternatives;
    
    UnitsSystem unitsSystem;
}

@property (nonatomic,assign) id<afGoogleMapsDirectionsDelegate> afDelegate;
@property (nonatomic,assign) TravelMode travelMode;
@property (nonatomic,assign) AvoidMode avoidMode;
@property (nonatomic,retain) NSArray *waypoints;
@property (nonatomic,assign) BOOL alternatives;
@property (nonatomic,assign) UnitsSystem unitsSystem;
@property (nonatomic,assign) NSString *origin;
@property (nonatomic,assign) NSString *destination;

+(id) directionsRequest;

-(id) initDefault;

@end

@protocol afGoogleMapsDirectionsDelegate <NSObject>

@optional

-(void) afDirectionsWSStarted:(afGMapsDirectionsRequest *)ws ;

-(void) afDirectionsWS:(afGMapsDirectionsRequest *)ws gotResult:(NSDictionary *)res;

-(void) afDirectionsWSFailed:(afGMapsDirectionsRequest *)ws withError:(NSString *)er;

@end