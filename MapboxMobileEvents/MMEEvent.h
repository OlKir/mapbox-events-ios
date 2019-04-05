#import <Foundation/Foundation.h>

@class MMEDate; // MAKE PRIVATE
@class MMECommonEventData;

/*! @brief represents a telemetry event, with date, name and attributes */
@interface MMEEvent : NSObject <NSCopying,NSSecureCoding>

/*! @brief date on which the event occured, including the local time offset
    @note MAKE READONLY */
@property (nonatomic, copy) MMEDate *date;

/*! @brief name of the event */
@property (nonatomic, copy) NSString *name;

/*! @brief attributes of the event */
@property (nonatomic, copy) NSDictionary *attributes;

#pragma mark -

/*! @brief eventWithDate:name:attributes:
    @param eventDate date
    @param name name
    @param attributes attrs
    @return event
    @note MAKE PRIVATE
*/
+ (instancetype)eventWithDate:(MMEDate *)eventDate name:(NSString *)name attributes:(NSDictionary *)attributes;

/*! @brief eventWithName:attributes:
    @param eventName name
    @param attributes attrs
    @return event
*/
+ (instancetype)eventWithName:(NSString *)eventName attributes:(NSDictionary *)attributes;

/*! @brief turnstileEventWithAttributes:
    @param attributes attrs
    @return event
*/
+ (instancetype)turnstileEventWithAttributes:(NSDictionary *)attributes;

/*! @brief locationEventWithAttributes:instanceIdentifer:commonEventData:
    @param attributes attrs
    @param instanceIdentifer identifier
    @param commonEventData data
    @return event
*/
+ (instancetype)locationEventWithAttributes:(NSDictionary *)attributes instanceIdentifer:(NSString *)instanceIdentifer commonEventData:(MMECommonEventData *)commonEventData;

/*! @brief visitEventWithAttributes:
    @param attributes attrs
    @return event
*/
+ (instancetype)visitEventWithAttributes:(NSDictionary *)attributes;

/*! @brief navigationEventWithName:attributes:
    @param name name
    @param attributes attrs
    @return event
*/
+ (instancetype)navigationEventWithName:(NSString *)name attributes:(NSDictionary *)attributes;

/*! @brief visionEventWithName:attributes:
    @param name name
    @param attributes attrs
    @return event
*/
+ (instancetype)visionEventWithName:(NSString *)name attributes:(NSDictionary *)attributes;

/*! @brief debugEventWithAttributes:
    @param attributes attrs
    @return event
*/
+ (instancetype)debugEventWithAttributes:(NSDictionary *)attributes;

/*! @brief debugEventWithError:
    @param error error
    @return event
*/
+ (instancetype)debugEventWithError:(NSError*) error;

/*! @brief debugEventWithException:
    @param except exception
    @return event
*/
+ (instancetype)debugEventWithException:(NSException*) except;

/*! @brief searchEventWithName:attributes:
    @param name name
    @param attributes attrs
    @return event
*/
+ (instancetype)searchEventWithName:(NSString *)name attributes:(NSDictionary *)attributes;

/*! @brief carplayEventWithName:attributes:
    @param name name
    @param attributes attrs
    @return event
*/
+ (instancetype)carplayEventWithName:(NSString *)name attributes:(NSDictionary *)attributes;

#pragma mark - Depricated (Date Strings)

+ (instancetype)telemetryMetricsEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes;
+ (instancetype)mapLoadEventWithDateString:(NSString *)dateString commonEventData:(MMECommonEventData *)commonEventData;
+ (instancetype)mapTapEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes;
+ (instancetype)mapDragEndEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes;
+ (instancetype)mapOfflineDownloadStartEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes;
+ (instancetype)mapOfflineDownloadEndEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes;
+ (instancetype)eventWithDateString:(NSString *)dateString name:(NSString *)name attributes:(NSDictionary *)attributes;

@end
