#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 	Wrapper del delegado NSURLSessionDownloadDelegate
*/
@protocol DSSpainTVSDownloadDelegate <NSObject>
/*!

*/
- (void) SpainTVSClient:(id) client bytesDownloaded:(NSUInteger) bytesDownload bytesRemaining:(NSUInteger) bytesRemaining;

/*!

*/
- (void) SpainTVSClient:(id) client didFinishDownloading:(NSURL *) fileLocation;

/*!

*/
- (void) SpainTVSClient:(id) client resumeDownloadingAtOffset:(NSUInteger) offset expectedTotalBytes:(NSUInteger) totalBytes;
@end

/*!

*/
@interface DSSpainTVSClient : NSObject <NSURLSessionDownloadDelegate>
/*!  */
@property (nonatomic, weak) id<DSSpainTVSDownloadDelegate> delegate;

/*!
    Instancia para el singleton
 */
+ (instancetype) sharedClient;

/*!

*/
- (void) recoverVideoInfo:(NSString *) url completionHandler:(void (^)(NSArray *info, NSError *error)) completionHandler;

/*!

*/
- (void) recoverVideoImage:(NSURL *) imageURL completionHandler:(void (^)(UIImage *imagen, NSError *error)) completionHandler;

/*!
	
*/
- (NSURLSessionDownloadTask *) downloadFromURL:(NSString *) videoURL;

/*!

*/
- (NSURL *) cancelDownloadFromSession:(NSURLSessionDownloadTask *) downloadTask;

/*!

*/
- (void) resumeVideoDownload:(NSString *) downloadFile;
@end
