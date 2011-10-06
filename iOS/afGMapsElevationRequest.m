//
//  afGMapsElevationRequest.m
//  afGMDemo
//
//  Created by adrien ferré on 01/06/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsElevationRequest.h"


@implementation afGMapsElevationRequest

@synthesize afDelegate;

#pragma mark ------------------------------------------
#pragma mark ------ INIT
#pragma mark ------------------------------------------

+(id)request{
    return [[[self alloc] initWithURL:[NSURL URLWithString:@""]] autorelease];
}

#pragma mark ------------------------------------------
#pragma mark ------ URL COMPUTING
#pragma mark ------------------------------------------

-(NSURL *) makeURL{
    NSString *rootURL = [super makeURLStringWithServicePrefix:GOOGLE_ELEVATION_API_PATH_COMPONENT];
    
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
        
        NSLog(@"Erreur lors de la lecture du code JSON (%@).", [ jsonError localizedDescription ]);
        
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
        
    }
}

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request started");
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afElevationWSStarted:)]){
        [afDelegate afElevationWSStarted:self];
    }
}

-(void) dealloc{
    
    [super dealloc];
}

@end

