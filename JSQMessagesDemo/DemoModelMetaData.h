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

#import <Foundation/Foundation.h>

@interface DemoModelMetaData : NSObject  <NSCoding>

@property (strong, nonatomic) NSString *lastMessage;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSDate *lastUpdate;

-(void)updateLastMessage:(NSString*)message;

@end
