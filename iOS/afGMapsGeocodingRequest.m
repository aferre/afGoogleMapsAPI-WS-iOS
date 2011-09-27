//
//  afGoogleMapsGeocodingWS.m
//  g2park
//
//  Created by adrien ferré on 20/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsGeocodingRequest.h"
#import "ASIHTTPRequest.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@implementation afGMapsGeocodingRequest

@synthesize reverseGeocoding, afDelegate,providedAddress,boundsP1,boundsP2,useBounds,providedCoordinates;

#pragma mark ------------------------------------------
#pragma mark ------ INIT
#pragma mark ------------------------------------------

+(id) geocodingRequest{
    return [[[self alloc] initDefault] autorelease];
}

-(id) initDefault{
    self = [super initDefault];
    
    if (self){
        [self setUserInfo: [NSDictionary dictionaryWithObject:@"geocoding" forKey:@"type"]];
        useBounds = NO;
        self.delegate = self;
    }
    
    return self;
}

+(id) addressForLatitude:(double) lat andLongitude:(double)lng{
    
    return [[[self alloc] requestAddressForLatitude:lat andLongitude:lng] autorelease];
}

- (id) requestAddressForLatitude:(double) lat andLongitude:(double) lng{
    self = [self init];
    
    if (self){
        [self setLatitude:lat andLongitude:lng];    
    }
    
    return self;
}

+(id) coordinatesForAddress:(NSString *)address{
    
    return [[[self alloc] requestCoordinatesForAddress:address] autorelease];
}

- (id) requestCoordinatesForAddress:(NSString *)taddress{
    
    self = [self init];
    
    if (self){
        [self setTheAddress:taddress];
    }
    
    return self;
}

#pragma mark ------------------------------------------
#pragma mark ------ Helpers
#pragma mark ------------------------------------------

-(void) setTheAddress:(NSString *)taddress{
    reverseGeocoding = NO;
    self.providedAddress = taddress;
}

-(void) setLatitude:(double)lat andLongitude:(double)lng{
    reverseGeocoding = YES;
    providedCoordinates = CLLocationCoordinate2DMake(lat, lng);
}

-(void) setBoundsUpperLeft:(CGPoint) p1 downRight:(CGPoint)p2{
    useBounds = YES;
    self.boundsP1 = p1;
    self.boundsP2 = p2;
}

#pragma mark ------------------------------------------
#pragma mark ------ ASI HTTP OVERRIDES
#pragma mark ------------------------------------------

-(void) startAsynchronous{
    [self setURL:[self makeURL]];
    [super startAsynchronous];
}

-(void) startSynchronous{
    
    [self setURL:[self makeURL]];
    [super startSynchronous];
}

#pragma mark ------------------------------------------
#pragma mark ------ URL COMPUTING
#pragma mark ------------------------------------------

-(NSURL *) makeURL{
    NSString *rootURL = [self getURLString];
    
    rootURL = [rootURL stringByAppendingFormat:@"%@",GOOGLE_GEOCODING_API_PATH_COMPONENT];
    
    switch (format) {
        case ReturnJSON:
        {
            rootURL = [rootURL stringByAppendingFormat:@"/json?"];
        }
            break;
        case ReturnXML:
        {
            rootURL = [rootURL stringByAppendingFormat:@"/xml?"];
        }
            break;
        default:
        {
            rootURL = [rootURL stringByAppendingFormat:@"/json?"];
        }
            break;
    }
    
    if (reverseGeocoding){
        //latlng to address
        rootURL = [rootURL stringByAppendingFormat:@"latlng=%@",[NSString stringWithFormat:@"%f,%f",providedCoordinates.latitude,providedCoordinates.longitude]];
    }
    else{
        //adress to latlng
        rootURL = [rootURL stringByAppendingFormat:@"address=%@",providedAddress];
    }
    
    //bounds
    if (useBounds){
        rootURL = [rootURL stringByAppendingFormat:@"&bounds=%d,%d|%d,%d",boundsP1.x ,boundsP1.y , boundsP2.x,boundsP2.y];
    }
    
    //region
    if (region != ccTLD_DEFAULT)
        rootURL = [rootURL stringByAppendingFormat:@"&region=%@",[afGoogleMapsAPIRequest regionCode:region]];
    
    //language
    if (language != LangDEFAULT)
        rootURL = [rootURL stringByAppendingFormat:@"&language=%@",[afGoogleMapsAPIRequest languageCode:language]];
    
    //sensor
    if (useSensor) 
        rootURL = [rootURL stringByAppendingFormat:@"&sensor=true"];
    else
        rootURL = [rootURL stringByAppendingFormat:@"&sensor=false"];
    
    NSLog(@"URL is %@",rootURL);
    
    return [super finalizeURLString:rootURL];
    
}

#pragma mark ------------------------------------------
#pragma mark ------ ASI HTTP REQUEST DELEGATE FUNCTIONS
#pragma mark ------------------------------------------

-(void) request:(ASIHTTPRequest *)req didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
}

-(void) request:(ASIHTTPRequest *)req willRedirectToURL:(NSURL *)newURL{
    
}

