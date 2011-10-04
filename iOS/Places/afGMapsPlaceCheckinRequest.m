//
//  afGMapsPlaceCheckinRequest.m
//  afGMDemo
//
//  Created by adrien ferré on 01/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlaceCheckinRequest.h"

@implementation afGMapsPlaceCheckinRequest

@synthesize afDelegate,reference;

#pragma mark ------------------------------------------
#pragma mark ------ INIT
#pragma mark ------------------------------------------

+(id) request{
    return [[[self alloc] initDefault] autorelease];
}

-(id) initDefault{
    
    self = [super initDefault];
    
    if (self){
        [self setUserInfo: [NSDictionary dictionaryWithObject:@"placeCheckin" forKey:@"type"]];
        self.delegate = self;
    }
    
    return self;
}
#pragma mark ------------------------------------------
#pragma mark ------ URL COMPUTING
#pragma mark ------------------------------------------

-(NSURL *) makeURL{
    
    NSString *rootURL = [super makeURLStringWithServicePrefix:@"check-in"];
    
    return [super finalizeURLString:rootURL];
}

#pragma mark ------------------------------------------
#pragma mark ------ ASI HTTP REQUEST Overrides
#pragma mark ------------------------------------------

-(void) startAsynchronous{
    
    if (reference == nil || [reference isEqualToString:@""])
        return;
    
    [self setURL:[self makeURL]];
    NSDictionary *dico = [NSDictionary dictionaryWithObject:reference forKey:@"reference"];
    [self appendPostData:[[dico JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setRequestMethod:@"POST"];
    
    [super startAsynchronous];
}

-(void) startSynchronous{
    if (reference == nil || [reference isEqualToString:@""])
        return;
    
    [self setURL:[self makeURL]];
    [self appendPostData:[reference dataUsingEncoding:NSUTF8StringEncoding]];
    [self setRequestMethod:@"POST"];
    [super startAsynchronous];
    
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
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceCheckinWSFailed:withError:)]){
        [afDelegate afPlaceCheckinWSFailed:self withError:[self error]];
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
                                                                      NSLocalizedString(@"GoogleMaps Place Checkin API returned no content@",@"")]
                                                              forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:@"GoogleMaps Place Checkin API Error" code:CUSTOM_ERROR_NUMBER userInfo:errorInfo];
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceCheckinWSFailed:withError:)]){
            [afDelegate afPlaceCheckinWSFailed:self withError:err];
        }
        return;
    } else {
        NSString *status = [jsonResult objectForKey:@"status"];
        if (![status isEqualToString:@"OK"] ){
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                                          NSLocalizedString(@"GoogleMaps Place Checkin API returned status code %@",@""),
                                                                          status]
                                                                  forKey:NSLocalizedDescriptionKey];
            NSError *err = [NSError errorWithDomain:@"GoogleMaps Place Checkin API Error" code:CUSTOM_ERROR_NUMBER userInfo:errorInfo];
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceCheckinWSFailed:withError:)]){
                [afDelegate afPlaceCheckinWSFailed:self withError:err];
            }
            return;
        }
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceCheckinWSSucceeded)]){
            [afDelegate afPlaceCheckinWSSucceeded:self];
        }
    }
}

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request started");
    
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceCheckinWSStarted:)]){
        [afDelegate afPlaceCheckinWSStarted:self];
    }
}

-(void) dealloc{
    
    afDelegate = nil;
        
    [reference release];
    reference = nil;
    
    [super dealloc];
}

@end
