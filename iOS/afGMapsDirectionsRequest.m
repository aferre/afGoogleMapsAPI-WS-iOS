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

+(id) request{
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
    
    NSString *rootURL = [super makeURLStringWithServicePrefix:GOOGLE_DIRECTIONS_API_PATH_COMPONENT];
    
    //origin
    rootURL = [rootURL stringByAppendingFormat:@"origin=%@",origin];
    //destination
    rootURL = [rootURL stringByAppendingFormat:@"&destination=%@",destination];
    
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
    NSLog(@"%@ %@",[[req error] localizedDescription], [[req error] localizedFailureReason]);
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
       
        NSError *err =  [self errorForService:@"Directions" type:@"JSON" status:nil];
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDirectionsWSFailed:withError:)]){
            [afDelegate afDirectionsWSFailed:self withError:err];
        }
        return;
    } else {
        NSString *status = [jsonResult objectForKey:@"status"];
        if (![status isEqualToString:@"OK"] ){
            NSError *err =  [self errorForService:@"Directions" type:@"GM" status:status];
        
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDirectionsWSFailed:withError:)]){
                [afDelegate afDirectionsWSFailed:self withError:err];
            }
            return;
        }
        
        
        NSArray *routesJsonArr = [jsonResult objectForKey:@"routes"];
        NSMutableArray *returnedRoutes = [NSMutableArray arrayWithCapacity:[routesJsonArr count]];
        
        for (NSDictionary *routeJsonDico in routesJsonArr) {
            
            Route *route = [Route parseJsonDico:routeJsonDico];
            [returnedRoutes addObject:route];
        }
        
        NSArray *ar =  [[NSArray alloc] initWithArray:returnedRoutes];
        self.routes = ar;
        [ar release];
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
    
    NSString *_inst = [[stepDico objectForKey:@"html_instructions"] copy];
    s.htmlInstructions = _inst;
    [_inst release];
    
    NSDictionary *durationDico = [stepDico objectForKey:@"duration"];
    
    NSNumber *durationV = [[durationDico objectForKey:@"value"] copy];
    s.durationValue = durationV;
    [durationV release];
    
    NSString *str = [[durationDico objectForKey:@"text"] copy];
    s.durationText = str;
    [str release];
    
    NSDictionary *distanceDico = [stepDico objectForKey:@"distance"];
    
    NSNumber *distanceV = [[distanceDico objectForKey:@"value"] copy];
    s.distanceValue = distanceV;
    [distanceV release];
    NSString *distanceT = [[distanceDico objectForKey:@"text"] copy];
    s.distanceText = distanceT;
    [distanceT release];
    
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
    
    NSNumber *n;
    NSString *str = [[legDico objectForKey:@"start_address"] copy];
    l.startAddress = str;
    [str release];
    
    str = [[legDico objectForKey:@"end_address"] copy];
    l.endAddress = str;
    [str release];
    
    NSDictionary *durationDico = [legDico objectForKey:@"duration"];
    
    n=[[durationDico objectForKey:@"value"] copy];
    l.durationValue = n;
    [n release];
    
    str = [[durationDico objectForKey:@"text"] copy];
    l.durationText = str;
    [str release];
    
    NSDictionary *distanceDico = [legDico objectForKey:@"distance"];
    
    n = [[distanceDico objectForKey:@"value"] copy];
    l.distanceValue =n;
    [n release];
    
    str=[[distanceDico objectForKey:@"text"] copy];
    l.distanceText = str;
    [str release];
    
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
    
    NSString *str;
    
    str = [[routeDico objectForKey:@"copyrights"] copy];
    r.copyrights = str;
    [str release];
    str = [[routeDico objectForKey:@"summary"] copy];
    r.summary = str;
    [str release];
    str= [[routeDico objectForKey:@"warnings"] copy];
    r.warnings = str;
    [str release];
    str= [[routeDico objectForKey:@"waypoint_order"] copy];
    r.waypointsOrder = str; 
    [str release];
    
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
