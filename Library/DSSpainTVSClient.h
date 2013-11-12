#import <Foundation/Foundation.h>

/*!

*/
@protocol DSSpainTVSDownloadDelegate <NSObject>
/*!

*/
- (void) SpainTVSClient:(id) client bytesDownloaded:(NSUInteger) bytesDownload bytesRemaining:(NSUInteger) bytesRemaining;

/*!

*/
- (void) SpainTVSClient:(id) client didFinishDownloading:(NSURL *) fileLocation;
@end

/*!

*/
@interface DSSpainTVSClient : NSObject <NSURLSessionDownloadDelegate>
/*!  */
@property (nonatomic, weak) id<DSSpainTVSDownloadDelegate> delegate;

/*!
 
 */
+ (instancetype) sharedClient;

/*!

*/
- (void) recoverVideoInfo:(NSString *) url completionHandler:(void (^)(NSArray *info, NSError *error)) completionHandler;

/*!

*/
- (void) recoverVideoImage:(NSString *) imageURL completionHandler:(void (^)(UIImage *imagen, NSError *error)) completionHandler;

/*!
	
*/
- (void) downloadFromURL:(NSString *) videoURL;
@end