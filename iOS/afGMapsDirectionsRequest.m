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

@synthesize unitsSystem,origin,destination,directionsRequestStatusCode,routes;

#pragma mark ------------------------------------------
#pragma mark ------ INIT
#pragma mark ------------------------------------------

+(id) directionsRequest{
    return [[[self alloc] initDefault] autorelease];
}

-(id) initDefault{
    
    self = [super initDefault];
    
    if (self){
        travelMode = TravelModeDefault;
        avoidMode = AvoidModeNone;
        alternatives = NO;
        unitsSystem = UnitsDefault;
        
        [self setUserInfo: [NSDictionary dictionaryWithObject:@"directions" forKey:@"type"]];
        self.delegate = self;
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
    rootURL = [rootURL stringByAppendingFormat:@"origin=%@",[origin stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    //destination
    rootURL = [rootURL stringByAppendingFormat:@"&destination=%@",[destination stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    //mode
    if (travelMode != TravelModeDefault)
        rootURL = [rootURL stringByAppendingFormat:@"&mode=%@",[afGoogleMapsAPIRequest travelMode:travelMode]];
    
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
    
    NSLog(@"URL is %@",rootURL);
    
    return [super finalizeURLString:rootURL];
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

-(void) request:(ASIHTTPRequest *)req didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
}

-(void) request:(ASIHTTPRequest *)req willRedirectToURL:(NSURL *)newURL{
    
}

-(void) requestFailed:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request failed");
    NSLog(@"%@ %@",[[req error]localizedDescription], [[req error] localizedFailureReason]);
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDirectionsWSFailed:withError:)]){
        [afDelegate afDirectionsWSFailed:self withError:[self error]];
    }
}

-(void) requestFinished:(ASIHTTPRequest *)req{
    
    if (WS_DEBUG) NSLog(@"Request finished with data %@",[req responseString]);
    
    SBJsonParser *json;
    NSError *jsonError;
    
    // Init JSON
    json = [ [ SBJsonParser new ] autorelease ];
    
    if (jsonResult != nil) {
        [jsonResult release];
        jsonResult = nil;
    }
    
    jsonResult = [[ json objectWithString:[req responseString] error:&jsonError ] copy];
    
    // Check if there is an error
    if (jsonResult == nil) {
        
        NSLog(@"Error when reading JSON (%@).", [ jsonError localizedDescription ]);
        
        NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                                      NSLocalizedString(@"GoogleMaps Directions API returned no content@",@"")]
                                                              forKey:NSLocalizedDescriptionKey];
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDirectionsWSFailed:withError:)]){
            [afDelegate afDirectionsWSFailed:self withError:[NSError errorWithDomain:@"GoogleMaps Geocoding API Error" code:CUSTOM_ERROR_NUMBER userInfo:errorInfo]];
        }
        return;
    } else {
        NSString *status = [jsonResult objectForKey:@"status"];
        if (![status isEqualToString:@"OK"] ){
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                                          NSLocalizedString(@"GoogleMaps Directions API returned status code %@",@""),
                                                                          status]
                                                                  forKey:NSLocalizedDescriptionKey];
            
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDirectionsWSFailed:withError:)]){
                [afDelegate afDirectionsWSFailed:self withError:[NSError errorWithDomain:@"GoogleMaps Geocoding API Error" code:CUSTOM_ERROR_NUMBER userInfo:errorInfo]];
            }
            return;
        }
        
        
        NSArray *routesJsonArr = [jsonResult objectForKey:@"routes"];
        NSMutableArray *returnedRoutes = [NSMutableArray arrayWithCapacity:[routesJsonArr count]];
        
        for (NSDictionary *routeJsonDico in routesJsonArr) {
            
            Route *route = [Route parseJsonDico:routeJsonDico];
            [returnedRoutes addObject:route];
        }
        
        self.routes = [[NSArray alloc] initWithArray:returnedRoutes];
        NSLog(@"Retrieved %u routes",[routes count]);
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDirectionsWS:gotRoutes:)])
            [afDelegate afDirectionsWS:self gotRoutes:self.routes];
    }
}

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request started");
    
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDirectionsWSStarted:)]){
        [afDelegate afDirectionsWSStarted:self];
    }
}

-(void) dealloc{
    
    afDelegate = nil;
    
    [routes release];
    routes = nil;
    
    [destination release];
    destination = nil;
    
    [origin release];
    origin = nil;
    
    [waypoints release];
    waypoints = nil;
    
    [super dealloc];
}
@end

@implementation Step

@synthesize htmlInstructions,endLocation,durationValue,distanceValue,startLocation,distanceText,durationText;

