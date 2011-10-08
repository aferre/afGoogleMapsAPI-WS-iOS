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
    rootURL = [rootURL stringByAppendingFormat:@"reference=%@",reference];
    
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
        
        NSError *err =  [self errorForService:@"Place Details" type:@"JSON" status:nil];
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceDetailsWSFailed:withError:)]){
            [afDelegate afPlaceDetailsWSFailed:self withError:err];
        }
        return;
    } else {
        NSString *status = [jsonResult objectForKey:@"status"];
        if (![status isEqualToString:@"OK"] ){
            
            NSError *err =  [self errorForService:@"Place Details" type:@"GM" status:status];
            
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceDetailsWSFailed:withError:)]){
                [afDelegate afPlaceDetailsWSFailed:self withError:err];
            }
            return;
        }
        htmlAttributions = [[jsonResult objectForKey:@"html_attributions"] copy];
        
        NSDictionary *detailsJsonDico = [jsonResult objectForKey:@"result"];
        
        details = [PlaceDetails parseJsonDico:detailsJsonDico];
        
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
    
    [super dealloc];
}
@end

@implementation PlaceDetails

@synthesize formattedPhoneNumber,formattedAddress,addressComponents,rating,reference,theId;
@synthesize types,urlURL,urlICON,vicinity,name;

+(PlaceDetails *) parseJsonDico:(NSDictionary *)jsonDico{
    
    PlaceDetails *sr = [[PlaceDetails alloc] init];
    
    NSString *str;
    NSArray *ar;
    NSURL *url;
    str =[[NSString alloc] initWithString: [jsonDico objectForKey:@"name"]]; 
    sr.name = str;
    [str release];
    str = [[NSString alloc] initWithString: [jsonDico objectForKey:@"vicinity"]];
    sr.vicinity =  str;
    [str release];
    ar = [[NSArray alloc] initWithArray:[jsonDico objectForKey:@"types"]];
    sr.types = ar;
    [ar    release];
    str = [[NSString alloc] initWithString: [jsonDico objectForKey:@"formatted_address"]];
    sr.formattedAddress = str;
    [str release];
    str=[[NSString alloc] initWithString: [jsonDico  objectForKey:@"formatted_phone_number"]];
    sr.formattedPhoneNumber= str;
    [str release];
    NSURL *a = [[NSURL alloc] initWithString:[jsonDico objectForKey:@"url"]];
    sr.urlURL = a;
    [a release];
    NSURL *b = [[NSURL alloc] initWithString:[jsonDico objectForKey:@"icon"]];
    sr.urlICON = b;
    [b release];
    str= [[NSString alloc] initWithString: [jsonDico objectForKey:@"id"]];
    sr.theId = str;
    [str release];
    str = [[NSString alloc] initWithString: [jsonDico objectForKey:@"reference"]];
    sr.reference = str;
    [str release];
    
    sr.rating = [[jsonDico objectForKey:@"rating"] doubleValue];
    
    NSArray *addressComponentsArray = [jsonDico objectForKey:@"address_components"];
    NSMutableArray *addressComponents = [NSMutableArray array];
    
    for (NSDictionary *addressCompDico in addressComponentsArray){
        AddressComponent *addressComp = [AddressComponent parseJsonDico:addressCompDico];
        [addressComponents addObject:addressComp];
    }
    ar = [[NSArray alloc] initWithArray:addressComponents];
    sr.addressComponents = ar;
    [ar release]; 
    return  sr;
}

-(NSString *)textualDesc{
    NSString *str = @"";
    str = [str stringByAppendingFormat:@"ID : %@",theId];
    str = [str stringByAppendingFormat:@"\nRef : %@",reference];
    str = [str stringByAppendingFormat:@"\nName : %@",name];
    str = [str stringByAppendingFormat:@"\nRating : %f",rating];
    str = [str stringByAppendingFormat:@"\nVicinity : %@",vicinity];
    return str;
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
    
    [super dealloc];
}
@end