//
//  afGMapsElevationRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "afGoogleMapsAPIRequest.h"

#define GOOGLE_ELEVATION_API_PATH_COMPONENT @"directions"

@protocol afGoogleMapsElevationDelegate;

@interface afGMapsElevationRequest : afGoogleMapsAPIRequest {
    
    id<afGoogleMapsElevationDelegate>  afDelegate;
    
    NSArray *locations;
    
    NSArray *path;
    
    NSArray *samples;
    
}

@property (nonatomic,assign) id<afGoogleMapsElevationDelegate> afDelegate;

@end
