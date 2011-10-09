//
//  afGoogleMapsGeocodingWS.h
//  g2park
//
//  Created by adrien ferré on 20/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGoogleMapsAPIRequest.h"
#import "Geometry.h"
#import "AddressComponent.h"

#define GOOGLE_GEOCODING_API_PATH_COMPONENT @"geocode"

@protocol afGoogleMapsGeocodingDelegate;
@class Result;

@interface afGMapsGeocodingRequest : afGoogleMapsAPIRequest{
    
    id <afGoogleMapsGeocodingDelegate> afDelegate;
    
    BOOL reverseGeocoding;
    
    BOOL useBounds;
    
    //provided
    NSString *providedAddress;
    
    CLLocationCoordinate2D providedCoordinates;
    
    CGPoint boundsP1;
    
    CGPoint boundsP2;
}

@property (nonatomic,assign) id<afGoogleMapsGeocodingDelegate> afDelegate;
@property (nonatomic,assign) BOOL reverseGeocoding;
@property (nonatomic,assign) BOOL useBounds;
@property (nonatomic,retain) NSString *providedAddress;
@property (nonatomic,assign) CGPoint boundsP1;
@property (nonatomic,assign) CGPoint boundsP2;
@property (nonatomic,assign) CLLocationCoordinate2D providedCoordinates;

+ (id) request;

- (id) initDefault;

- (NSURL *) makeURL;

- (void) setBoundsUpperLeft:(CGPoint) p1 downRight:(CGPoint)p2;

- (void) setLatitude:(double)lat andLongitude:(double)lng;

- (void) setTheAddress:(NSString *)taddress;

@end

@protocol afGoogleMapsGeocodingDelegate <NSObject>

@required

@optional

-(void) afGeocodingWSStarted:(afGMapsGeocodingRequest *)ws;

-(void) afGeocodingWSFailed:(afGMapsGeocodingRequest *)ws withError:(NSError *)er;

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotCoordinates:(CLLocationCoordinate2D) coordinates fromAddress:(NSString *)address;

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotMultipleCoordinates:(NSArray *)coordinates fromAddress:(NSString *)address;

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotAddress:(NSString *)address fromLatitude:(double)latitude andLongitude:(double)longitude;

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotMultipleAddresses:(NSArray *)addresses fromLatitude:(double)latitude andLongitude:(double)longitude;

@end

@interface Result : NSObject {
    NSArray *types;
    NSString *formattedAddress;
    NSArray *addressComponents;
    Geometry *geometry;
}

@property (nonatomic,retain) NSArray *types;
@property (nonatomic,retain) NSString *formattedAddress;
@property (nonatomic,retain) NSArray *addressComponents;
@property (nonatomic,retain) Geometry *geometry;

+ (Result *) parseJsonDico:(NSDictionary *)jsonDico;
@end