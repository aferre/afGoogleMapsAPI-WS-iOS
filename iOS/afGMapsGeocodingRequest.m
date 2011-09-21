//
//  afGoogleMapsGeocodingWS.m
//  g2park
//
//  Created by adrien ferré on 20/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsGeocodingRequest.h"
#import "ASIHTTPRequest.h"

@implementation afGMapsGeocodingRequest

@synthesize reverseGeocoding, afDelegate,address,latlng,boundsP1,boundsP2,useBounds;

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
    self.address = [NSString stringWithString:[taddress stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
}

-(void) setLatitude:(double)lat andLongitude:(double)lng{
    reverseGeocoding = YES;
    latlng = [NSString stringWithFormat:@"%f,%f",lat,lng];    
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
        rootURL = [rootURL stringByAppendingFormat:@"latlng=%@",latlng];
    }
    else{
        //adress to latlng
        rootURL = [rootURL stringByAppendingFormat:@"address=%@",address];
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
    
    return [NSURL URLWithString:rootURL];
    
}

#pragma mark ------------------------------------------
#pragma mark ------ ASI HTTP REQUEST DELEGATE FUNCTIONS
#pragma mark ------------------------------------------

-(void) request:(ASIHTTPRequest *)req didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
}

-(void) request:(ASIHTTPRequest *)req willRedirectToURL:(NSURL *)newURL{
    
}

-(void) requestFailed:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request failed");
    NSLog(@"%@ %@",[[req error]localizedDescription], [[req error] localizedFailureReason]);
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWSFailed:withError:)]){
        [afDelegate afGeocodingWSFailed:self withError:[self error]];
    }
}

-(void) requestFinished:(ASIHTTPRequest *)req{
    
    if (WS_DEBUG) NSLog(@"Request finished");
    
    NSString *jsonString = [[NSString alloc] initWithData:[req responseData] encoding:NSUTF8StringEncoding];
    
    jsonResult = [[jsonString JSONValue] copy];
    
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
            
            [afDelegate afGeocodingWSFailed:self withError:[NSError errorWithDomain:@"GoogleMaps Geocoding API Error" code:666 userInfo:errorInfo]];
        }
        return;
    }
    
    //
    //DATA PROCESSING
    //
    
    //Now we need to obtain our coordinates
    NSArray *results  = [jsonResult objectForKey:@"results"];
    
    if (WS_DEBUG)    
        NSLog(@"%d objects", [results count]);
    
    if (reverseGeocoding){
        NSMutableString *ad = [NSMutableString string];
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWS:gotAddress:)]){
            [afDelegate afGeocodingWS:self gotAddress:ad];
        }
    }
    else{
        
        int i ;
        
        for (i = 0 ; i<[results count] ; i++){
            NSDictionary *result = [results objectAtIndex:i];
            
            NSString *formattedAddress = [result objectForKey:@"formatted_address"];
            
            NSArray *resultTypesStringArray = [result objectForKey:@"types"];
            NSMutableArray *resultsTypesArray = [NSMutableArray arrayWithCapacity:[resultTypesStringArray count]];
            NSArray *addressComponentsArray = [result objectForKey:@"address_components"];
            NSMutableArray *addressComponents = [NSMutableArray array];
            for (NSString *type in resultTypesStringArray){
                AddressComponentType addressType = [self addressComponentTypeFromString:type];
                NSNumber *addressTypeNumber = [NSNumber numberWithInt:[self addressComponentTypeFromString:type]];
                [resultsTypesArray addObject:addressTypeNumber];
            }
            
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
            
            if (WS_DEBUG)
                NSLog(@"Latitude - Longitude: %f %f",geometry.location.latitude, geometry.location.longitude);
            
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWS:gotLatitude:andLongitude:)]){
                [afDelegate afGeocodingWS:self gotLatitude:latitude andLongitude:longitude];
            }
        }
        
        
    }
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
    return nil;
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
    return nil;
}

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request started");
   
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWSStarted:)]){
        [afDelegate afGeocodingWSStarted:self];
    }
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

@synthesize location,locationType,viewportNE,viewportSW;

-(void)dealloc{
    [location release];
    location = nil;
    [viewportNE release];
    viewportNE = nil;
    [viewportSW release];
    viewportSW = nil;
    
    
    [super dealloc];
}

@end
