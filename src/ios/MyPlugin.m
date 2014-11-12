#import "MyPlugin.h"
#import <Cordova/CDV.h>


#define kNotificationDeviceOrientation @"DidDeviceOrientation"


#define _ReleaseObj(obj) if(obj){[obj release];obj=nil;}

// video data start and end tag
#define kStartTag   @"--%@\r\n"
#define kEndTag     @"\r\n"
#define kContent    @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define kBoundary   @"---------------------------14737809831466499882746641449"

@implementation MyPlugin


- (void) messageAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message: msg
                                                   delegate: delegate cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [alert show];
}

// return video data
//- (NSMutableData*)getVideoData:(NSString*)userName password:(NSString*)passowrd caption:(NSString*)caption
//                     videoData:(NSData*)data comment:(int)comment withFileKey:(NSString *)fileKey andFileName:(NSString *)fileName
//{
//    NSMutableData *body = [NSMutableData data];
//    // Post To parameter
//    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:kContent, @"PostTo"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // PostType parameter
//    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:kContent ,@"PostType"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"VideoUpload" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // Comment parameter
//    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:kContent, @"comment"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"%d", comment] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // Object Type parameter
//    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:kContent, @"object_type"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"User" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // Video Desc parameter
//    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:kContent, @"video_desc"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[caption dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // video file
//    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mytxt" ofType:@"txt"];
//    NSData *fdata = [NSData dataWithContentsOfFile:filePath];
//    
//    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"fileName\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-Type: text/plain\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithData:fdata]];
//    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // close form
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    return body;
//}

- (void)sayHello:(CDVInvokedUrlCommand*)command
{
    commandInstance = command;
    
    backgroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self cancelTransfer:_conn];
    }];
    
    NSMutableURLRequest *request = nil;
    
    
    callbackId = command.callbackId;
    
    
       
    /* path, server, fileKey, name, mimeType, httpMethod */
    filePath = [command argumentAtIndex:0];
    target = filePath;
    //NSString *filpth = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
     server = [command argumentAtIndex:1];
    fileKey = [command argumentAtIndex:2 withDefault:@"file"];
    fileName = [command argumentAtIndex:3 withDefault:@"no-filename"];
    mimeType = [command argumentAtIndex:4 withDefault:nil];
    httpMethod = [command argumentAtIndex:5 withDefault:@"POST"];
    NSData* videoData = [NSData dataWithContentsOfFile:filePath];
    NSMutableData *body;
    if(videoData != nil) {
        request = [[NSMutableURLRequest alloc] init];
        //[request setURL:[NSURL URLWithString:@"http://snipmetv.com/api/upload"]];
        [request setURL:[NSURL URLWithString:server]];
        
        [request setHTTPMethod:httpMethod];
        [request setTimeoutInterval:30000];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",fileKey,fileName]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: video/mp4\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //[body appendData:[[NSString stringWithFormat:@"Content-Length: %ld\r\n\r\n", (long)[videoData length]] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:videoData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
    }
    //else
    //[self messageAlert:nil title:@"Video Size should not be more than 10 MB" delegate:self];
    
    if (_conn == nil) // condition for checking connection
    _conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    if (queue == nil) {
        queue = [[NSOperationQueue alloc] init];
    }
    [_conn setDelegateQueue:queue];
    [_conn start];
    videoData = nil;
    request = nil;
    //[self performSelectorOnMainThread:@selector(uploadVideo) withObject:nil waitUntilDone:NO];
    
}


- (void)cancelTransfer:(NSURLConnection*)connection
{
    
    [connection cancel];
}



//-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//{
//    //return YES to say that we have the necessary credentials to access the requested resource
//    return YES;
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    //some code here, continue reading to find out what comes here
//
//    NSString *userName = @"snipme";
//    NSString *password = @"snipme@543";
//
//    NSURLCredential *credential = [NSURLCredential credentialWithUser:userName
//                                                             password:password
//                                                          persistence:NSURLCredentialPersistenceForSession];
//    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response
{
    _receivedData = [[NSMutableData alloc]initWithLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"testing ");
    [self cancelTransfer:connection];
    _conn = nil;
    _receivedData = nil;
    queue = nil;
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error  description]];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    
}



- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    
    
    
    
    NSString *returnString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding] ;
    
    // remove background id task in case our upload was done in the background
    [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskID];
    backgroundTaskID = UIBackgroundTaskInvalid;
    [self cancelTransfer:connection];
    _conn = nil;
    _receivedData = nil;
    queue = nil;
    //[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:[self createFileTransferError:errorCode AndSource:source AndTarget:target]];
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Success"];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    
}




@end