//
//  afGMapsPlaceCheckinRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlacesRequest.h"

@protocol afGoogleMapsPlaceCheckinDelegate;

@interface afGMapsPlaceCheckinRequest : afGMapsPlacesRequest {    
    
    
    id<afGoogleMapsPlaceCheckinDelegate>  afDelegate;
    
    NSString *reference;
}

@property (nonatomic,assign) id<afGoogleMapsPlaceCheckinDelegate> afDelegate;
@property (nonatomic,retain) NSString * reference;

@end

@protocol afGoogleMapsPlaceCheckinDelegate <NSObject>
@optional
-(void) afPlaceCheckinWSStarted:(afGMapsPlaceCheckinRequest *)ws ;

-(void) afPlaceCheckinWSSucceeded:(afGMapsDistanceRequest *)ws;

-(void) afPlaceCheckinWSFailed:(afGMapsPlaceCheckinRequest *)ws withError:(NSError *)er;

@end