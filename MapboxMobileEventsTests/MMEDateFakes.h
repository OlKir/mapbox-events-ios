#import "MMEDate.h"

NS_ASSUME_NONNULL_BEGIN

// some fake dates for testing
@interface MMEDateFakes : MMEDate

+ (MMEDate *)earlier; // an MMEDate which isEqual: and can compare: as equal to any date which is earlier on the timeline than it's creation
+ (MMEDate *)later; // an MMEDate which isEqual: to and can compare: as equal to any date which is later on the timeline than it's creation
+ (MMEDate *)whenever; // an MMEDate which isEqual: to all NSDates and will compare: as equal to all dates
+ (MMEDate *)never; // an MMEDate which never isEqual: to any date and will never compare: as equal to any date

@end

NS_ASSUME_NONNULL_END
