#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapboxMobileEvents/MMETypes.h>

@protocol MMEEventsManagerDelegate;

NS_ASSUME_NONNULL_BEGIN

/*! @brief Mapbox Mobile Events Manager */
@interface MMEEventsManager : NSObject

/*! @brief delegate */
@property (nonatomic, weak) id<MMEEventsManagerDelegate> delegate;

/*! @brief YES if metrics collection is enabled */
@property (nonatomic, getter=isMetricsEnabled) BOOL metricsEnabled;

/*! @brief YES if metrics collection is enabled in the simulator */
@property (nonatomic, getter=isMetricsEnabledInSimulator) BOOL metricsEnabledInSimulator;

/*! @brief YES if metrics collection is enabled when the app is in use */
@property (nonatomic, getter=isMetricsEnabledForInUsePermissions) BOOL metricsEnabledForInUsePermissions;

/*! @brief YES if debug logging is enabled */
@property (nonatomic, getter=isDebugLoggingEnabled) BOOL debugLoggingEnabled;

/*! @brief UserAgent base string, in RFC 2616 format
    @link https://www.ietf.org/rfc/rfc2616.txt */
@property (nonatomic, readonly) NSString *userAgentBase;

/*! @brief SDK version, in Semantic Versioning 2.0.0 format
    @link https://semver.org */
@property (nonatomic, readonly) NSString *hostSDKVersion;

/*! @brief Mapbox Access Token
    @link https://account.mapbox.com */
@property (nonatomic, copy) NSString *accessToken;

/*! @brief baseURL */
@property (nonatomic, null_resettable) NSURL *baseURL;

/*! @brief accountType */
@property (nonatomic) NSInteger accountType;

#pragma mark -

/*! @brief Shared Mabpox Mobile Events Manager */
+ (instancetype)sharedManager;

#pragma mark -

/*!
 @brief designated initilizer
 @param accessToken Mapbox Access Token
 @param userAgentBase UserAgent base string, in RFC 2616 format
 @param hostSDKVersion SDK version, in Semantic Versioning 2.0.0 format
 @throws no exceptions
*/
- (void)initializeWithAccessToken:(NSString *)accessToken userAgentBase:(NSString *)userAgentBase hostSDKVersion:(NSString *)hostSDKVersion;

/*! @brief pauseOrResumeMetricsCollectionIfRequired
    @throws no exceptions */
- (void)pauseOrResumeMetricsCollectionIfRequired;

/*! @brief flush the events pipeline, sending any pending events
    @throws no exceptions */
- (void)flush;

/*! @brief resetEventQueuing
    @throws no exceptions */
- (void)resetEventQueuing;

/*! @brief sendTurnstileEvent
    @throws no exceptions */
- (void)sendTurnstileEvent;

/*! @brief sendTelemetryMetricsEvent
    @throws no exceptions */
- (void)sendTelemetryMetricsEvent;

#pragma mark -

/*! @brief enqueueEventWithName:
    @param name event name */
- (void)enqueueEventWithName:(NSString *)name;

/*! @brief enqueueEventWithName:attributes:
    @param name event name
    @param attributes event attributes */
- (void)enqueueEventWithName:(NSString *)name attributes:(MMEMapboxEventAttributes *)attributes;


/*! @brief postMetadata:filePaths:completionHander:
    @param metadata array of metadat
    @param filePaths array of file paths
    @param completionHandler completion handler block
*/
- (void)postMetadata:(NSArray *)metadata filePaths:(NSArray *)filePaths completionHandler:(nullable void (^)(NSError * _Nullable error))completionHandler;


/*! @brief disableLocationMetrics */
- (void)disableLocationMetrics;

/*! @brief displayLogFileFromDate:...
    @param logDate earliest date to display log information for
    @note TO BE DEPRICATED
*/
- (void)displayLogFileFromDate:(NSDate *)logDate;

@end

#pragma mark -

/*! @brief delegate methods for MMEEventsManager */
@protocol MMEEventsManagerDelegate <NSObject>

@optional

/*! @brief eventsManager:...
 @param eventsManager shared manager
 @param locations array of CLLocations
 */
- (void)eventsManager:(MMEEventsManager *)eventsManager didUpdateLocations:(NSArray<CLLocation *> *)locations;

#if TARGET_OS_IOS
/*! @brief eventsManager:...
 @param eventsManager shared manager
 @param visit CLVisit
 */
- (void)eventsManager:(MMEEventsManager *)eventsManager didVisit:(CLVisit *)visit;
#endif

@end

NS_ASSUME_NONNULL_END
