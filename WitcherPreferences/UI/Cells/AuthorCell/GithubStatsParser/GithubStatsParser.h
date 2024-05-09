//
//  GithubStatsParser.h
//  WitcherPreferencesUI
//
//  Created by Matoi on 07.05.2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface GitHubStatsParser : NSObject
+(void)fetchStarCountForRepository:(NSString *)repositoryName completionHandler:(void (^)(NSNumber *starCount, NSError *error))completionHandler;
@end

NS_ASSUME_NONNULL_END