-(void) requestFailed:(ASIHTTPRequest *)req{
    if (WS_DEBUG) {
        NSLog(@"Request failed");
        NSLog(@"%@ %@",[[req error]localizedDescription], [[req error] localizedFailureReason]);
    }
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWSFailed:withError:)]){
        [afDelegate afGeocodingWSFailed:self withError:[self error]];
    }
}

-(void) requestFinished:(ASIHTTPRequest *)req{
    
    if (WS_DEBUG) NSLog(@"Request finished %@",[req responseString]);
    
    SBJsonParser *json;
    NSError *jsonError;
    
    json = [ [ SBJsonParser new ] autorelease ];
    
    jsonResult = [[ json objectWithString:[req responseString] error:&jsonError ] copy];
    
    if (jsonResult == nil) {
        NSLog(@"Erreur lors de la lecture du code JSON (%@).", [ jsonError localizedDescription ]);
        
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                                      NSLocalizedString(@"GoogleMaps Geocoding API returned no content",@"")]
                                                              forKey:NSLocalizedDescriptionKey];
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWSFailed:withError:)]){
            [afDelegate afGeocodingWSFailed:self withError:[NSError errorWithDomain:@"GoogleMaps Geocoding API Error" code:CUSTOM_ERROR_NUMBER userInfo:errorInfo]];
        }
        return;
    } 
    else{
        //
        //ERROR CHECK
        //
        NSString *topLevelStatus = [jsonResult objectForKey:@"status"];
        if ([topLevelStatus isEqualToString:@"OK"]){
            
        }
        else {
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWSFailed:withError:)]){
                NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                                              NSLocalizedString(@"GoogleMaps Geocoding API returned status code %@",@""),
                                                                              topLevelStatus]
                                                                      forKey:NSLocalizedDescriptionKey];
                
                [afDelegate afGeocodingWSFailed:self withError:[NSError errorWithDomain:@"GoogleMaps Geocoding API Error" code:CUSTOM_ERROR_NUMBER userInfo:errorInfo]];
            }
            return;
        }
        
        //
        //DATA PROCESSING
        //
        
        //Now we need to obtain our coordinates
        NSArray *gmResults  = [jsonResult objectForKey:@"results"];
        
        if (WS_DEBUG)    
            NSLog(@"%d objects", [gmResults count]);
        
        if ([gmResults count] > 1){
            int i;
            NSMutableArray *custResults = [NSMutableArray arrayWithCapacity:[gmResults count]];
            
            for (i = 0 ; i<[gmResults count] ; i++){
                NSDictionary *jsonResultDico = [gmResults objectAtIndex:i];
                
                Result *result = [self parseJSONResult:jsonResultDico];
                [custResults addObject:result];   
            }
            
            if (reverseGeocoding){
                NSMutableArray *ar = [NSMutableArray arrayWithCapacity:[custResults count]];
                for (i = 0 ; i<[gmResults count] ; i++){
                    [ar addObject:((Result *)[custResults objectAtIndex:i]).formattedAddress];
                } 
                if (WS_DEBUG)
                    NSLog(@"Address: %@ ",ar);
                
                if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWS:gotMultipleAddresses:fromLatitude:andLongitude:)]){
                    
                    [afDelegate afGeocodingWS:self gotMultipleAddresses:ar fromLatitude:providedCoordinates.latitude andLongitude:providedCoordinates.longitude];
                }
            }
            else{
                
                if (WS_DEBUG)
                    NSLog(@"Latitude - Longitude: %f %f",((Result *)[custResults objectAtIndex:0]).geometry.location.latitude, ((Result *)[custResults objectAtIndex:0]).geometry.location.longitude);
                
                if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWS:gotCoordinates:fromAddress:)]){
                    [afDelegate afGeocodingWS:self gotCoordinates:((Result *)[custResults objectAtIndex:0]).geometry.location fromAddress:providedAddress];
                }
            } 
        }
        else if ([gmResults count] == 1){
            Result *result = [self parseJSONResult:[gmResults objectAtIndex:0]];
            
            if (reverseGeocoding){
                if (WS_DEBUG)
                    NSLog(@"Address: %@ ",result.formattedAddress);
                
                if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWS:gotAddress:fromLatitude:andLongitude:)]){
                    [afDelegate afGeocodingWS:self gotAddress:result.formattedAddress fromLatitude:providedCoordinates.latitude andLongitude:providedCoordinates.longitude];
                }
            }
            else{
                if (WS_DEBUG)
                    NSLog(@"Latitude - Longitude: %f %f",result.geometry.location.latitude, result.geometry.location.longitude);
                
                if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWS:gotCoordinates:fromAddress:)]){
                    [afDelegate afGeocodingWS:self gotCoordinates:result.geometry.location fromAddress:providedAddress];
                }
            } 
        }
        else {
            
        }
    }
}

