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
#define countof(array) (sizeof(array)/sizeof(array[1]))\

#define DECLARE_ENUM(tenum)\
\
+(NSString *) tenum##StringFromObjectType:(tenum) type;\
\
+(tenum) tenum##FromString:(NSString *) string;\

#define SYNTHESIZE_ENUM(tenum)\
\
+(NSString *) tenum##StringFromObjectType:(tenum) type { \
return tenum##AsStrings[type]; \
} \
+(tenum) tenum##FromString:(NSString *) string { \
for (NSInteger idx = 0; (idx < countof(tenum)); idx += 1) \
if ([string isEqualToString: tenum##AsStrings[idx]]) \
return idx; \
return -1; \
}
