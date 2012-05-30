/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "JRPluralLevelTwo.h"

@interface NSArray (PluralLevelThreeToFromDictionary)
- (NSArray*)arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeObjects;
- (NSArray*)arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionaries;
@end

@implementation NSArray (PluralLevelThreeToFromDictionary)
- (NSArray*)arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPluralLevelThree class]])
            [filteredDictionaryArray addObject:[(JRPluralLevelThree*)object dictionaryFromObject]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionaries
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredDictionaryArray addObject:[JRPluralLevelThree pluralLevelThreeObjectFromDictionary:(NSDictionary*)dictionary]];

    return filteredDictionaryArray;
}
@end

@implementation JRPluralLevelTwo
@synthesize pluralLevelTwoId;
@synthesize level;
@synthesize name;
@synthesize pluralLevelThree;

- (id)init
{
    if ((self = [super init]))
    {
    }
    return self;
}

+ (id)pluralLevelTwo
{
    return [[[JRPluralLevelTwo alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{
    JRPluralLevelTwo *pluralLevelTwoCopy =
                [[JRPluralLevelTwo allocWithZone:zone] init];

    pluralLevelTwoCopy.pluralLevelTwoId = self.pluralLevelTwoId;
    pluralLevelTwoCopy.level = self.level;
    pluralLevelTwoCopy.name = self.name;
    pluralLevelTwoCopy.pluralLevelThree = self.pluralLevelThree;

    return pluralLevelTwoCopy;
}

+ (id)pluralLevelTwoObjectFromDictionary:(NSDictionary*)dictionary
{
    JRPluralLevelTwo *pluralLevelTwo =
        [JRPluralLevelTwo pluralLevelTwo];

    pluralLevelTwo.pluralLevelTwoId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];
    pluralLevelTwo.level = [dictionary objectForKey:@"level"];
    pluralLevelTwo.name = [dictionary objectForKey:@"name"];
    pluralLevelTwo.pluralLevelThree = [(NSArray*)[dictionary objectForKey:@"pluralLevelThree"] arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionaries];

    return pluralLevelTwo;
}

- (NSDictionary*)dictionaryFromObject
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];


    if (pluralLevelTwoId)
        [dict setObject:[NSNumber numberWithInt:pluralLevelTwoId] forKey:@"id"];

    if (level)
        [dict setObject:level forKey:@"level"];

    if (name)
        [dict setObject:name forKey:@"name"];

    if (pluralLevelThree)
        [dict setObject:[pluralLevelThree arrayOfPluralLevelThreeDictionariesFromPluralLevelThreeObjects] forKey:@"pluralLevelThree"];

    return dict;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"pluralLevelTwoId"])
        self.pluralLevelTwoId = [(NSNumber*)[dictionary objectForKey:@"id"] intValue];

    if ([dictionary objectForKey:@"level"])
        self.level = [dictionary objectForKey:@"level"];

    if ([dictionary objectForKey:@"name"])
        self.name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"pluralLevelThree"])
        self.pluralLevelThree = [(NSArray*)[dictionary objectForKey:@"pluralLevelThree"] arrayOfPluralLevelThreeObjectsFromPluralLevelThreeDictionaries];
}

- (void)dealloc
{
    [level release];
    [name release];
    [pluralLevelThree release];

    [super dealloc];
}
@end