-(Result *)parseJSONResult:(NSDictionary *)result{
    
    Result *res = [[Result alloc] init];
    NSString *formattedAddress = [result objectForKey:@"formatted_address"];
    res.formattedAddress = [formattedAddress copy];
    
    NSArray *resultTypesStringArray = [result objectForKey:@"types"];
    NSMutableArray *resultsTypesArray = [NSMutableArray arrayWithCapacity:[resultTypesStringArray count]];
    NSArray *addressComponentsArray = [result objectForKey:@"address_components"];
    NSMutableArray *addressComponents = [NSMutableArray array];
    
    for (NSString *type in resultTypesStringArray){
        AddressComponentType addressType = [self addressComponentTypeFromString:type];
        NSNumber *addressTypeNumber = [NSNumber numberWithInt:addressType];
        [resultsTypesArray addObject:addressTypeNumber];
    }
    
    res.types = resultsTypesArray;
    
    for (NSDictionary *addressCompDico in addressComponentsArray){
        
        NSString *longName = [addressCompDico objectForKey:@"long_name"];
        NSString *shortName = [addressCompDico objectForKey:@"short_name"];
        NSArray *typesStringArray = [addressCompDico objectForKey:@"types"];
        NSMutableArray *typesArray = [NSMutableArray arrayWithCapacity:[typesStringArray count]];
        
        for (NSString *type in typesStringArray){
            NSNumber *addressTypeNumber = [NSNumber numberWithInt:[self addressComponentTypeFromString:type]];
            [typesArray addObject:addressTypeNumber];
        }
        
        AddressComponent *addressComp = [[AddressComponent alloc] init];
        addressComp.longName = [longName copy];
        addressComp.shortName = [shortName copy];
        addressComp.componentTypes = [NSArray arrayWithArray:typesArray];
        
        [addressComponents addObject:addressComp];
    }
    
    res.addressComponents = addressComponents;
    
    NSDictionary *geoDico = [result objectForKey:@"geometry"];
    
    Geometry *geometry = [[Geometry alloc] init];
    
    double longitude = [[[geoDico objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
    double latitude = [[[geoDico objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
    
    geometry.location = CLLocationCoordinate2DMake(latitude, longitude);
    
    geometry.locationType = [self locationTypeFromString:[geoDico objectForKey:@"location_type"]];
    
    longitude = [[[[geoDico objectForKey:@"viewport"] objectForKey:@"northeast"] objectForKey:@"lng"] doubleValue];
    latitude = [[[[geoDico objectForKey:@"viewport"] objectForKey:@"northeast"] objectForKey:@"lat"] doubleValue];
    
    geometry.viewportNE = CLLocationCoordinate2DMake(latitude, longitude);
    
    longitude = [[[[geoDico objectForKey:@"viewport"] objectForKey:@"southwest"] objectForKey:@"lng"] doubleValue];
    latitude = [[[[geoDico objectForKey:@"viewport"] objectForKey:@"southwest"] objectForKey:@"lat"] doubleValue];
    
    geometry.viewportSW = CLLocationCoordinate2DMake(latitude, longitude);
    
    longitude = [[[[geoDico objectForKey:@"bounds"] objectForKey:@"northeast"] objectForKey:@"lng"] doubleValue];
    latitude = [[[[geoDico objectForKey:@"bounds"] objectForKey:@"northeast"] objectForKey:@"lat"] doubleValue];
    
    geometry.boundsNE = CLLocationCoordinate2DMake(latitude, longitude);
    
    longitude = [[[[geoDico objectForKey:@"bounds"] objectForKey:@"southwest"] objectForKey:@"lng"] doubleValue];
    latitude = [[[[geoDico objectForKey:@"bounds"] objectForKey:@"southwest"] objectForKey:@"lat"] doubleValue];
    
    geometry.boundsSW = CLLocationCoordinate2DMake(latitude, longitude);
    
    res.geometry = geometry;
    [geometry release];
    
    return res;
}

-(LocationType) locationTypeFromString:(NSString *)str{
    if ([str isEqualToString:@"ROOFTOP"]){
        return LocationTypeRooftop;
    } else if ([str isEqualToString:@"RANGE_INTERPOLATED"]){
        return LocationTypeRangeInterpolated;
    } else if ([str isEqualToString:@"GEOMETRIC_CENTER"]){
        return LocationTypeGeometricCenter;
    } else if ([str isEqualToString:@"APPROXIMATE"]){
        return LocationTypeApproximate;
    }  
}

-(AddressComponentType) addressComponentTypeFromString:(NSString *)str{
    
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

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request started");
    
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWSStarted:)]){
        [afDelegate afGeocodingWSStarted:self];
    }
}


-(void) dealloc{
    
    [providedAddress release];
    providedAddress = nil;
    
    [super dealloc];
}
@end

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

@end

@implementation Geometry

@synthesize location,locationType,viewportNE,viewportSW,boundsSW,boundsNE;

-(void)dealloc{
    
    [super dealloc];
}

@end

@implementation Result

@synthesize addressComponents,geometry,formattedAddress,types;

-(void) dealloc{
    
    [addressComponents release];
    addressComponents = nil;
    [geometry release];
    geometry = nil;
    [formattedAddress release];
    formattedAddress = nil;
    [types release];
    types = nil;
    
    [super dealloc];
}

@end
