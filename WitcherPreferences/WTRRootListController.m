#import <Foundation/Foundation.h>
#import "WTRRootListController.h"


@implementation WTRRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

@end

