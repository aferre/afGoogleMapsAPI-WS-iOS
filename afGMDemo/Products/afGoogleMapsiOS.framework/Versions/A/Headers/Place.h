//
//  Place.h
//  afGMDemo
//
//  Created by adrien ferré on 02/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Geometry.h"

@interface Place : NSObject 

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *vicinity;
@property (nonatomic,retain) NSString *reference;
@property (nonatomic,retain) NSString *theid;
@property (nonatomic,retain) NSArray *types;
@property (nonatomic,retain) NSURL *iconURL;
@property (nonatomic,retain) Geometry *geometry;

+(Place *)parseJsonDico:(NSDictionary *)jsonDico;

-(NSString *) textualDesc;

@end