+(Step *)parseJsonDico:(NSDictionary *) stepDico{
    
    Step *s = [[[self alloc] init] autorelease];
    
    s.htmlInstructions = [[stepDico objectForKey:@"html_instructions"] copy];
    
    NSDictionary *durationDico = [stepDico objectForKey:@"duration"];
    
    s.durationValue = [[durationDico objectForKey:@"value"] copy];
    
    s.durationText = [[durationDico objectForKey:@"text"] copy];
    
    NSDictionary *distanceDico = [stepDico objectForKey:@"distance"];
    
    s.distanceValue = [[distanceDico objectForKey:@"value"] copy];
    
    s.distanceText = [[distanceDico objectForKey:@"text"] copy];
    
    NSDictionary *startLocationDico = [stepDico objectForKey:@"start_location"];
    s.startLocation = CLLocationCoordinate2DMake([[startLocationDico objectForKey:@"lat"] doubleValue], [[startLocationDico objectForKey:@"lng"] doubleValue]);
    
    NSDictionary *endLocationDico = [stepDico objectForKey:@"end_location"];
    s.endLocation = CLLocationCoordinate2DMake([[endLocationDico objectForKey:@"lat"] doubleValue], [[endLocationDico objectForKey:@"lng"] doubleValue]);
    
    return s;
}

-(void) dealloc{
    
    [htmlInstructions release];
    htmlInstructions = nil;
    
    [distanceText release];
    distanceText = nil;
    
    [distanceValue release];
    distanceValue = nil;
    
    [durationText release];
    durationText = nil;
    
    [durationValue  release];
    durationValue = nil;
    
    [super dealloc];
}
@end

@implementation Leg

@synthesize endLocation,endAddress,durationText,durationValue;
@synthesize distanceValue,distanceText,startAddress,startLocation,steps;

+(Leg *)parseJsonDico:(NSDictionary *)legDico{
    Leg *l = [[[self alloc] init] autorelease];
    
    NSDictionary *startLocationDico = [legDico objectForKey:@"start_location"];
    l.startLocation = CLLocationCoordinate2DMake([[startLocationDico objectForKey:@"lat"] doubleValue], [[startLocationDico objectForKey:@"lng"] doubleValue]);
    
    NSDictionary *endLocationDico = [legDico objectForKey:@"end_location"];
    l.endLocation = CLLocationCoordinate2DMake([[endLocationDico objectForKey:@"lat"] doubleValue], [[endLocationDico objectForKey:@"lng"] doubleValue]);
    
    l.startAddress = [[legDico objectForKey:@"start_address"] copy];
    
    l.endAddress = [[legDico objectForKey:@"end_address"] copy];
    
    NSDictionary *durationDico = [legDico objectForKey:@"duration"];
    
    l.durationValue = [[durationDico objectForKey:@"value"] copy];
    
    l.durationText = [[durationDico objectForKey:@"text"] copy];
    
    NSDictionary *distanceDico = [legDico objectForKey:@"distance"];
    
    l.distanceValue = [[distanceDico objectForKey:@"value"] copy];
    
    l.distanceText = [[distanceDico objectForKey:@"text"] copy];
    
    NSArray *stepsJsonArray = [legDico objectForKey:@"steps"];
    
    NSMutableArray *stepsArray = [NSMutableArray arrayWithCapacity:[stepsJsonArray count]];
    
    for (NSDictionary *stepDico in stepsJsonArray) {
        Step *s = [Step parseJsonDico:stepDico];
        
        [stepsArray addObject:s];
    }
    l.steps = stepsArray;
    
    return l;
}

-(void) dealloc{
    [steps release];
    steps = nil;
    [distanceText release];
    distanceText = nil;
    [distanceValue release];
    distanceValue = nil;
    [durationText release];
    durationText = nil;
    [durationValue  release];
    durationValue = nil;
    [startAddress release];
    startAddress = nil;
    [endAddress release];
    endAddress = nil;
    
    [super dealloc];
}
@end

@implementation Route

@synthesize copyrights,legs,summary,warnings,waypointsOrder;

+ (Route *) parseJsonDico:(NSDictionary *)routeDico{
    
    Route *r = [[[self alloc] init] autorelease ];
    
    r.copyrights = [[routeDico objectForKey:@"copyrights"] copy];
    
    r.summary = [[routeDico objectForKey:@"summary"] copy];
    
    r.warnings = [[routeDico objectForKey:@"warnings"] copy];
    
    r.waypointsOrder = [[routeDico objectForKey:@"waypoint_order"] copy];
    
    NSArray *legsArray = [routeDico objectForKey:@"legs"];
    
    NSMutableArray *legs = [NSMutableArray arrayWithCapacity:[legsArray count]];
    
    for (NSDictionary *legJsonDico in legsArray){
        Leg *leg = [Leg parseJsonDico:legJsonDico];
        [legs addObject:leg];
    }
    
    r.legs = legs;
    return r;
}

-(void) dealloc{
    
    [copyrights release];
    copyrights = nil;
    [summary release];
    summary = nil;
    [warnings release];
    warnings = nil;
    [waypointsOrder release];
    waypointsOrder = nil;
    [legs release];
    legs = nil;
    
    [super dealloc];
}
@end
