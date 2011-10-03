//
//  AddressComponent.m
//  afGMDemo
//
//  Created by adrien ferré on 02/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "AddressComponent.h"

@implementation AddressComponent

@synthesize componentTypes,longName,shortName;

-(void)dealloc{
    [longName release];
    longName = nil;
    [shortName release];
    shortName = nil;
    [componentTypes release];
    componentTypes = nil;
    
    [super dealloc];
}

+(AddressComponentType) addressComponentTypeFromString:(NSString *)str{
    
    if ([str isEqualToString:@"street_address"]){
        return AddressComponentTypeStreetAddress;
    }else if ([str isEqualToString:@"route"]){
        return AddressComponentTypeRoute;
    }else if ([str isEqualToString:@"intersection"]){
        return AddressComponentTypeIntersection;
    }else if ([str isEqualToString:@"political"]){
        return AddressComponentTypePolitical;
    }else if ([str isEqualToString:@"country"]){
        return AddressComponentTypeCountry;
    }else if ([str isEqualToString:@"administrative_area_level_1"]){
        return AddressComponentTypeAdministrativeAreaLevel1;
    }else if ([str isEqualToString:@"administrative_area_level_2"]){
        return AddressComponentTypeAdministrativeAreaLevel2;
    }else if ([str isEqualToString:@"administrative_area_level_3"]){
        return AddressComponentTypeAdministrativeAreaLevel3;
    }else if ([str isEqualToString:@"colloquial_area"]){
        return AddressComponentTypeColloquialArea;
    }else if ([str isEqualToString:@"locality"]){
        return AddressComponentTypeLocality;
    }else if ([str isEqualToString:@"sublocality"]){
        return AddressComponentTypeSublocality;
    }else if ([str isEqualToString:@"neighborhood"]){
        return AddressComponentTypeNeighborhood;
    }else if ([str isEqualToString:@"premise"]){
        return AddressComponentTypePremise;
    }else if ([str isEqualToString:@"subpremise"]){
        return AddressComponentTypeSubpremise;
    }else if ([str isEqualToString:@"postal_code"]){
        return AddressComponentTypePostalCode;
    }else if ([str isEqualToString:@"natural_feature"]){
        return AddressComponentTypeNaturalFeature;
    }else if ([str isEqualToString:@"park"]){
        return AddressComponentTypePark;
    }else if ([str isEqualToString:@"point_of_interest"]){
        return AddressComponentTypePointOfInterest;
    }else if ([str isEqualToString:@"post_box"]){
        return AddressComponentTypePostBox;
    }else if ([str isEqualToString:@"street_number"]){
        return AddressComponentTypeStreetNumber;
    }else if ([str isEqualToString:@"floor"]){
        return AddressComponentTypeFloor;
    }else if ([str isEqualToString:@"room"]){
        return AddressComponentTypeRoom;
    }
}

+ (AddressComponent *) parseJsonDico:(NSDictionary *)jsonDico{
    AddressComponent *addressComp = [[[AddressComponent alloc] init] autorelease];
    NSString *longName = [jsonDico objectForKey:@"long_name"];
    NSString *shortName = [jsonDico objectForKey:@"short_name"];
    NSArray *typesStringArray = [jsonDico objectForKey:@"types"];
    NSMutableArray *typesArray = [NSMutableArray arrayWithCapacity:[typesStringArray count]];
    
    for (NSString *type in typesStringArray){
        NSNumber *addressTypeNumber = [NSNumber numberWithInt:[afGMapsGeocodingRequest addressComponentTypeFromString:type]];
        [typesArray addObject:addressTypeNumber];
    }
    
    addressComp.longName = [longName copy];
    addressComp.shortName = [shortName copy];
    addressComp.componentTypes = [[NSArray alloc] initWithArray:typesArray];
    return addressComp;
}
@end

