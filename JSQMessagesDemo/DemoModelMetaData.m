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

#import "DemoModelMetaData.h"

@implementation DemoModelMetaData

-(void)updateLastMessage:(NSString*)message
{
    self.lastMessage = message;
    self.lastUpdate = [NSDate date];
}
#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.lastMessage forKey:@"lastMessage"];
    [aCoder encodeObject:self.lastUpdate forKey:@"lastUpdate"];
    [aCoder encodeObject:self.title forKey:@"title"];
    
    
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.lastMessage = [coder decodeObjectForKey:@"lastMessage"];
        self.lastUpdate = [coder decodeObjectForKey:@"lastUpdate"];
        self.title = [coder decodeObjectForKey:@"title"];
    }
    return self;
}

@end
