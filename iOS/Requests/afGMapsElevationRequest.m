//
//  afGMapsElevationRequest.m
//  afGMDemo
//
//  Created by adrien ferré on 01/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsElevationRequest.h"


@implementation afGMapsElevationRequest

@synthesize afDelegate,locations,path,pathNumber,elevations;

#pragma mark ------------------------------------------
#pragma mark ------ INIT
#pragma mark ------------------------------------------

+(id)request{
    return [[[self alloc] initWithURL:[NSURL URLWithString:@""]] autorelease];
}
-(id)initDefault{
    self = [super initDefault];
    
    if (self){
        
        [self setUserInfo: [NSDictionary dictionaryWithObject:@"elevation" forKey:@"type"]];
        self.pathNumber = -1;
        self.delegate = self;
    }
    
    return self;
}
#pragma mark ------------------------------------------
#pragma mark ------ URL COMPUTING
#pragma mark ------------------------------------------

-(NSURL *) makeURL{
    NSString *rootURL = [super makeURLStringWithServicePrefix:GOOGLE_ELEVATION_API_ELEVATION_COMPONENT];
    
    if (locations){
        rootURL = [rootURL stringByAppendingFormat:@"locations="];
        
        int i = 0;
        for (CLLocation *loc in locations) {
            i++;
            if (i == [locations count])
                rootURL = [rootURL stringByAppendingFormat:@"%f,%f",loc.coordinate.latitude,loc.coordinate.longitude];
            else
                rootURL = [rootURL stringByAppendingFormat:@"%f,%f|",loc.coordinate.latitude,loc.coordinate.longitude];
        }
    }
    else if (path){
        
        rootURL = [rootURL stringByAppendingFormat:@"path="];
        
        int i = 0;
        for (CLLocation *loc in path) {
            i++;
            if (i == [path count])
                rootURL = [rootURL stringByAppendingFormat:@"%f,%f",loc.coordinate.latitude,loc.coordinate.longitude];
            else
                rootURL = [rootURL stringByAppendingFormat:@"%f,%f|",loc.coordinate.latitude,loc.coordinate.longitude];
        }
        
        rootURL = [rootURL stringByAppendingFormat:@"&samples=%d",pathNumber];
    }
    
    
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

-(void) addLocation:(CLLocation *)location{
    if (!locations){
        NSMutableArray *ar = [[NSMutableArray alloc] init];
        locations = ar;
        [ar release];
    }
    
    [locations addObject:location];
}

-(void) addPathPoint:(CLLocation *)location{
    if (!path){
        NSMutableArray *ar = [[NSMutableArray alloc] init];
        path = ar;
        [ar release];
    }
    
    [path addObject:location];
    
    if (pathNumber == -1) pathNumber = 0;
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
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afElevationWSFailed:withError:)]){
        [afDelegate afElevationWSFailed:self withError:[self error]];
    }
}

-(void) requestFinished:(ASIHTTPRequest *)req{
    
    if (WS_DEBUG) NSLog(@"Request finished");
    
    NSString *jsonString = [[NSString alloc] initWithData:[req responseData] encoding:NSUTF8StringEncoding];
    
    SBJsonParser *json;
    NSError *jsonError;    
    // Init JSON
    json = [ [ SBJsonParser new ] autorelease ];
    
    // Get result in a NSDictionary
    jsonResult = [ json objectWithString:jsonString error:&jsonError ];
    [jsonString release];
    
    // Check if there is an error
    if (jsonResult == nil) {
        
        if (WS_DEBUG) NSLog(@"Erreur lors de la lecture du code JSON (%@).", [ jsonError localizedDescription ]);
        
        NSError *err =  [self errorForService:@"Elevation" type:@"JSON" status:nil];
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afElevationWSFailed:withError:)]){
            [afDelegate afElevationWSFailed:self withError:err];
        }
        
        return;
        
    } else {
       
        NSString *status = [jsonResult objectForKey:@"status"];
        
        if (![status isEqualToString:@"OK"]){
            NSError *err =  [self errorForService:@"Elevation" type:@"GM" status:status];
            
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afElevationWSFailed:withError:)]){
                [afDelegate afElevationWSFailed:self withError:err];
            }
            return;
        }
        NSArray *jsonElevationResults = [jsonResult objectForKey:@"results"];
       
        NSMutableArray *e = [[NSMutableArray alloc] initWithCapacity:[jsonElevationResults count]];
        elevations = e;
        [e release];
        
        for (NSDictionary *jsonResultDico in jsonElevationResults){
            
            NSNumber *el = [jsonResultDico objectForKey:@"elevation"];
            NSDictionary *locationDico = [jsonResultDico objectForKey:@"location"];
            NSNumber *lat = [locationDico objectForKey:@"lat"];
            NSNumber *lng = [locationDico objectForKey:@"lng"];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
            
            NSDictionary *dico = [[NSDictionary alloc] initWithDictionary:jsonResultDico];
            
            [elevations addObject:dico];
            
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afElevationWS:gotElevation:forLocation:)]){
                [afDelegate afElevationWS:self gotElevation:el forLocation:location];
            }
            
        }
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afElevationWS:gotResults:)]){
            [afDelegate afElevationWS:self gotResults:elevations];
        }
    }
}

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request started");
    
    if (afDelegate!=NULL 
        && [afDelegate respondsToSelector:@selector(afElevationWSStarted:)]){
        [afDelegate afElevationWSStarted:self];
    }
    
}

-(void) dealloc{
    
    if(locations){
        [locations release];
        locations = nil;
    }
    
    if (path){
        [path release];
        path = nil;
    }
    
    if (elevations){
        [elevations release];
        elevations = nil;
    }
    
    [super dealloc];
}

@end

