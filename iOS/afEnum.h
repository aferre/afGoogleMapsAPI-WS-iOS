//
//  gdzSingleton.h
//
//  Created by Guillaume DROULEZ on 11/05/10.
//  Copyright 2010 thegdz.net. All rights reserved.
//


//
// Macro to place in interface (MyClassName.h)
//
// DECLARE_SINGLETON_FOR_CLASS(MyClassName)
//    => +(MyClassName *)sharedMyClassName method definition
//

#define DECLARE_ENUM(tenum)\
\
+(NSString *) tenum##StringFromObjectType:(tenum) type;\
\
+(tenum) tenum##FromString:(NSString *) string;\
+(NSInteger ) tenum##Count;\

#define SYNTHESIZE_ENUM(tenum)\
\
+(NSString *) tenum##StringFromObjectType:(tenum) type { \
return tenum##AsStrings[type]; \
} \
+(tenum) tenum##FromString:(NSString *) string { \
for (NSInteger idx = 0; (idx < tenum##Number); idx += 1) \
if ([string isEqualToString: tenum##AsStrings[idx]]) \
return idx; \
return -1; \
}\
+(NSInteger) tenum##Count{ \
 return tenum##Number;\
}\
+(NSArray *) tenum##Names{ \
\
NSMutableArray *ar = [NSMutableArray arrayWithCapacity:tenum##Number];\
for (NSInteger idx = 0; (idx < tenum##Number); idx += 1) \
[ar addObject:tenum##AsStrings[idx]];\
return ar; \
}
