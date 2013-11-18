#import "DSSpainTVSVideoInfo.h"

@implementation DSSpainTVSVideoInfo
//
// Enumeramos los archivos y las URL que conforman el video
//
- (void) enumerateFilenamesAndURLsUsingBlock:(void (^)(NSString *filename, NSURL *url, NSUInteger idx)) enumeratorBlock
{
	for(int x = 0; x < [self.filenames count]; x++)
	{		
		enumeratorBlock(self.filenames[x], [NSURL URLWithString:self.URLS[x]], x);
	}
}

//
// Sobreescribimos la descripcion de depuracion de cla clase
//
- (NSString *) debugDescription
{
    return [[NSString alloc] initWithFormat:@"Titulo: %@\r\nDescripcion: %@", self.titulo, self.description];
}
@end
