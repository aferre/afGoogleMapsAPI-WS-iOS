//
//  AddressComponent.h
//  afGMDemo
//
//  Created by adrien ferré on 02/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "afEnum.h"

enum { 
    AddressComponentTypeStreetAddress,
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
};
typedef NSInteger AddressComponentType;
static NSInteger AddressComponentTypeNumber = 22;
static NSString *AddressComponentTypeAsStrings[] = {
    [AddressComponentTypeStreetAddress] = @"street_ddress",
    [AddressComponentTypeRoute] = @"route",
    [AddressComponentTypeIntersection] = @"intersection",
    [AddressComponentTypePolitical] = @"political",
    [AddressComponentTypeCountry] = @"country",
    [AddressComponentTypeAdministrativeAreaLevel1] = @"administrative_area_level_1",
    [AddressComponentTypeAdministrativeAreaLevel2] = @"administrative_area_level_2",
    [AddressComponentTypeAdministrativeAreaLevel3] = @"administrative_area_level_3",
    [AddressComponentTypeColloquialArea] = @"colloquial_area",
    [AddressComponentTypeLocality] = @"locality",
    [AddressComponentTypeSublocality] = @"sublocality",
    [AddressComponentTypeNeighborhood] = @"neighborhood",
    [AddressComponentTypePremise] = @"premise",
    [AddressComponentTypeSubpremise] = @"subpremise",
    [AddressComponentTypePostalCode] = @"postal_code",
    [AddressComponentTypeNaturalFeature] = @"natural_feature",
    [AddressComponentTypeAirport] = @"airport",
    [AddressComponentTypePark] = @"park",
    [AddressComponentTypePointOfInterest] = @"point_of_interest",
    [AddressComponentTypePostBox] = @"post_box",
    [AddressComponentTypeStreetNumber] = @"street_number",
    [AddressComponentTypeFloor] = @"floor",
    [AddressComponentTypeRoom] = @"room"};

@interface AddressComponent : NSObject {
    NSArray *componentTypes;
    NSString *longName;
    NSString *shortName;
}
@property (nonatomic,retain) NSString * longName;
@property (nonatomic,retain) NSString *shortName;
@property (nonatomic,retain) NSArray *componentTypes;

DECLARE_ENUM(AddressComponentType)

+ (AddressComponent *) parseJsonDico:(NSDictionary *)jsonDico;
@end
