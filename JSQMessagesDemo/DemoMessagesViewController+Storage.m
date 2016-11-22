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

#import "DemoMessagesViewController+Storage.h"
#import "JSQStorage.h"

@implementation DemoMessagesViewController (Storage)

+(void) deleteStorageOfChat:(NSString*)chatId
{
    [JSQStorage deleteChatFromDisk:chatId];
}
+(bool) isChatExist:(NSString*)chatId
{
    return [JSQStorage isChatExist:chatId];
}

-(void) loadData
{
    [JSQStorage createPathForChat:demoChatId];
    
    id data = [JSQStorage loadMessageData:(demoChatId)];
    
    if( data == nil || [data length]==0)
    {
        self.demoData  = [[DemoModelData alloc] init];
    }
    else
    {
        self.demoData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    id metaData = [JSQStorage loadMessageMetaData:(demoChatId)];
    
    if( metaData == nil || [metaData length]==0)
    {
        self.demoMetaData  = [[DemoModelMetaData alloc] init];
    }
    else
    {
        self.demoMetaData = [NSKeyedUnarchiver unarchiveObjectWithData:metaData];
    }
    
}
-(void) storeData
{
    NSData* data = self.demoData.messages.count==0?[NSData new]: [NSKeyedArchiver archivedDataWithRootObject:self.demoData];
    NSData* metaData = [NSKeyedArchiver archivedDataWithRootObject:self.demoMetaData];
    
    [JSQStorage storeMessageData:data withMetaData:metaData withKey:demoChatId onComplete:^{
         
    }];
}
@end
