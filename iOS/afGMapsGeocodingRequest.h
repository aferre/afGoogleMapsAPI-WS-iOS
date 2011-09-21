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

/*
 *
 Address Component Types

 The types[] array within the returned result indicates the address type. These types may also be returned within address_components[] arrays to 
 indicate the type of the particular address component. Addresses within the geocoder may have multiple types; the types may be considered "tags". 
 For example, many cities are tagged with the political and locality type.
 The following types are supported and returned by the HTTP Geocoder:
 
 street_address indicates a precise street address.
 
 route indicates a named route (such as "US 101").
 
 intersection indicates a major intersection, usually of two major roads.
 
 political indicates a political entity. Usually, this type indicates a polygon of some civil administration.
 
 country indicates the national political entity, and is typically the highest order type returned by the Geocoder.
 
 administrative_area_level_1 indicates a first-order civil entity below the country level. Within the United States, these administrative levels are 
 states. Not all nations exhibit these administrative levels.
 
 administrative_area_level_2 indicates a second-order civil entity below the country level. Within the United States, these administrative levels are 
 counties. Not all nations exhibit these administrative levels.
 
 administrative_area_level_3 indicates a third-order civil entity below the country level. This type indicates a minor civil division. Not all nations 
 exhibit these administrative levels.
 
 colloquial_area indicates a commonly-used alternative name for the entity.
 
 locality indicates an incorporated city or town political entity.
 
 sublocality indicates an first-order civil entity below a locality
 
 neighborhood indicates a named neighborhood
 
 premise indicates a named location, usually a building or collection of buildings with a common name
 
 subpremise indicates a first-order entity below a named location, usually a singular building within a collection of buildings with a common name
 
 postal_code indicates a postal code as used to address postal mail within the country.
 
 natural_feature indicates a prominent natural feature.
 
 airport indicates an airport.
 
 park indicates a named park.
 
 point_of_interest indicates a named point of interest. Typically, these "POI"s are prominent local entities that don't easily fit in another category 
 such as "Empire State Building" or "Statue of Liberty."
 
 In addition to the above, address components may exhibit the following types:
 
 post_box indicates a specific postal box.
 
 street_number indicates the precise street number.
 
 floor indicates the floor of a building address.
 
 room indicates the room of a building address.
 *
 */

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

/*
 *
 location_type stores additional data about the specified location. The following values are currently supported:
 "ROOFTOP" indicates that the returned result is a precise geocode for which we have location information accurate down to street address precision.
 "RANGE_INTERPOLATED" indicates that the returned result reflects an approximation (usually on a road) interpolated between two precise points 
 (such as intersections). Interpolated results are generally returned when rooftop geocodes are unavailable for a street address.
 "GEOMETRIC_CENTER" indicates that the returned result is the geometric center of a result such as a polyline (for example, a street) 
 or polygon (region).
 "APPROXIMATE" indicates that the returned result is approximate.
 *
 */
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
}

@property (nonatomic,assign) id<afGoogleMapsGeocodingDelegate> afDelegate;
@property (nonatomic,assign) BOOL reverseGeocoding;
@property (nonatomic,assign) BOOL useBounds;
@property (nonatomic,retain) NSString *address;
@property (nonatomic,retain) NSString *latlng;
@property (nonatomic,assign) CGPoint boundsP1;
@property (nonatomic,assign) CGPoint boundsP2;

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

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotLatitude:(double) latitude andLongitude:(double)longitude;

-(void) afGeocodingWS:(afGMapsGeocodingRequest *)ws gotAddress:(NSString *)address;

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