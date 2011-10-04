//
//  afGMapsPlaceReportRequest.m
//  afGMDemo
//
//  Created by adrien ferré on 01/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlaceReportRequest.h"

@implementation afGMapsPlaceReportRequest
@synthesize location,name,types,accuracy,afDelegate,isDeleting,reference;

#pragma mark ------------------------------------------
#pragma mark ------ INIT
#pragma mark ------------------------------------------

+ (id) request{
    return [[[self alloc] initDefault] autorelease];
}

- (id) initDefault{
    
    self = [super initDefault];
    
    if (self){
        [self setUserInfo: [NSDictionary dictionaryWithObject:@"placeReport" forKey:@"type"]];
        self.delegate = self;
        isDeleting = NO;
    }
    
    return self;
}
#pragma mark ------------------------------------------
#pragma mark ------ URL COMPUTING
#pragma mark ------------------------------------------

-(NSURL *) makeURL{
    
    NSString *rootURL = [super getURLString];
    
    if (isDeleting)
        rootURL = [rootURL stringByAppendingFormat:@"delete"];
    else
        rootURL = [rootURL stringByAppendingFormat:@"add"];
    
    switch (format) {
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
    
    return [super finalizeURLString:rootURL];
}

#pragma mark ------------------------------------------
#pragma mark ------ ASI HTTP REQUEST Overrides
#pragma mark ------------------------------------------

-(NSDictionary *)makeDico{
    
    NSMutableDictionary *dico = [NSMutableDictionary dictionary];
    
    if (!isDeleting){
        NSDictionary *coordDico = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:location.latitude ],@"lat",[NSNumber numberWithDouble:location.longitude],@"lng",nil, nil];
        [dico setObject:coordDico forKey:@"location"];
        [dico setObject:name forKey:@"name"];
        [dico setObject:types forKey:@"types"];
        [dico setObject:[NSNumber numberWithDouble:accuracy] forKey:@"accuracy"];
        [dico setObject:[afGoogleMapsAPIRequest languageCode:language] forKey:@"language"];
    }
    else{
        [dico setObject:reference forKey:@"reference"];
    }
    return dico;
}

-(void) startAsynchronous{
    
    [self setURL:[self makeURL]];
    [self appendPostData:[[[self makeDico] JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setRequestMethod:@"POST"];
    
    [super startAsynchronous];
}

-(void) startSynchronous{
    
    [self setURL:[self makeURL]];
    [self appendPostData:[[[self makeDico] JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setRequestMethod:@"POST"];
    
    [super startSynchronous];
}

-(void) setReference:(NSString *)refe{
    self.reference = refe;
    isDeleting = YES;
}

-(void) setName:(NSString *)nam{
    self.name = nam;
    isDeleting = NO;
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
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceReportWSFailed:withError:)]){
        [afDelegate afPlaceReportWSFailed:self withError:[self error]];
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
        
        if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceReportWSFailed:withError:)]){
            [afDelegate afPlaceReportWSFailed:self withError:[NSError errorWithDomain:@"GoogleMaps Place Report API Error" code:CUSTOM_ERROR_NUMBER userInfo:errorInfo]];
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
            
            if (isDeleting){
                if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceReportWSFailed:toDelete:withError:)]){
                    [afDelegate afPlaceReportWSFailed:self toDelete:reference withError:err];
                
                }else if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceReportWSFailed:withError:)]){
                    [afDelegate afPlaceReportWSFailed:self withError:err];
                }
                
            }
            else{
                if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceReportWSFailed:toAdd:withError:)]){
                    [afDelegate afPlaceReportWSFailed:self toAdd:name withError:err];
                }else if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceReportWSFailed:withError:)]){
                    [afDelegate afPlaceReportWSFailed:self withError:err];
                }
                
            } 
            return;
        }
        if (isDeleting){
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceReportWS:succesfullyDeleted:)]){
                [afDelegate afPlaceReportWS:self succesfullyDeleted:reference];
            }else if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceReportWSSucceeded)]){
                [afDelegate afPlaceReportWSSucceeded:self];
            }
        }
        else{
            NSString *newRef = [jsonResult objectForKey:@"reference"];
            NSString *newId = [jsonResult objectForKey:@"id"];
            
            if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceReportWS:succesfullyAdded:withId:)]){
                [afDelegate afPlaceReportWS:self succesfullyAdded:newRef withId:newId];
            }else if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceReportWSSucceeded)]){
                [afDelegate afPlaceReportWSSucceeded:self];
            }
        }
        
    }
}

-(void)requestRedirected:(ASIHTTPRequest *)req{
    
}

-(void) requestStarted:(ASIHTTPRequest *)req{
    NSString *str = [[NSString alloc] initWithData:req.postBody  encoding:NSUTF8StringEncoding];
    if (WS_DEBUG) NSLog(@"Request started with POST content %@",str);
    [str release];
    if (afDelegate!=NULL && [afDelegate respondsToSelector:@selector(afPlaceReportWSStarted:)]){
        [afDelegate afPlaceReportWSStarted:self];
    }
}

-(void) dealloc{
    
    afDelegate = nil;
    
    [reference release];
    reference = nil;
}

@end
