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


+(id) distanceRequest{
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
    [self setURL:[self  makeURL]];
    [super startAsynchronous];
}

-(void) startSynchronous{
    
    [self setURL:[self  makeURL]];
    [super startSynchronous];
}

#pragma mark ------------------------------------------
#pragma mark ------ URL COMPUTING
#pragma mark ------------------------------------------

-(NSURL *)makeURL{
    
    NSString *rootURL = [self getURLString];
    
    rootURL = [rootURL stringByAppendingFormat:@"%@",GOOGLE_DISTANCE_API_PATH_COMPONENT];
    
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
    
    //origins
        rootURL = [rootURL stringByAppendingFormat:@"origins="];
        
        int i = 0;
        for (NSString *origin in origins) {
            NSString *str = [origin stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            i++;
            if (i == [origins count])
                rootURL = [rootURL stringByAppendingFormat:@"%@",str];
            else
                rootURL = [rootURL stringByAppendingFormat:@"%@|",str];
        }
        
    //destinations
    rootURL = [rootURL stringByAppendingFormat:@"&destinations="];
    
    i = 0;
    for (NSString *dest in destinations) {
        NSString *str = [dest stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        i++;
        if (i == [destinations count])
            rootURL = [rootURL stringByAppendingFormat:@"%@",str];
        else
            rootURL = [rootURL stringByAppendingFormat:@"%@|",str];
    }
    
    //mode
    if (travelMode != TravelModeDefault)
        rootURL = [rootURL stringByAppendingFormat:@"&mode=%@",[afGoogleMapsAPIRequest travelMode:travelMode]];
    
    //language
    if (language != LangDEFAULT)
        rootURL = [rootURL stringByAppendingFormat:@"&language=%@",[afGoogleMapsAPIRequest languageCode:language]];
    
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
    
    //sensor
    if (useSensor) 
        rootURL = [rootURL stringByAppendingFormat:@"&sensor=true"];
    else
        rootURL = [rootURL stringByAppendingFormat:@"&sensor=false"];
    
    NSLog(@"URL IS %@",rootURL);
    
    return [NSURL URLWithString:rootURL];

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
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWSFailed:withError:)]){
        [afDelegate afDistanceWSFailed:self withError:[[self error] localizedDescription]];
    }
}

-(void) requestFinished:(ASIHTTPRequest *)req{
    
    if (WS_DEBUG) NSLog(@"Request finished");
    
    SBJsonParser *json;
    NSError *jsonError;
    NSDictionary *jsonResults;
    
    json = [ [ SBJsonParser new ] autorelease ];
    
    jsonResults = [ json objectWithString:resStr error:&jsonError ];
    
    if (jsonResults == nil) {
        NSLog(@"Erreur lors de la lecture du code JSON (%@).", [ jsonError localizedDescription ]);
    } else {
        NSArray *rows = [jsonResults objectForKey:@"rows"];
        
        NSDictionary *dico = [rows objectAtIndex:0];
        
        NSArray *elements = [dico objectForKey:@"elements"];
        
        NSDictionary *childEle = [elements objectAtIndex:0];
        
        NSString *status = [childEle objectForKey:@"status"];
        if ([status isEqualToString:@"ZERO_RESULTS"] || [status isEqualToString:@"NOT_FOUND"]){
            
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWSFailed:withError:)]){
                [afDelegate afDistanceWSFailed:self withError:status];
            }
        }
        else {
            NSDictionary *distanceDico = [childEle objectForKey:@"distance"];
            
            NSString *distance = [distanceDico objectForKey:@"text"];
            
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWS:gotDistance:)]){
                [afDelegate afDistanceWS:self gotDistance:distance];
            }
        }
    }
}

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
    if (WS_DEBUG) NSLog(@"Request redirected");
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request started");
    resStr = [[NSMutableString alloc] init];
    
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWSStarted:)]){
        [afDelegate afDistanceWSStarted:self];
    }
}

@end

