//
//  afGMapsElevationRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGoogleMapsAPIRequest.h"

#define GOOGLE_ELEVATION_API_ELEVATION_COMPONENT @"elevation"

@protocol afGoogleMapsElevationDelegate;

@interface afGMapsElevationRequest : afGoogleMapsAPIRequest {
    
    id<afGoogleMapsElevationDelegate>  afDelegate;
    
    //provided
    NSMutableArray *locations;
    
    NSMutableArray *path;
    
    NSInteger pathNumber;
    
    //returned
    NSMutableArray *elevations;
}

@property (nonatomic,assign) id<afGoogleMapsElevationDelegate> afDelegate;

@property (nonatomic,retain) NSMutableArray *locations;

@property (nonatomic,retain) NSMutableArray *path;

@property (nonatomic,retain) NSMutableArray *elevations;

@property (nonatomic,assign) NSInteger pathNumber;
@end

@protocol afGoogleMapsElevationDelegate <NSObject>
@optional
-(void) afElevationWSStarted:(afGMapsElevationRequest *)ws ;

-(void)  afElevationWSFailed:(afGMapsElevationRequest *)ws withError:(NSError *)er;

-(void)  afElevationWS:(afGMapsElevationRequest *)ws gotElevation:(NSNumber *)elevation forLocation:(CLLocation *)location;

-(void)  afElevationWS:(afGMapsElevationRequest *)ws gotResults:(NSArray *) results;

@end