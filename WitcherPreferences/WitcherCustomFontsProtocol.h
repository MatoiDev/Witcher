#import <Foundation/Foundation.h>
#import "../Extensions/Extensions.h"

@protocol WitcherCustomFontsProtocol
@required
-(void)registerCustomFonts:(NSArray<NSString *> *_Nullable)fonts;
@end