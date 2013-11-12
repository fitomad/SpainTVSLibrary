#import <Foundation/Foundation.h>

@interface DSSpainTVSVideoInfo : NSObject
/*!  */
@property (nonatomic) NSString *descripcion;
/*!  */
@property (nonatomic) NSString *titulo;
/*!  */
@property (nonatomic) NSNumber *partes;
/*!  */
@property (nonatomic) NSURL *imagen;
/*!  */
@property (nonatomic) NSArray *filenames;
/*!  */
@property (nonatomic) NSArray *URLS;

/*!

*/
- (void) enumerateFilenamesAndURLsUsingBlock:(void (^)(NSString *filename, NSURL *url, NSUInteger idx)) enumeratorBlock;
@end