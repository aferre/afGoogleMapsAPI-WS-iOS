//
//  afGMapsElevationRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGoogleMapsAPIRequest.h"

#define GOOGLE_ELEVATION_API_PATH_COMPONENT @"elevation"

@protocol afGoogleMapsElevationDelegate;

@interface afGMapsElevationRequest : afGoogleMapsAPIRequest {
    
    id<afGoogleMapsElevationDelegate>  afDelegate;
    
    NSArray *locations;
    
    NSArray *path;
    
    NSArray *samples;
    
}

@property (nonatomic,assign) id<afGoogleMapsElevationDelegate> afDelegate;

@end
