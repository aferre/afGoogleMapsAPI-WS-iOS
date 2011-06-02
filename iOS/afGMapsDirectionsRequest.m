//
//  afGoogleMapsDIrectionsWS.m
//  g2park
//
//  Created by adrien ferré on 20/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsDirectionsRequest.h"

@implementation afGMapsDirectionsRequest

@synthesize afDelegate,travelMode,avoidMode,waypoints,alternatives;

@synthesize unitsSystem,origin,destination;

#pragma mark ------------------------------------------
#pragma mark ------ INIT
#pragma mark ------------------------------------------

+(id) directionsRequest{
    return [[[self alloc] init] autorelease];
}


-(id) init{
    
    self = [super init];
    
    if (self){
        travelMode = TravelModeDefault;
        avoidMode = AvoidModeNone;
        alternatives = NO;
        unitsSystem = UnitsDefault;
    }
    
    return self;
}
#pragma mark ------------------------------------------
#pragma mark ------ URL COMPUTING
#pragma mark ------------------------------------------

-(NSURL *) makeURL{
    
    NSString *rootURL = [super getURLString];
    
    rootURL = [rootURL stringByAppendingFormat:@"%@",GOOGLE_DIRECTIONS_API_PATH_COMPONENT];
    
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
    
    //origin
    rootURL = [rootURL stringByAppendingFormat:@"origin=%@",origin];
    //destination
    rootURL = [rootURL stringByAppendingFormat:@"&destination=%@",destination];
    
    //mode
    if (travelMode != TravelModeDefault)
        rootURL = [rootURL stringByAppendingFormat:@"&mode=%@",[self travelModeString]];
    
    //waypoints
    if ([waypoints count]>=1) {
        rootURL = [rootURL stringByAppendingFormat:@"&waypoints="];
        
        int i = 0;
        for (NSString *waypoint in waypoints) {
            i++;
            if (i == [waypoints count])
                rootURL = [rootURL stringByAppendingFormat:@"%@",waypoint];
            else
                rootURL = [rootURL stringByAppendingFormat:@"%@|",waypoint];
        }
    }    
    //alternatives
    if (alternatives)
        rootURL = [rootURL stringByAppendingFormat:@"&alternatives=true"];
    
    //avoid
    if (avoidMode != AvoidModeNone)
        rootURL = [rootURL stringByAppendingFormat:@"&avoid=%@",[afGoogleMapsAPIRequest avoidMode:avoidMode]];
    
    //units
    if (unitsSystem != UnitsDefault)
        switch (unitsSystem) {
            case UnitsImperial:
                rootURL = [rootURL stringByAppendingFormat:@"&units=imperial"];
                break;
                
            case UnitsMetric:
                rootURL = [rootURL stringByAppendingFormat:@"&units=metric"];
                break;
                
            default:
                break;
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
    
    return [NSURL URLWithString:rootURL];
}


#pragma mark ------------------------------------------
#pragma mark ------ ASI HTTP REQUEST Overrides
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
#pragma mark ------ ASI HTTP REQUEST Delegate functions
#pragma mark ------------------------------------------

-(void) request:(ASIHTTPRequest *)req 
 didReceiveData:(NSData *)data{
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (WS_DEBUG) NSLog(@"Request received data %@",jsonString);
    
    [resStr appendString:jsonString];
    [jsonString release];
}

-(void) request:(ASIHTTPRequest *)req didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
}

-(void) request:(ASIHTTPRequest *)req willRedirectToURL:(NSURL *)newURL{
    
}

-(void) requestFailed:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request failed");
    NSLog(@"%@ %@",[[req error]localizedDescription], [[req error] localizedFailureReason]);
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDirectionsWSFailed:withError:)]){
        [afDelegate afDirectionsWSFailed:self withError:[[self error] localizedDescription]];
    }
}

