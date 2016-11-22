//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
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

#import "JSQMessagesBubbleImage.h"

@implementation JSQMessagesBubbleImage

#pragma mark - Initialization

- (instancetype)initWithMessageBubbleImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    NSParameterAssert(image != nil);
    NSParameterAssert(highlightedImage != nil);
    
    self = [super init];
    if (self) {
        _messageBubbleImage = image;
        _messageBubbleHighlightedImage = highlightedImage;
    }
    return self;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: messageBubbleImage=%@, messageBubbleHighlightedImage=%@>",
            [self class], self.messageBubbleImage, self.messageBubbleHighlightedImage];
}

- (id)debugQuickLookObject
{
    return [[UIImageView alloc] initWithImage:self.messageBubbleImage highlightedImage:self.messageBubbleHighlightedImage];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithMessageBubbleImage:[UIImage imageWithCGImage:self.messageBubbleImage.CGImage]
                                                        highlightedImage:[UIImage imageWithCGImage:self.messageBubbleHighlightedImage.CGImage]];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_messageBubbleImage forKey:@"messageBubbleImage"];
    
    [aCoder encodeObject:_messageBubbleHighlightedImage forKey:@"messageBubbleHighlightedImage"];
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _messageBubbleImage = [coder decodeObjectForKey:@"messageBubbleImage"];
        
        _messageBubbleHighlightedImage = [coder  decodeObjectForKey:@"messageBubbleHighlightedImage"];
    }
    return self;
}
@end
