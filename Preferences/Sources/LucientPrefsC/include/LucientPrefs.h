#import <Foundation/Foundation.h>

@interface NSTask : NSObject
- (void)setArguments:(nullable NSArray*)arguments;
- (void)setLaunchPath:(nullable NSString*)launchPath;
- (void)launch;
@end