-(void) requestFinished:(ASIHTTPRequest *)req{
    
    if (WS_DEBUG) NSLog(@"Request finished");
    
    /* NSDictionary *results = [resStr JSONValue];
     
     NSString *status = [results objectForKey:@"status"];
     if ([status isEqualToString:@"ZERO_RESULTS"] || [status isEqualToString:@"NOT_FOUND"] ){
     if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDirectionsWSFailed:withError:)]){
     [afDelegate afDirectionsWSFailed:self withError:status];
     }
     return;
     }
     
     //Now we need to obtain our coordinates
     NSArray *placemark  = [results objectForKey:@"results"];
     
     if (WS_DEBUG)    
     NSLog(@"%d objects", [placemark count]);
     
     
     NSDictionary *dico = [placemark objectAtIndex:0];
     
     if (WS_DEBUG)    
     for (id object in dico){
     NSLog(@"%@",object);
     }
     
     NSDictionary *geoDico = [dico objectForKey:@"geometry"];
     
     double longitude = [[[geoDico objectForKey:@"location"] objectForKey:@"lng"] doubleValue];
     double latitude = [[[geoDico objectForKey:@"location"] objectForKey:@"lat"] doubleValue];
     
     if (WS_DEBUG)
     NSLog(@"Latitude - Longitude: %f %f", latitude, longitude);
     
     if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWS:gotLatitude:andLongitude:)]){
     [afDelegate afGeocodingWS:self gotLatitude:latitude andLongitude:longitude];
     }
     
     
     */
    
    
    
    
    
    SBJsonParser *json;
    NSError *jsonError;
    NSDictionary *jsonResults;
    
    // Init JSON
    json = [ [ SBJsonParser new ] autorelease ];
    
    // Get result in a NSDictionary
    jsonResults = [ json objectWithString:resStr error:&jsonError ];
    
    // Check if there is an error
    if (jsonResults == nil) {
        
        NSLog(@"Erreur lors de la lecture du code JSON (%@).", [ jsonError localizedDescription ]);
        
    } else {
        NSString *status = [jsonResults objectForKey:@"status"];
        if ([status isEqualToString:@"ZERO_RESULTS"] || [status isEqualToString:@"NOT_FOUND"] ){
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDirectionsWSFailed:withError:)]){
                [afDelegate afDirectionsWSFailed:self withError:status];
            }
            return;
        }
        
        NSArray *routesArr = [jsonResults objectForKey:@"routes"];
        
        NSDictionary *routesDico = [routesArr objectAtIndex:0];
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWS:gotRoute:)]){
            [afDelegate afGeocodingWS:self gotRoute:routesDico];
        }
        /*
         NSArray *legsArray = [routesDico objectForKey:@"legs"];
         
         NSDictionary *legsDico = [legsArray objectAtIndex:0];
         
         NSArray *stepsArray = [legsDico objectForKey:@"steps"];
         
         MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * stepsArray.count);
         CLLocationDegrees latitude;
         CLLocationDegrees longitude;
         #if TARGET_IPHONE_SIMULATOR
         latitude = 48.5;
         longitude = 2.37;
         #else
         latitude = self.mapView.userLocation.location.coordinate.latitude;
         longitude = self.mapView.userLocation.location.coordinate.longitude;
         #endif
         CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
         
         MKMapPoint point = MKMapPointForCoordinate(coordinate);
         
         pointArr[0] = point;
         int i=1;
         for (NSDictionary *stepDico in stepsArray){
         // NSDictionary *start=[stepDico objectForKey:@"start_location"];
         NSDictionary *end=[stepDico objectForKey:@"end_location"];
         
         latitude = [[end objectForKey:@"lat"] doubleValue];
         longitude = [[end objectForKey:@"lng"] doubleValue];
         
         // create our coordinate and add it to the correct spot in the array
         coordinate = CLLocationCoordinate2DMake(latitude, longitude);
         
         // point = MKMapPointMake([[end objectForKey:@"lat"] doubleValue], [[end objectForKey:@"lng"] doubleValue]);
         point = MKMapPointForCoordinate(coordinate);
         pointArr[i] = point;
         i++;
         }
         
         self.routeLine = [MKPolyline polylineWithPoints:pointArr count:stepsArray.count];
         [self.mapView addOverlay:self.routeLine];
         free(pointArr);
         */
    }
}

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    resStr = [[NSMutableString alloc] init];
    
    if (WS_DEBUG) NSLog(@"Request started");
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDirectionsWSStarted:)]){
        [afDelegate afDirectionsWSStarted:self];
    }
}

@end
