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

@synthesize reverseGeocoding, afDelegate;

-(NSString *) getURLString{
    
    NSString *str = [super getURLString];
    
    str = [str stringByAppendingFormat:@"%@",GOOGLE_GEOCODE_API_PATH_COMPONENT];
    
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

+(id) addressForLatitude:(double) lat andLongitude:(double)lng{
    
    return [[[self alloc] requestAddressForLatitude:lat andLongitude:lng] autorelease];
}
- (void) initDefVars{
    useSensor = NO;
    useHTTPS = NO;
    format = USE_JSON;
}

- (id) requestAddressForLatitude:(double) lat andLongitude:(double) lng{
    reverseGeocoding = YES;
    [self initDefVars];
    
    self = [super initWithURL:[self urlAddressForLatitude:lat andLongitude:lng]];
    
    if (self){
        [self setUserInfo: [NSDictionary dictionaryWithObject:@"adressToCoordinate" forKey:@"type"]];
        self.delegate = self;
    }
    
    return self;
}

- (NSURL *) urlAddressForLatitude:(double) lat andLongitude:(double) lng{
    NSMutableString *urlString = [NSMutableString stringWithString:[self getURLString]];
    
    [urlString appendFormat:@"latlng=%f,%f",lat,lng];
    
    if (useSensor)
        [urlString appendString:@"&sensor=true"];
    else
        [urlString appendString:@"&sensor=false"];
    
    NSLog(@"URL IS %@",urlString);
    return [NSURL URLWithString:urlString];
}

+(id) coordinatesForAddress:(NSString *)address{
    
    return [[[self alloc] requestCoordinatesForAddress:address] autorelease];
}

- (id) requestCoordinatesForAddress:(NSString *)address{
    [self initDefVars];
    format = USE_JSON;
    reverseGeocoding = NO;
    
    self = [super initWithURL:[self urlCoordinatesForAddress:address]];
    
    if (self){
        [self setUserInfo: [NSDictionary dictionaryWithObject:@"adressToCoordinate" forKey:@"type"]];
        self.delegate = self;
    }
    
    return self;
}

- (NSURL *) urlCoordinatesForAddress:(NSString *)address{
    NSMutableString *urlString = [NSMutableString stringWithString:[self getURLString]];
    
    NSString *ad = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [urlString appendFormat:@"address=%@",ad];
    
    if (useSensor)
        [urlString appendString:@"&sensor=true"];
    else
        [urlString appendString:@"&sensor=false"];
    
    NSURL *turl = [NSURL URLWithString:urlString];
    
    return turl;
}

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
