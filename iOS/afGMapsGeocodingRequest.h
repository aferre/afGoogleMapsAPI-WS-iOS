//
//  afGoogleMapsGeocodingWS.h
//  g2park
//
//  Created by adrien ferré on 20/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "afGoogleMapsAPIRequest.h"

#define GOOGLE_GEOCODING_API_PATH_COMPONENT @"geocode"

@protocol afGoogleMapsGeocodingDelegate;

@interface afGMapsGeocodingRequest : afGoogleMapsAPIRequest{
    
    id <afGoogleMapsGeocodingDelegate> afDelegate;
    
    BOOL reverseGeocoding;
    
    NSString *address;
    
    NSString *latlng;
    
    BOOL useBounds;

    CGPoint boundsP1;
    
    CGPoint boundsP2;
}

@property (nonatomic,assign) id<afGoogleMapsGeocodingDelegate> afDelegate;
@property (nonatomic,assign) BOOL reverseGeocoding;
@property (nonatomic,assign) BOOL useBounds;
@property (nonatomic,assign) NSString *address;
@property (nonatomic,assign) NSString *latlng;
@property (nonatomic,assign) CGPoint boundsP1;
@property (nonatomic,assign) CGPoint boundsP2;

+ (id) geocodingRequest;

- (id) init;

+ (id) addressForLatitude:(double) lat andLongitude:(double)lng;

- (id) requestAddressForLatitude:(double) lat andLongitude:(double) lng;

+ (id) coordinatesForAddress:(NSString *)address;

- (id) requestCoordinatesForAddress:(NSString *)address;

- (NSURL *) makeURL;

- (void) setBoundsUpperLeft:(CGPoint) p1 downRight:(CGPoint)p2;

@end

@protocol afGoogleMapsGeocodingDelegate <NSObject>

@optional

-(void) afGeocodingWSStarted:(afGMapsGeocodingRequest *)ws ;

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotLatitude:(double) latitude andLongitude:(double)longitude;

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotAddress:(NSString *)address;

-(void) afGeocodingWSFailed:(afGMapsGeocodingRequest *)ws withError:(NSString *)er;

@end