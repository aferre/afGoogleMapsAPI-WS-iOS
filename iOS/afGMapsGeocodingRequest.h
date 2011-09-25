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

typedef enum AddressComponentType { 
    AddressComponentTypeStreetAddress = 0,
    AddressComponentTypeRoute,
    AddressComponentTypeIntersection,
    AddressComponentTypePolitical,
    AddressComponentTypeCountry,
    AddressComponentTypeAdministrativeAreaLevel1,
    AddressComponentTypeAdministrativeAreaLevel2,
    AddressComponentTypeAdministrativeAreaLevel3,
    AddressComponentTypeColloquialArea,
    AddressComponentTypeLocality,
    AddressComponentTypeSublocality,
    AddressComponentTypeNeighborhood,
    AddressComponentTypePremise,
    AddressComponentTypeSubpremise,
    AddressComponentTypePostalCode,
    AddressComponentTypeNaturalFeature,
    AddressComponentTypeAirport,
    AddressComponentTypePark,
    AddressComponentTypePointOfInterest,
    AddressComponentTypePostBox,
    AddressComponentTypeStreetNumber,
    AddressComponentTypeFloor,
    AddressComponentTypeRoom
} AddressComponentType;

typedef enum LocationType { 
    LocationTypeRooftop = 0,
    LocationTypeRangeInterpolated,
    LocationTypeGeometricCenter,
    LocationTypeApproximate
} LocationType;

@protocol afGoogleMapsGeocodingDelegate;

@interface afGMapsGeocodingRequest : afGoogleMapsAPIRequest{
    
    id <afGoogleMapsGeocodingDelegate> afDelegate;
    
    BOOL reverseGeocoding;
    
    NSString *address;
    
    NSString *latlng;
    
    BOOL useBounds;
    
    CGPoint boundsP1;
    
    CGPoint boundsP2;
    
    CLLocationCoordinate2D providedCoordinates;
}

@property (nonatomic,assign) id<afGoogleMapsGeocodingDelegate> afDelegate;
@property (nonatomic,assign) BOOL reverseGeocoding;
@property (nonatomic,assign) BOOL useBounds;
@property (nonatomic,retain) NSString *address;
@property (nonatomic,retain) NSString *latlng;
@property (nonatomic,assign) CGPoint boundsP1;
@property (nonatomic,assign) CGPoint boundsP2;
@property (nonatomic,assign) CLLocationCoordinate2D providedCoordinates;

+ (id) geocodingRequest;

- (id) initDefault;

+ (id) addressForLatitude:(double) lat andLongitude:(double)lng;

- (id) requestAddressForLatitude:(double) lat andLongitude:(double) lng;

+ (id) coordinatesForAddress:(NSString *)address;

- (id) requestCoordinatesForAddress:(NSString *)address;

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

@interface AddressComponent : NSObject {
    NSArray *componentTypes;
    NSString *longName;
    NSString *shortName;
}
@property (nonatomic,retain) NSString * longName;
@property (nonatomic,retain) NSString *shortName;
@property (nonatomic,retain) NSArray *componentTypes;
@end

@interface Geometry : NSObject {
    LocationType locationType;
    CLLocationCoordinate2D location;
    CLLocationCoordinate2D viewportSW;
    CLLocationCoordinate2D viewportNE;
    CLLocationCoordinate2D boundsSW;
    CLLocationCoordinate2D boundsNE;
}

@property (nonatomic,assign) CLLocationCoordinate2D location;
@property (nonatomic,assign) CLLocationCoordinate2D viewportSW;
@property (nonatomic,assign) CLLocationCoordinate2D viewportNE;
@property (nonatomic,assign) CLLocationCoordinate2D boundsSW;
@property (nonatomic,assign) CLLocationCoordinate2D boundsNE;
@property (nonatomic,assign) LocationType locationType;
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
@end