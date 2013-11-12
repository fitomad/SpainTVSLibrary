#import "DSSpainTVSVideoInfo.h"

@implementation DSSpainTVSVideoInfo
//
//
//
- (void) enumerateFilenamesAndURLsUsingBlock:(void (^)(NSString *filename, NSURL *url, NSUInteger idx)) enumeratorBlock
{
	for(int x = 0; x < [self.filenames count]; x++)
	{		
		enumeratorBlock(self.filenames[x], [NSURL URLWithString:self.URLS[x]], x);
	}
}
@end