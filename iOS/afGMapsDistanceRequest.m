//
//  afGoogleMapsDistanceWS.m
//  g2park
//
//  Created by adrien ferré on 29/05/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsDistanceRequest.h"


@implementation afGMapsDistanceRequest

@synthesize afDelegate;

-(NSString *) getURLString{
    
    NSString *str = [super getURLString];
    
    str = [str stringByAppendingFormat:@"%@",GOOGLE_DISTANCE_API_PATH_COMPONENT];
    
    switch (format) {
        case USE_JSON:
        {
            str = [str stringByAppendingFormat:@"/json?"];
        }
            break;
        case USE_XML:
        {
            str = [str stringByAppendingFormat:@"/xml?"];
        }
            break;
        default:
            NSLog(@"ERROR: didn't choose a format for GOOGLE WS");
            break;
    }
    
    return str;
}

+(id) distanceForStartingLatitude:(double) slat andLongitude:(double)slng
               withEndingLatitude:(double) elat andLongitude:(double)elng{
    
    return [[[self alloc] requestDistanceForStartingLatitude:slat andLongitude:slng
                                          withEndingLatitude:elat andLongitude:elng] autorelease];
}
- (void) initDefVars{
    useSensor = NO;
    useHTTPS = NO;
    format = USE_JSON;
}

- (id) requestDistanceForStartingLatitude:(double) slat andLongitude:(double)slng
                       withEndingLatitude:(double) elat andLongitude:(double)elng{
    [self initDefVars];
    
    self = [super initWithURL:[self urlDistanceForStartingLatitude:slat andLongitude:slng
                                                withEndingLatitude:elat andLongitude:elng]];
    
    if (self){
        [self setUserInfo: [NSDictionary dictionaryWithObject:@"distance" forKey:@"type"]];
        self.delegate = self;
    }
    
    return self;
}

- (NSURL *) urlDistanceForStartingLatitude:(double) slat andLongitude:(double)slng
                        withEndingLatitude:(double) elat andLongitude:(double)elng{
    
    NSMutableString *urlString = [NSMutableString stringWithString:[self getURLString]];
    
    [urlString appendFormat:@"origins=%f,%f&destinations=%f,%f&mode=driving&language=fr-FR",slat,slng,elat,elng];
    
    if (useSensor)
        [urlString appendString:@"&sensor=true"];
    else
        [urlString appendString:@"&sensor=false"];
    
    NSLog(@"URL IS %@",urlString);
    return [NSURL URLWithString:urlString];
}

#pragma mark --
#pragma mark -- ASI HTTP REQUESTS
#pragma mark --

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
    
  /*  NSDictionary *results = [resStr JSONValue];
    
    NSString *status = [results objectForKey:@"status"];
    if ([status isEqualToString:@"ZERO_RESULTS"] || [status isEqualToString:@"NOT_FOUND"] ){
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWSFailed:withError:)]){
            [afDelegate afDistanceWSFailed:self withError:status];
        }
        return;
    }
    
    //Now we need to obtain our coordinates
    NSArray *placemark  = [results objectForKey:@"results"];
    
    if (WS_DEBUG)    
        NSLog(@"%d objects", [placemark count]);
    */
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
        if ([status isEqualToString:@"ZERO_RESULTS"]){
            
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
    
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    resStr = [[NSMutableString alloc] init];
    
    if (WS_DEBUG) NSLog(@"Request started");
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afDistanceWSStarted:)]){
        [afDelegate afDistanceWSStarted:self];
    }
}

@end

