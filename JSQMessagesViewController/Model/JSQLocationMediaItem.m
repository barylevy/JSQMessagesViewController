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

#import "JSQLocationMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "JSQMessagesLocationView.h"
#import "UIColor+JSQMessages.h"


@interface JSQLocationMediaItem ()

@property (strong, nonatomic) UIImage *cachedMapSnapshotImage;

@property (strong, nonatomic) JSQMessagesLocationView *cachedLocationMediaView;

@end


@implementation JSQLocationMediaItem

#pragma mark - Initialization

- (instancetype)initWithLocation:(CLLocation *)location
{
    self = [super init];
    if (self) {
        [self setLocation:location withCompletionHandler:nil];
    }
    return self;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedLocationMediaView = nil;
    _cachedMapSnapshotImage = nil;

}

#pragma mark - Setters

- (void)setLocation:(CLLocation *)location
{
    [self setLocation:location withCompletionHandler:nil];
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    
    _cachedLocationMediaView = nil;
}

#pragma mark - Map snapshot

- (void)setLocation:(CLLocation *)location withCompletionHandler:(JSQLocationMediaItemCompletionBlock)completion
{
    [self setLocation:location region:MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0) withCompletionHandler:completion];
}

- (void)setLocation:(CLLocation *)location region:(MKCoordinateRegion)region withCompletionHandler:(JSQLocationMediaItemCompletionBlock)completion
{
    _location = [location copy];
    
    _cachedLocationMediaView = nil;
    
    if (_location == nil) {
        return;
    }
    
    [self createMapViewSnapshotForLocation:_location
                          coordinateRegion:region
                     withCompletionHandler:completion];
}

- (void)createMapViewSnapshotForLocation:(CLLocation *)location
                        coordinateRegion:(MKCoordinateRegion)region
                   withCompletionHandler:(JSQLocationMediaItemCompletionBlock)completion
{
    NSParameterAssert(location != nil);
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = region;
    options.size = [self mediaViewDisplaySize];
    options.scale = [UIScreen mainScreen].scale;
    
    MKMapSnapshotter *snapShotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    
    [snapShotter startWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
              completionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
                  if (snapshot == nil) {
                      NSLog(@"%s Error creating map snapshot: %@", __PRETTY_FUNCTION__, error);
                      return;
                  }
                  
                  MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
                  CGPoint coordinatePoint = [snapshot pointForCoordinate:location.coordinate];
                  UIImage *image = snapshot.image;
                  
                  coordinatePoint.x += pin.centerOffset.x - (CGRectGetWidth(pin.bounds) / 2.0);
                  coordinatePoint.y += pin.centerOffset.y - (CGRectGetHeight(pin.bounds) / 2.0);
                  
                  UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
                  {
                      [image drawAtPoint:CGPointZero];
                      [pin.image drawAtPoint:coordinatePoint];
                      self.cachedMapSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
                  }
                  UIGraphicsEndImageContext();
                  
                  
                    dispatch_async(dispatch_get_main_queue(), ^(){
                          self.cachedLocationMediaView.mapImage.image = self.cachedMapSnapshotImage;
                          if (completion) {
                              completion();
                          }
                      });
                  
              }];
}
- (void)createGoogleMapViewSnapshotForLocation:(CLLocation *)location
                        coordinateRegion:(MKCoordinateRegion)region
                   withCompletionHandler:(JSQLocationMediaItemCompletionBlock)completion
{
    CGFloat yourLatitude = location.coordinate.latitude;
    CGFloat yourLongitude = location.coordinate.longitude;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGSize size = [self mediaViewDisplaySize];
        NSString *staticMapUrl = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?markers=color:red|%f,%f&sensor=true&zoom=%d&size=280x250",yourLatitude, yourLongitude,17];
        
        
        NSURL *mapUrl = [NSURL URLWithString:[staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:mapUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.cachedLocationMediaView.mapImage.image = image;
            
            if (completion!=nil) {
                completion();
            }
        });
    });
    
}
#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}
- (CGSize)mediaViewDisplaySize
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return CGSizeMake(315.0f, 225.0f);
    }
    
    return CGSizeMake(280.0f, 256.0f);
}
#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.location == nil ) {
        return nil;
    }
    
    if (self.cachedLocationMediaView == nil) {
        
        CGSize size = [self mediaViewDisplaySize];
        
        JSQMessagesLocationView *locationView = [[[NSBundle bundleForClass:[JSQMessagesLocationView class]] loadNibNamed:@"JSQMessagesLocationView" owner:self options:nil] objectAtIndex:0];
        
        locationView.backgroundColor = [UIColor jsq_messageBubbleLightGrayColor];
        UIImageView *imageView = locationView.mapImage;
        imageView.layer.cornerRadius = 16.0f;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        imageView.image = self.cachedMapSnapshotImage;
        
        
        NSString* locationName = [self.locationDetails objectForKey:JSQLocationMediaItem_LOCATION_NAME];
        NSString* locationAddress = [self.locationDetails objectForKey:JSQLocationMediaItem_LOCATION_DESCRIPTION];
        NSString* locationDetails = nil;
        
        
        if ( locationName != nil)
        {
            locationDetails = locationName;
            
            if( locationDetails != nil  )
            {
                [locationDetails stringByAppendingString:@"\n"];
            }
        }
        if(locationAddress!=nil)
            [locationDetails stringByAppendingString:locationAddress];
        
        locationView.locDesc.text = locationDetails;
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:locationView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        
        self.cachedLocationMediaView = locationView;
    }
    
    return self.cachedLocationMediaView;
    
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (![super isEqual:object]) {
        return NO;
    }
    
    JSQLocationMediaItem *locationItem = (JSQLocationMediaItem *)object;
    
    return [self.location isEqual:locationItem.location];
}

- (NSUInteger)hash
{
    return super.hash ^ self.location.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: location=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.location, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.location = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(location))];
        self.cachedLocationMediaView = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(cachedLocationMediaView))];
        self.locationDetails = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(locationDetails))];
        
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:self.cachedLocationMediaView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        
        self.cachedLocationMediaView.mapImage.layer.cornerRadius = 6.0f;
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.location forKey:NSStringFromSelector(@selector(location))];
    [aCoder encodeObject:self.cachedLocationMediaView forKey:NSStringFromSelector(@selector(cachedLocationMediaView))];
    [aCoder encodeObject:self.locationDetails forKey:NSStringFromSelector(@selector(locationDetails))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQLocationMediaItem *copy = [[[self class] allocWithZone:zone] initWithLocation:self.location];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
