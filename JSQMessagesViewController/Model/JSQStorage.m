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

#import "JSQStorage.h"

@implementation JSQStorage

+(id) loadMessageData:(NSString*)chatId
{
    NSData *data = [NSData dataWithContentsOfFile:PATH_CHAT_DAT_FILE(chatId)];
    
    return data;
}
+(id) loadMessageMetaData:(NSString*)chatId
{
    NSData *data = [NSData dataWithContentsOfFile:PATH_CHAT_META_DAT_FILE(chatId)];
    
    return data;
}
+(void) storeMessageData:(NSData*) data withMetaData:(NSData*) metaData withKey:(NSString*) chatId onComplete:(void(^)())onComplete
{
    if( data== nil || chatId == nil)
        return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // Save it into file system
        [data writeToFile:PATH_CHAT_DAT_FILE(chatId) atomically:YES];
        [metaData writeToFile:PATH_CHAT_META_DAT_FILE(chatId) atomically:YES];
        
        if([data length] > 0 && onComplete)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                onComplete();
            });
        }
    });
}
+(NSString*) createPathForChat:(NSString*)chatId
{    
    id datFile = PATH_CHAT_DAT_FILE(chatId);
    id dirDatFile = PATH_CHAT_DIR(chatId);
    id dirMetaDatFile = PATH_CHAT_META_DAT_FILE(chatId);
    id dirMedia =   PATH_CHAT_MEDIA_DIR_ABS(chatId);
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:dirDatFile] == false)
    {
        NSError* error;
        [[NSFileManager defaultManager] createDirectoryAtPath:dirDatFile withIntermediateDirectories:true attributes:nil error:&error];
        if(error!=nil)
            NSLog(@"%@",error.description);
        
    }
    if( [[NSFileManager defaultManager] fileExistsAtPath:dirMedia] == false)
    {
        NSError* error;
        [[NSFileManager defaultManager] createDirectoryAtPath:dirMedia withIntermediateDirectories:true attributes:nil error:&error];
        if(error!=nil)
            NSLog(@"%@",error.description);
    }    
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:datFile] == false)
    {
        [[NSFileManager defaultManager] createFileAtPath:datFile contents:nil attributes:nil];
    }
    if( [[NSFileManager defaultManager] fileExistsAtPath:dirMetaDatFile] == false)
    {
        [[NSFileManager defaultManager] createFileAtPath:dirMetaDatFile contents:nil attributes:nil];
    }
    
    return chatId;

}

#pragma mark - save/load media
+(NSString*) createNameForMediaItem:chatId
{
    NSUInteger mediaName = [[NSDate date] timeIntervalSince1970]*10.0;
    
    NSString *fileName = [NSString stringWithFormat:@"%@%ld", PATH_CHAT_MEDIA_DIR_LOCAL(chatId), mediaName];
    
    return fileName;
}
+(NSData*) loadMediaFromDisk:(NSString*)mediaName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", DOCUMENT_DIRECTORY, mediaName];
    
    NSData *mediaData = [NSData dataWithContentsOfFile:filePath];
    
    return mediaData;
}
+(void) saveMediaToDisk:(NSString*)mediaName withMediaData:(NSData*)mediaData
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", DOCUMENT_DIRECTORY, mediaName];
    
    NSError* error;
    
    if(mediaData!=nil)
    {
        [mediaData writeToFile:filePath options:NSDataWritingAtomic error:&error];
    }
    if(error!=nil)
        NSLog(@"%@",error);
}

+(void)saveExternalURL:(NSURL *)url toMediaPath:(NSString*)mediaPath withChatId:(NSString*)chatId
{
    if (url != nil && [url isFileURL])
    {
        NSLog(@"saving url: %@ ...", url);
        
        NSError *error;
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", DOCUMENT_DIRECTORY, mediaPath];
        
        [[NSFileManager defaultManager] copyItemAtPath:[url path] toPath:filePath error:&error];
        
        if(error!=nil)
            NSLog(@"Copy Error: %@ ...", error);
        
    }
    
}
#pragma mark - delete media

+(void) deleteMediaFromDisk:(NSString*)mediaPath
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", DOCUMENT_DIRECTORY, mediaPath];
    
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if(!success)
        NSLog(@"Cannot delete file:%@",error.description);
}

+(void) deleteChatFromDisk:(NSString*)chatId
{
    NSError* error;
    
    BOOL res = [[NSFileManager defaultManager] removeItemAtPath:PATH_CHAT_DIR(chatId) error:&error];
    if(error!=nil)
        NSLog(@"Delete Error: %@ ...", error);
    else
        if(res)
        NSLog(@"Delete Error...");
    
}
+(bool) isChatExist:(NSString*)chatId
{
    NSData *data = [NSData dataWithContentsOfFile:PATH_CHAT_DAT_FILE(chatId)];
    return [data length] > 0;
}
@end
