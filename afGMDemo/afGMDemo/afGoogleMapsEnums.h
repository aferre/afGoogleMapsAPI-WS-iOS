//
//  afGoogleMapsEnums.h
//  afGMDemo
//
//  Created by adrien ferré on 08/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "afEnum.h"

enum { 
    UnitsDefault, // default is meters
    UnitsMetric,
    UnitsImperial
};
typedef NSInteger UnitSystem;
static NSInteger UnitSystemNumber = 3;
static NSString *UnitSystemAsStrings[] = {[UnitsDefault] = @"meter",[UnitsMetric] = @"meter",[UnitsImperial] = @"mile"};

enum { 
    AvoidModeHighway,
    AvoidModeTolls,
    AvoidModeNone
};
typedef NSInteger AvoidMode;
static NSInteger AvoidModeNumber = 3;
static NSString *AvoidModeAsStrings[] = {[AvoidModeHighway] = @"highways",[AvoidModeTolls] = @"tolls",[AvoidModeNone] = @"none"};

enum { 
    TravelModeDriving,
    TravelModeWalking,
    TravelModeBicycling,
    TravelModeDefault
};
typedef NSInteger TravelMode;
static NSInteger TravelModeNumber = 4;
static NSString *TravelModeAsStrings[] = {[TravelModeDriving] = @"driving",[TravelModeWalking] = @"walking",[TravelModeBicycling] = @"bicycling", [TravelModeDefault] = @"driving"};

enum { 
    JSON,
    XML
};
typedef NSInteger ReturnFormat;
static NSInteger ReturnFormatNumber = 2;
static NSString *ReturnFormatAsStrings[] = {[JSON] = @"json",[XML] = @"xml"};

@interface afGoogleMapsEnums : NSObject

DECLARE_ENUM(UnitSystem)
DECLARE_ENUM(AvoidMode)
DECLARE_ENUM(TravelMode)
DECLARE_ENUM(ReturnFormat)

@end