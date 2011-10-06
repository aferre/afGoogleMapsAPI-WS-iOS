//
//  Place.m
//  afGMDemo
//
//  Created by adrien ferré on 02/10/11.
//  Copyright 2011 Ferré. All rights reserved.
//

#import "Place.h"

@implementation Place

@synthesize theid,reference,iconURL,geometry,types,vicinity,name;

+(Place *)parseJsonDico:(NSDictionary *)jsonDico{
    
    Place *p = [[[Place alloc]init]autorelease];
    
    NSString *_theID = [[jsonDico objectForKey:@"id"] copy];
    p.theid = _theID;
    [_theID release];
    
    NSString *ref = [[jsonDico objectForKey:@"reference"] copy];
    p.reference = ref;
    [ref release];
    NSURL *icon = [[NSURL alloc] initWithString:[jsonDico objectForKey:@"icon"]];
    p.iconURL = icon;
    [icon release];
    p.geometry = [Geometry parseJsonDico:[jsonDico objectForKey:@"geomtery"]];
    NSString *_vicinity = [[jsonDico objectForKey:@"vicinity"] copy];
    p.vicinity = _vicinity;
    [_vicinity release];
    
    NSString *_name = [[jsonDico objectForKey:@"name"] copy];
    p.name = _name;
    [_name release];
    
    NSArray *_types = [[jsonDico objectForKey:@"types"] copy];
    p.types = _types;
    [_types release];
    
    return p;
}

-(NSString *)textualDesc{
    NSString *str = @"";
    str = [str stringByAppendingFormat:@"ID : %@",theid];
    str = [str stringByAppendingFormat:@"\nRef : %@",reference];
    str = [str stringByAppendingFormat:@"\nName : %@",name];
    str = [str stringByAppendingFormat:@"\nIconURL : %@",iconURL];
    str = [str stringByAppendingFormat:@"\nVicinity : %@",vicinity];
    return str;
}
@end
