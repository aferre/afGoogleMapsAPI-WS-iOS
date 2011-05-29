//
//  afGoogleMapsGeocodingWS.h
//  g2park
//
//  Created by adrien ferré on 20/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "afGoogleMapsAPIRequest.h"

#define GOOGLE_GEOCODE_API_PATH_COMPONENT @"geocode"

@protocol afGoogleMapsGeocodingDelegate;

@interface afGMapsGeocodingRequest : afGoogleMapsAPIRequest{
    
    BOOL reverseGeocoding;
    id <afGoogleMapsGeocodingDelegate> afDelegate;
}

@property (nonatomic,assign) id<afGoogleMapsGeocodingDelegate> afDelegate;
@property (nonatomic,assign) BOOL reverseGeocoding;

+ (id) addressForLatitude:(double) lat andLongitude:(double)lng;

- (id) requestAddressForLatitude:(double) lat andLongitude:(double) lng;

- (NSURL *) urlAddressForLatitude:(double) lat andLongitude:(double) lng;

+ (id) coordinatesForAddress:(NSString *)address;

- (id) requestCoordinatesForAddress:(NSString *)address;

- (NSURL *) urlCoordinatesForAddress:(NSString *)address;

@end

@protocol afGoogleMapsGeocodingDelegate <NSObject>

@optional

-(void) afGeocodingWSStarted:(afGMapsGeocodingRequest *)ws ;

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotLatitude:(double) latitude andLongitude:(double)longitude;

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotAddress:(NSString *)address;

-(void) afGeocodingWSFailed:(afGMapsGeocodingRequest *)ws withError:(NSString *)er;

@end