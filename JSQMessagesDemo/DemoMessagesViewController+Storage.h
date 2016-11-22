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
#import "DemoMessagesViewController.h"

static NSString* demoChatId = @"chatId-XXX";

@interface DemoMessagesViewController (Storage)

+(void) deleteStorageOfChat:(NSString*)chatId;

+(bool) isChatExist:(NSString*)chatId;

-(void)loadData;

-(void) storeData;
@end
