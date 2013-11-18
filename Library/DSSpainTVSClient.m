#import "DSSpainTVSClient.h"
#import "DSSpainTVSVideoInfo.h"

@interface DSSpainTVSClient ()
/*! Path comun a todas peticiones del API */
@property (nonatomic) NSString *baseURL;

/*!
	Crea una URL v·lida del API con la que obtener los datos
	de un video

	@param videoURL
		La URL del website de la cadena de television que contiene el video
	@return 
		La URL para su uso con el API
*/
- (NSURL *) formatURLWithString:(NSString *) videoURL;

/*!
	Crea un nuevo nombre de archivo para el caso en que se 
	pause la descarga de alg˙n archivo y se quiera reintentar m·s
	adelante.

	Todos los archivo con los datos de descarga se almacenar·n en 
	el directorio Caches contenido en la carpeta Library de la App

	@return
		La URL con la localizacion del nuevo archivo.
*/
- (NSURL *) createCacheFile;
@end

@implementation DSSpainTVSClient
//
// Singleton
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
// Inicializador
//
- (id) init
{
	self = [super init];

	if(self)
	{
		self.baseURL = @"http://www.pydowntv.com/api";
	}

	return self;
}

//
// Recuperamos la informacion de un video
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
// Recuperamos la imagen asociada al video
//
- (void) recoverVideoImage:(NSURL *) imageURL completionHandler:(void (^)(UIImage *imagen, NSError *error)) completionHandler
{
	NSURLSession *httpImageSession = [NSURLSession sharedSession];

	NSURLSessionDataTask *dataTask = [httpImageSession dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *httpError)
	{
		if(httpError)
		{
			completionHandler(nil, httpError);
		}

		UIImage *imagenVideo = [UIImage imageWithData:data];

		completionHandler(imagenVideo, nil);
	}];

	[dataTask resume];
}

//
// Descarga un video
//
- (NSURLSessionDownloadTask *) downloadFromURL:(NSString *) videoURL
{ 
	NSURL *url = [NSURL URLWithString:videoURL];
	NSURLSessionConfiguration *httpConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

	NSURLSession *httpSession = [NSURLSession sessionWithConfiguration:httpConfig
			                                                   delegate:self 
			                                              delegateQueue:nil];

	NSURLSessionDownloadTask *httpDownload = [httpSession downloadTaskWithURL:url];

	[httpDownload resume];

	return httpDownload;
}

//
// Pausamos una descarga 
//
- (NSURL *) cancelDownloadFromSession:(NSURLSessionDownloadTask *) downloadTask
{
	__block NSURL *file_url = [self createCacheFile];

	[downloadTask cancelByProducingResumeData:^(NSData *resumeData)
	{
		BOOL saved = [resumeData writeToURL:file_url atomically:NO];

		if(!saved)
		{
			file_url = nil;
		}
	}];

	return file_url;
}

//
//
//
- (void) resumeVideoDownload:(NSString *) downloadFile
{
    // TODO
}

#pragma mark - Metodo privados
//
// Construye la URL para interrogar al API
//
- (NSURL *) formatURLWithString:(NSString *) videoURL
{
	NSString *url_complete = [[NSString alloc] initWithFormat:@"%@?url=%@", self.baseURL, videoURL];

	return [NSURL URLWithString:url_complete];
}

//
// Nombre de archivo para descargas pausadas
//
- (NSURL *) createCacheFile
{
	NSString *uuid = [[NSUUID UUID] UUIDString];
	NSString *file = [uuid stringByAppendingString:@".download"];

	NSArray *dirs = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
	NSURL *dir_url = (NSURL *) [dirs objectAtIndex:0];
	NSURL *file_url = [dir_url URLByAppendingPathComponent:file isDirectory:NO];

	return file_url;
}

#pragma mark - Metodos del protocolo NSURLSessionDownloadDelegate
//
// Avisa cuando termina una descarga
//
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *) location
{
	if([self.delegate respondsToSelector:@selector(SpainTVSClient:didFinishDownloading:)])
	{
		[self.delegate SpainTVSClient:self didFinishDownloading:location];
	}
}

//
//	Informa al delegado de que la tarea de descarga se ha reiniciado
//
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t) fileOffset expectedTotalBytes:(int64_t) expectedTotalBytes
{
	// Nothing TODO
}

//
// InformaciÛn sobre los bytes descargados en el momento en el que se invoca este mÈtodo
//
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t) bytesWritten totalBytesWritten:(int64_t) totalBytesWritten totalBytesExpectedToWrite:(int64_t) totalBytesExpectedToWrite
{
	if([self.delegate respondsToSelector:@selector(SpainTVSClient:bytesDownloaded:bytesRemaining:)])
	{
		[self.delegate SpainTVSClient:self bytesDownloaded:totalBytesWritten bytesRemaining:totalBytesExpectedToWrite];
	}
}
@end
