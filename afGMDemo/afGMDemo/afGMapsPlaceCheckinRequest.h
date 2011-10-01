//
//  afGMapsPlaceCheckinRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlacesRequest.h"

@protocol afGoogleMapsPlaceCheckinDelegate;

@interface afGMapsPlaceCheckinRequest : afGMapsPlacesRequest

@property (nonatomic,assign) id<afGoogleMapsPlaceCheckinDelegate> afDelegate;
@property (nonatomic,retain) NSString * reference;

@end

@protocol afGoogleMapsPlaceCheckinDelegate <NSObject>
@optional
-(void) afPlaceCheckinWSStarted:(afGMapsPlaceCheckinRequest *)ws ;

-(void) afPlaceCheckinWSSucceeded:(afGMapsPlaceCheckinRequest *)ws;

-(void) afPlaceCheckinWSFailed:(afGMapsPlaceCheckinRequest *)ws withError:(NSError *)er;

@end