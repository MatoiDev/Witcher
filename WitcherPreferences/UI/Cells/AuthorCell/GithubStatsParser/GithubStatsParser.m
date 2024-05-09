//
//  GithubStatsParser.m
//  WitcherPreferencesUI
//
//  Created by Matoi on 07.05.2024.
//

#import "GithubStatsParser.h"


@implementation GitHubStatsParser

+(void)fetchStarCountForRepository:(NSString *)repositoryName completionHandler:(void (^)(NSNumber *, NSError *))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"https://api.github.com/repos/%@", repositoryName];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (!url) {
        NSError *error = [NSError errorWithDomain:@"Invalid URL" code:100 userInfo:nil];
        completionHandler(nil, error);
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completionHandler(nil, error);
            return;
        }
        
        if (!data) {
            NSError *noDataError = [NSError errorWithDomain:@"No data received" code:101 userInfo:nil];
            completionHandler(nil, noDataError);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            completionHandler(nil, jsonError);
            return;
        }
        
        NSNumber *stars = json[@"stargazers_count"];
        if (stars) {
            completionHandler(stars, nil);
        } else {
            NSError *starsError = [NSError errorWithDomain:@"Stars count not found" code:102 userInfo:nil];
            completionHandler(nil, starsError);
        }
    }];
    
    [task resume];
}

@end
