//
//  afGMapsPlaceDetailsRequest.m
//  afGMDemo
//
//  Created by adrien ferré on 01/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlaceDetailsRequest.h"

@implementation afGMapsPlaceDetailsRequest

@synthesize afDelegate,reference,htmlAttributions,details;

#pragma mark ------------------------------------------
#pragma mark ------ INIT
#pragma mark ------------------------------------------

+ (id) request{
    return [[[self alloc] initDefault] autorelease];
}

- (id) initDefault{
    
    self = [super initDefault];
    
    if (self){
        [self setUserInfo: [NSDictionary dictionaryWithObject:@"PlaceSearches" forKey:@"type"]];
        self.delegate = self;
    }
    
    return self;
}

#pragma mark ------------------------------------------
#pragma mark ------ URL COMPUTING
#pragma mark ------------------------------------------

-(NSURL *) makeURL{
    
    NSString *rootURL = [super makeURLStringWithServicePrefix:@"details"];
    
    //reference
    rootURL = [rootURL stringByAppendingFormat:@"&reference=%f",reference];
    
    //language
    if (language != LangDEFAULT){
        rootURL = [rootURL stringByAppendingFormat:@"&language=%@",[afGoogleMapsAPIRequest languageCode:language]];   
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
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceDetailsWSFailed:withError:)]){
        [afDelegate afPlaceDetailsWSFailed:self withError:[self error]];
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
                                                                      NSLocalizedString(@"GoogleMaps Place Report API returned no content@",@"")]
                                                              forKey:NSLocalizedDescriptionKey];
        NSError *err = [NSError errorWithDomain:@"GoogleMaps Place Report API Error" code:CUSTOM_ERROR_NUMBER userInfo:errorInfo];
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceDetailsWSFailed:withError:)]){
            [afDelegate afPlaceDetailsWSFailed:self withError:err];
        }
        return;
    } else {
        NSString *status = [jsonResult objectForKey:@"status"];
        if (![status isEqualToString:@"OK"] ){
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:
                                                                          NSLocalizedString(@"GoogleMaps Place Report API returned status code %@",@""),
                                                                          status]
                                                                  forKey:NSLocalizedDescriptionKey];
            NSError *err = [NSError errorWithDomain:@"GoogleMaps Place Report API Error" code:CUSTOM_ERROR_NUMBER userInfo:errorInfo];
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceDetailsWSFailed:withError:)]){
                [afDelegate afPlaceDetailsWSFailed:self withError:err];
            }
            return;
        }
        htmlAttributions = [[jsonResult objectForKey:@"html_attributions"] copy];
        
        NSDictionary *detailsJsonDico = [jsonResult objectForKey:@"result"];
        
        details = [Details parseJsonDico:detailsJsonDico];
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceDetailsWS:gotDetails:htmlAttributions:)]){
            [afDelegate afPlaceDetailsWS:self gotDetails:details htmlAttributions:htmlAttributions];
        }
    }
}

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    if (WS_DEBUG) NSLog(@"Request started");
    
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceDetailsWSStarted:)]){
        [afDelegate afPlaceDetailsWSStarted:self];
    }
}

-(void) dealloc{
    
    afDelegate = nil;
    
    if(details){
        [details release];
        details = nil;
    }
    
    if (htmlAttributions) {
        [htmlAttributions release];
        htmlAttributions = nil;
    }
    
    if (reference) {
        [reference release];
        reference = nil;   
    }
}
@end

@implementation Details

@synthesize formattedPhoneNumber,formattedAddress,addressComponents,rating,reference,theId;
@synthesize types,urlURL,urlICON,vicinity,name;

+(Details *) parseJsonDico:(NSDictionary *)jsonDico{
    
    Details *sr = [[[Details alloc] init] autorelease];
    sr.name = [jsonDico objectForKey:@"name"];
    sr.vicinity = [jsonDico objectForKey:@"vicinity"];
    sr.types = [jsonDico objectForKey:@"types"];
    sr.formattedAddress = [jsonDico objectForKey:@"formatted_address"];
    sr.formattedPhoneNumber= [jsonDico  objectForKey:@"formatted_phone_number"];
    sr.urlURL = [[NSURL alloc] initWithString:[jsonDico objectForKey:@"url"]];
    sr.urlICON = [[NSURL alloc] initWithString:[jsonDico objectForKey:@"icon"]];
    sr.theId = [jsonDico objectForKey:@"id"];
    sr.reference = [jsonDico objectForKey:@"reference"];
    sr.rating = [[jsonDico objectForKey:@"rating"] doubleValue];
    
    NSArray *addressComponentsArray = [jsonDico objectForKey:@"address_components"];
    NSMutableArray *addressComponents = [NSMutableArray array];
    
    for (NSDictionary *addressCompDico in addressComponentsArray){
        AddressComponent *addressComp = [AddressComponent parseJsonDico:addressCompDico];
        [addressComponents addObject:addressComp];
    }
    sr.addressComponents = [[NSArray alloc] initWithArray:addressComponents];
    
    return  sr;
}

-(void) dealloc{
    [vicinity release];
    [name release];
    [formattedPhoneNumber release];
    [formattedAddress release];
    [addressComponents release];
    [types release];
    [urlURL release];
    [urlICON release];
    [reference release];
    [theId release];
    
    vicinity = nil;
    name = nil;
    formattedPhoneNumber = nil;
    formattedAddress = nil;
    addressComponents = nil;
    types = nil;
    urlURL = nil;
    urlICON = nil;
    reference = nil;
    theId = nil;
}
@end