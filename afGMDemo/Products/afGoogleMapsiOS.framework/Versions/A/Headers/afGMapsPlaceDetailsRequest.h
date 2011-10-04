//
//  afGMapsPlaceDetailsRequest.h
//  afGMDemo
//
//  Created by adrien ferré on 01/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "afGMapsPlacesRequest.h"
#import "AddressComponent.h"

@class PlaceDetails;

@protocol afGoogleMapsPlaceDetailsDelegate;

@interface afGMapsPlaceDetailsRequest : afGMapsPlacesRequest

@property (nonatomic,assign) id<afGoogleMapsPlaceDetailsDelegate> afDelegate;

//provided
@property (nonatomic,retain) NSString *reference;

//returned
@property (nonatomic,retain) PlaceDetails *details;
@property (nonatomic,retain) NSArray *htmlAttributions;

@end

@protocol afGoogleMapsPlaceDetailsDelegate <NSObject>
@optional
-(void) afPlaceDetailsWSStarted:(afGMapsPlaceDetailsRequest *)ws ;

-(void) afPlaceDetailsWS:(afGMapsPlaceDetailsRequest *)ws gotDetails:(PlaceDetails *)details htmlAttributions:(NSArray *)htmlAttributions;

-(void) afPlaceDetailsWSFailed:(afGMapsPlaceDetailsRequest *)ws withError:(NSError *)er;

@end

@interface PlaceDetails : NSObject {
    
}
@property (nonatomic,retain) NSString *vicinity;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *formattedPhoneNumber;
@property (nonatomic,retain) NSString *formattedAddress;
@property (nonatomic,retain) NSArray *addressComponents;
@property (nonatomic,retain) NSArray *types;
@property (nonatomic,retain) NSURL *urlURL;
@property (nonatomic,retain) NSURL *urlICON;
@property (nonatomic,retain) NSString *reference;
@property (nonatomic,retain) NSString *theId;
@property (nonatomic,assign) double rating;

+(PlaceDetails *) parseJsonDico:(NSDictionary *)jsonDico;
@end