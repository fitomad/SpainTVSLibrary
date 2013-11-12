#import "DSSpainTVSClient.h"
#import "DSSpainTVSVideoInfo.h"

@interface DSSpainTVSClient ()
/*!  */
@property (nonatomic) NSString *baseURL;

/*!
	
*/
- (NSURL *) formatURLWithString:(NSString *) string;
@end

@implementation DSSpainTVSClient
//
// 
//
+ (instancetype) sharedClient
{
	static DSSpainTVSClient *client;
	static dispatch_once_t token;

	dispatch_once(&token, ^
	{
		client = [[DSSpainTVSClient alloc] init];
	});

	return client;
}

//
//
//
- (id) init
{
	self = [super init];

	if(self)
	{
		self.baseURL = @"http://www.pydowntv.com/api/";
	}

	return self;
}

//
//
//
- (void) recoverVideoInfo:(NSString *) url completionHandler:(void (^)(NSArray *info, NSError *error)) completionHandler
{
	NSURL *url_api = [self formatURLWithString:url];
	NSURLSession *httpRequestSession = [NSURLSession sharedSession];

	NSURLSessionDataTask *dataTask = [httpRequestSession dataTaskWithURL:url_api completionHandler:^(NSData *data, NSURLResponse *response, NSError *errorHttp)
	{
		if(errorHttp)
		{
			completionHandler(nil, errorHttp);
		}

		// procesamos el resultado del API
		NSError *json_error = nil;
		NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&json_error];

		NSNumber *num_videos = results[@"num_videos"];
		NSArray *array_descripciones = results[@"descs"];
		NSArray *array_titulos = results[@"titulos"];
		NSArray *array_videos = results[@"videos"];

		NSMutableArray *videos_info = [NSMutableArray array];

		for(int x = 0; x < [num_videos intValue]; x++)
		{
			NSDictionary *video_dictionary = [array_videos objectAtIndex:x];

			DSSpainTVSVideoInfo *video_info = [[DSSpainTVSVideoInfo alloc] init];

			video_info.descripcion = [array_descripciones objectAtIndex:x];
			video_info.titulo = [array_titulos objectAtIndex:x];
			video_info.partes = video_dictionary[@"partes"];
			video_info.imagen = [NSURL URLWithString:video_dictionary[@"url_img"]];
			video_info.filenames = video_dictionary[@"filename"];
			video_info.URLS = video_dictionary[@"url_video"];

			[videos_info addObject:video_info];
		}		

		completionHandler(videos_info, nil);
	}];

	[dataTask resume];
}

//
//
//
- (void) recoverVideoImage:(NSString *) imageURL completionHandler:(void (^)(UIImage *imagen, NSError *error)) completionHandler
{
	NSURL *url = [NSURL URLWithString:imageURL];
	NSURLSession *httpImageSession = [NSURLSession sharedSession];

	NSURLSessionDataTask *dataTask = [httpImageSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *httpError)
	{
		if(errorHttp)
		{
			completionHandler(nil, errorHttp);
		}

		UIImage *imagenVideo = [UIImage imageWithData:data];

		completionHandler(imagenVideo, nil);
	}];

	[dataTask resume];
}

//
//
//
- (void) downloadFromURL:(NSString *) videoURL
{ 
	NSURL *url = [NSURL URLWithString:videoURL];
	NSURLSessionConfiguration *httpConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

	NSURLSession *httpDownload = [NSURLSession sessionWithConfiguration:httpConfig 
			                                                   delegate:self 
			                                              delegateQueue:nil];

	NSURLSessionDownloadTask *httpDownload = [[NSURLSession sharedSession] downloadTaskWithURL:url];

	[httpDownload resume];
}

#pragma mark - Metodo privados
//
//
//
- (NSURL *) formatURLWithString:(NSString *) string
{
	NSString *url_complete = [[NSString alloc] initWithFormat:@"%@%@", self.baseURL, string];

	return [NSURL URLWithString:url_complete];
}

#pragma mark - Metodos del protocolo NSURLSessionDownloadDelegate
//
// 
//
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
	if([self.delegate respondsToSelector:@selector(SpainTVSClient:didFinishDownloading:)])
	{
		[self.delegate SpainTVSClient:self didFinishDownloading:location];
	}
}

//
//
//
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
	// Nothing TODO
}

//
//
//
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
	if([self.delegate respondsToSelector:@selector(SpainTVSClient:bytesDownloaded:bytesRemaining:)])
	{
		[self.delegate SpainTVSClient:self bytesDownloaded:totalBytesWritten bytesRemaining:totalBytesExpectedToWrite];
	}
}
@end