#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


//#import "CDVCommandDelegate.h"

//enum CDVTransferFile {
//    FILE_NOT_FOUND_ERR = 1,
//    INVALID_URL_ERR = 2,
//    CONNECTION_ERR = 3,
//    CONNECTION_ABORTED = 4
//};
//typedef int CDVTransferFileError;
//
//enum CDVTransferFileDirection {
//    CDV_TRANSFER_UPLOAD = 1,
//    CDV_TRANSFER_DOWNLOAD = 2,
//};
//typedef int CDVTransferFileDirection;


@interface MyPlugin : CDVPlugin<NSURLSessionDelegate> {
    
    NSMutableData*              _receivedData;
    NSURLConnection*            _conn;
    NSURL*                      _videoUrl;
    UIBackgroundTaskIdentifier backgroundTaskID;
    NSOperationQueue* queue;
    NSString* callbackId;
    CDVInvokedUrlCommand* commandInstance;
    int responseCode;
    NSString* source;
    NSString* target;
    NSString* filePath;
    NSString* server;
    NSString* fileKey;
    NSString* fileName;
    NSString* mimeType;
    NSString* httpMethod;
}


- (void)sayHello:(CDVInvokedUrlCommand*)command;

- (void) messageAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate;

- (NSMutableData*)getVideoData:(NSString*)userName password:(NSString*)passowrd caption:(NSString*)caption
                     videoData:(NSData*)data comment:(int)comment withFileKey:(NSString *)fileKey andFileName:(NSString *)fileName;


@end