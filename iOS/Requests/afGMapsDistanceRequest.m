//
//  afGoogleMapsDistanceWS.m
//  g2park
//
//  Created by adrien ferré on 29/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsDistanceRequest.h"

@implementation afGMapsDistanceRequest

@synthesize afDelegate,origins,destinations,travelMode,avoidMode,unitsSystem;

#pragma mark ------------------------------------------
#pragma mark ------ INIT
#pragma mark ------------------------------------------


+(id) request{
    return [[[self alloc] initDefault] autorelease];
}

-(id)initDefault{
    self = [super initDefault];
    
    if (self){
        
        self.travelMode = TravelModeDefault;
        self.avoidMode = AvoidModeNone;
        self.unitsSystem = UnitsDefault;
        
        [self setUserInfo: [NSDictionary dictionaryWithObject:@"distance" forKey:@"type"]];
        self.delegate = self;
    }
    
    return self;
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
#pragma mark ------ URL COMPUTING
#pragma mark ------------------------------------------

-(NSURL *)makeURL{
    
    NSMutableString *rootURL = [NSMutableString stringWithString:[super makeURLStringWithServicePrefix:GOOGLE_DISTANCE_API_PATH_COMPONENT]];
    
    //origins
    [rootURL appendFormat:@"origins="];
    
    int i = 0;
    for (NSString *origin in origins) {
        i++;
        if([origin isEqualToString:@""]){
            
        }else if (i == [origins count])
            [rootURL appendFormat:@"%@",origin];
        else
            [rootURL appendFormat:@"%@|",origin];
    }
    
    //destinations
    [rootURL appendFormat:@"&destinations="];
    
    i = 0;
    for (NSString *dest in destinations) {
        i++;
        if([dest isEqualToString:@""]){
            
        }else if (i == [destinations count])
            [rootURL appendFormat:@"%@",dest];
        else
            [rootURL appendFormat:@"%@|",dest];
    }
    
    //mode
    if (travelMode != TravelModeDefault)
        [rootURL appendFormat:@"&mode=%@",[afGoogleMapsEnums TravelModeStringFromObjectType:travelMode]];
    
    //language
    if (language != LangDEFAULT)
        [rootURL appendFormat:@"&language=%@",[afGoogleMapsAPIRequest languageCode:language]];
    
    //avoid
    if (avoidMode != AvoidModeNone)
        [rootURL appendFormat:@"&avoid=%@",[afGoogleMapsEnums AvoidModeStringFromObjectType:avoidMode]];
    
    //units
    if (unitsSystem != UnitsDefault)
        switch (unitsSystem) {
            case UnitsImperial:
                [rootURL appendFormat:@"&units=imperial"];
                break;
                
            case UnitsMetric:
                [rootURL appendFormat:@"&units=metric"];
                break;
                
            default:
                break;
        }
    
    return [super finalizeURLString:rootURL];
    
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
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWSFailed:withError:)]){
        [afDelegate afDistanceWSFailed:self withError:[self error]];
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
        
        NSError *err =  [self errorForService:@"Distance" type:@"JSON" status:nil];
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWSFailed:withError:)]){
            [afDelegate afDistanceWSFailed:self withError:err];
        }
        return;
    } else {
        
        NSString *topLevelStatus = [jsonResult objectForKey:@"status"];
        if (![topLevelStatus isEqualToString:@"OK"]){
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWSFailed:withError:)]){
                NSError *err =  [self errorForService:@"Distance" type:@"GM" status:topLevelStatus];
                
                [afDelegate afDistanceWSFailed:self withError:err];
            }
            return;
        }
        
        //ROW = ORIGIN
        //ROW 0 = ORIGIN = 0
        NSArray *returnedOrigins = [jsonResult objectForKey:@"origin_addresses"];
        NSArray *returnedDestinations = [jsonResult objectForKey:@"destination_addresses"];
        NSArray *rows = [jsonResult objectForKey:@"rows"];
        NSLog(@"ROWS COUNT %d",[rows count]);
        
        if([rows count] != [origins count]){
            if(WS_DEBUG) NSLog(@"rows count != origins count");
        }
        int i;
        
        for (i = 0 ; i < [rows count]; i++){
            NSLog(@"PARSING ROW %d",i);
            int j;
            NSString *providedOrigin = [origins objectAtIndex:i];
            NSString *returnedOrigin = [returnedOrigins objectAtIndex:i];
            
            NSDictionary *row = [rows objectAtIndex:i];
            
            //ELEMENT = DEST
            //ELEMENT 0 = DEST = 0
            NSArray *elements = [row objectForKey:@"elements"];
            
            for (j = 0 ; j < [elements count]; j++){
                NSLog(@"PARSING element %d",j);
                NSDictionary *childEle = [elements objectAtIndex:j];
                NSString *providedDest = [destinations objectAtIndex:j];
                NSString *returnedDest = [returnedDestinations objectAtIndex:j];
                
                /*
                 ELEMENT STATUS 
                 OK indicates the response contains a valid result.
                 NOT_FOUND indicates that the origin and/or destination of this pairing could not be geocoded.
                 ZERO_RESULTS indicates no route could be found between the origin and destination.
                 */
                NSString *elementStatus = [childEle objectForKey:@"status"];
                if ([elementStatus isEqualToString:@"OK"]){
                    
                    NSDictionary * distanceDico = [childEle objectForKey:@"distance"];
                    NSString *textDistance = [distanceDico objectForKey:@"text"];
                    
                    //always in meters, so we convert it to match the unit system used
                    //in the request
                    
                    NSNumber *valueDistance;
                    if(unitsSystem == UnitsImperial){
                        valueDistance = [NSNumber numberWithDouble:[[distanceDico objectForKey:@"value"] doubleValue] * METER_TO_MILE];
                    }else{
                        valueDistance = [NSNumber numberWithDouble:[[distanceDico objectForKey:@"value"] doubleValue]];
                    }
                    NSDictionary * durationDico = [childEle objectForKey:@"duration"];
                    NSString *textDuration = [durationDico objectForKey:@"text"];
                    NSNumber *valueDuration = [NSNumber numberWithDouble:[[durationDico objectForKey:@"value"] doubleValue]];
                    
                                            
                    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWS:distance:origin:destination:unit:)]){
                        [afDelegate afDistanceWS:self distance:valueDistance origin:providedOrigin destination:providedDest unit:unitsSystem];
                    
                    }
                    
                    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWS:distance:textDistance:origin:returnedOrigin:destination:returnedDestination:duration:textDuration:unit:)]){
                        [afDelegate afDistanceWS:self distance:valueDistance textDistance:textDistance origin:providedOrigin returnedOrigin:returnedOrigin destination:providedDest returnedDestination:returnedDest duration: valueDuration textDuration:textDuration unit:unitsSystem];
                    }
                }
                else {
                    if( afDelegate !=NULL && [afDelegate respondsToSelector:@selector(afDistanceWS:origin:destination:failedWithError:)]){
                        NSError *err =  [self errorForService:@"Distance" type:@"GM" status:elementStatus];
                        
                        [afDelegate afDistanceWS:self origin:providedOrigin destination:providedDest failedWithError:err];
                        
                    }
                }
            }
        }
        
    }
}

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
    if (WS_DEBUG) NSLog(@"Request redirected");
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request started");
    
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWSStarted:)]){
        [afDelegate afDistanceWSStarted:self];
    }
}

-(void) dealloc{
    
    afDelegate = nil;
    
    [origins release];
    origins = nil;
    
    [destinations  release];
    destinations = nil;
    
    [super dealloc];
    
}

@end

