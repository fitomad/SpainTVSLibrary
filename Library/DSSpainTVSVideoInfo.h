#import <Foundation/Foundation.h>

@interface DSSpainTVSVideoInfo : NSObject
/*! Descripcion del video */
@property (nonatomic) NSString *descripcion;
/*! Titulo del programa */
@property (nonatomic) NSString *titulo;
/*! Partes en las que se divide el video */
@property (nonatomic) NSNumber *partes;
/*! Imagen del programa */
@property (nonatomic) NSURL *imagen;
/*! Archivos de video */
@property (nonatomic) NSArray *filenames;
/*! URLS de los archivos de video */
@property (nonatomic) NSArray *URLS;

/*!
    Enumera todos los archivos con sus respectivas URL que conforman un video.
 
    @param enumeratorBlock
        Bloque que contiene el nombre del archivo, su URL, y el indice que ocupa
*/
- (void) enumerateFilenamesAndURLsUsingBlock:(void (^)(NSString *filename, NSURL *url, NSUInteger idx)) enumeratorBlock;
@end
