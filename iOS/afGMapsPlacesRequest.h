//
//  afGMapsPlacesRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "afGoogleMapsAPIRequest.h"

#define GOOGLE_PLACES_API_PATH_COMPONENT @"directions"
#define API_KEY @"AIzaSyCA944VvzTcPpT4mM4PG-ibNPXkLt0fGiU"

@protocol afGoogleMapsPlacesDelegate;

@interface afGMapsPlacesRequest : afGoogleMapsAPIRequest {
    
    id<afGoogleMapsPlacesDelegate>  afDelegate;
    
}

@property (nonatomic,assign) id<afGoogleMapsPlacesDelegate> afDelegate;

@end
