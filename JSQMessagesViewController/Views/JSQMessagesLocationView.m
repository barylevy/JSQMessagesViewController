//
//  Created by Bary Levy (2016).
//  barylevy@gmail.com
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesLocationView.h"

@implementation JSQMessagesLocationView

#pragma mark - NSCoding
- (instancetype)initWithImage:(UIImageView*)image withDesc:(UITextView*)locDesc
{
    self = [super init];
    if(self)
    {
        self.mapImage = image.copy;
        self.locDesc = locDesc;        
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.mapImage = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(mapImage))];
        self.locDesc = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(locDesc))];        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.mapImage forKey:NSStringFromSelector(@selector(mapImage))];
    [aCoder encodeObject:self.locDesc forKey:NSStringFromSelector(@selector(locDesc))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQMessagesLocationView *copy = [[[self class] allocWithZone:zone] initWithImage:self.mapImage withDesc:self.locDesc];
    
    return copy;
}

@end
