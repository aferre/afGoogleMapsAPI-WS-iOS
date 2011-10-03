//
//  AddressComponent.h
//  afGMDemo
//
//  Created by adrien ferré on 02/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface AddressComponent : NSObject {
    NSArray *componentTypes;
    NSString *longName;
    NSString *shortName;
}
@property (nonatomic,retain) NSString * longName;
@property (nonatomic,retain) NSString *shortName;
@property (nonatomic,retain) NSArray *componentTypes;

+ (AddressComponent *) parseJsonDico:(NSDictionary *)jsonDico;
@end
