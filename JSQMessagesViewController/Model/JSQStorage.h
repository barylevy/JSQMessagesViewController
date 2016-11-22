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

#define DOCUMENT_DIRECTORY          [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define PATH_CHAT_DAT_FILE(chatId)          [NSString stringWithFormat:@"%@/JSQ_MESSAGES/%@/%@.dat",   DOCUMENT_DIRECTORY, chatId, chatId]
#define PATH_CHAT_META_DAT_FILE(chatId)     [NSString stringWithFormat:@"%@/JSQ_MESSAGES/%@/%@.meta.dat",   DOCUMENT_DIRECTORY, chatId, chatId]
#define PATH_CHAT_DIR(chatId)               [NSString stringWithFormat:@"%@/JSQ_MESSAGES/%@/",         DOCUMENT_DIRECTORY, chatId]
#define PATH_CHAT_MEDIA_DIR_ABS(chatId)     [NSString stringWithFormat:@"%@/JSQ_MESSAGES/%@/media/",   DOCUMENT_DIRECTORY,chatId]
#define PATH_CHAT_MEDIA_DIR_LOCAL(chatId)   [NSString stringWithFormat:@"JSQ_MESSAGES/%@/media/",      chatId]
#define PATH_TASK_DIR()                     [NSString stringWithFormat:@"%@/JSQ_MESSAGES/",            DOCUMENT_DIRECTORY]

/**
 *  The `JSQStorage` class is a gateway class for persist message objects.
 *  The message can be a text message or media message
 *  The message is saved under 'JSQ_MESSAGES' directory.
 *  It can be loaded or saved when view controlled is appeared.
 *  All the element media, like photos/video/audio is saved in 'JSQ_MESSAGES/CHAT_ID/media/media_random_name'
 */

@interface JSQStorage : NSObject

+(id) loadMessageData:(NSString*)chatId;

+(id) loadMessageMetaData:(NSString*)chatId;

+(void) storeMessageData:(NSData*) data withMetaData:(NSData*) metaData withKey:(NSString*) chatId onComplete:(void(^)())onComplete;

+(NSString*) createPathForChat:(NSString*)chatId;

+(NSString*) createNameForMediaItem:chatId;

+(NSData*) loadMediaFromDisk:(NSString*)mediaFileName;

+(void) saveMediaToDisk:(NSString*)mediaFileName withMediaData:(NSData*)mediaData;

+(void) saveExternalURL:(NSURL *)url toMediaPath:(NSString*)mediaPath withChatId:(NSString*)chatId;

+(void) deleteChatFromDisk:(NSString*)chatId;

+(void) deleteMediaFromDisk:(NSString*)mediaPath;

+(bool) isChatExist:(NSString*)chatId;

@end
