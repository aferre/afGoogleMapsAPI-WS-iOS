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
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWSFailed:withError:)]){
        [afDelegate afGeocodingWSFailed:self withError:[[self error] localizedDescription]];
    }
}

-(void) requestFinished:(ASIHTTPRequest *)req{
    
    if (WS_DEBUG) NSLog(@"Request finished");
    
    NSDictionary *results = [resStr JSONValue];
    
    NSString *status = [results objectForKey:@"status"];
    
    if ([status isEqualToString:@"ZERO_RESULTS"] || [status isEqualToString:@"NOT_FOUND"] ){
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWSFailed:withError:)]){
            [afDelegate afGeocodingWSFailed:self withError:status];
        }
        return;
    }
    
    //Now we need to obtain our coordinates
    NSArray *placemark  = [results objectForKey:@"results"];
    
    if (WS_DEBUG)    
        NSLog(@"%d objects", [placemark count]);
    
    if (reverseGeocoding){
        NSMutableString *ad = [NSMutableString string];
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWS:gotAddress:)]){
            [afDelegate afGeocodingWS:self gotAddress:ad];
        }
    }
    else{
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
    }
}

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    resStr = [[NSMutableString alloc] init];

    if (WS_DEBUG) NSLog(@"Request started");
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afGeocodingWSStarted:)]){
        [afDelegate afGeocodingWSStarted:self];
    }
}

@end
