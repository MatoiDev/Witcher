//
//  AuthorCell.h
//
//  Created by Matoi on 07.05.2024.
//

#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>

#import "../../../WitcherCustomFontsProtocol.h"
#import "../../../3rdPartyLibs/Lottie/Lottie.h"

#import "GithubStatsParser/GithubStatsParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorCell : PSTableCell <WitcherCustomFontsProtocol> {
    NSString *projectURL;
    NSString *profileURL;
    
    NSString *authorName;
    NSString *projectName;
    
    NSString *iconName;
}

@property(nonatomic, strong, nullable)UIActivityIndicatorView *progressView;

@end

NS_ASSUME_NONNULL_END
