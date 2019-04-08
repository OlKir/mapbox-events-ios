#import "MMEEvent.h"
#import "MMEDate.h"
#import "MMEConstants.h"
#import "MMECommonEventData.h"
#import "MMEReachability.h"
#import "MMEEventsManager.h"

#if TARGET_OS_IOS || TARGET_OS_TVOS
#import <UIKit/UIKit.h>
#endif

@interface MMEEvent ()
@property(nonatomic,retain) MMEDate *dateStorage;
@property(nonatomic,retain) NSDictionary *attributesStorage;

@end

#pragma mark -

@implementation MMEEvent

#pragma mark - Generic Events

+ (instancetype)eventWithAttributes:(NSDictionary *)attributes {
    NSError *eventError = nil;
    MMEEvent *newEvent = [MMEEvent eventWithAttributes:attributes error:&eventError];
    if (eventError != nil) {
        [MMEEventsManager.sharedManager reportError:eventError];
    }

    return newEvent;
}

+ (instancetype)eventWithAttributes:(NSDictionary *)attributes error:(NSError **)error {
    return [MMEEvent.alloc initWithAttributes:attributes error:error];
}

#pragma mark - Custom Events

+ (instancetype)turnstileEventWithAttributes:(NSDictionary *)attributes {
    NSMutableDictionary *eventAttributes = attributes.mutableCopy;
    eventAttributes[MMEEventKeyEvent] = MMEEventTypeAppUserTurnstile;

    return [MMEEvent eventWithAttributes:eventAttributes];
}

+ (instancetype)visitEventWithAttributes:(NSDictionary *)attributes {
    NSMutableDictionary *eventAttributes = attributes.mutableCopy;
    eventAttributes[MMEEventKeyEvent] = MMEEventTypeVisit;

    return [MMEEvent eventWithAttributes:eventAttributes];
}

+ (instancetype)debugEventWithAttributes:(NSDictionary *)attributes {
    NSMutableDictionary *eventAttributes = attributes.mutableCopy;
    eventAttributes[MMEEventKeyEvent] = MMEEventTypeLocalDebug;

    return [MMEEvent eventWithAttributes:eventAttributes];
}

+ (instancetype)debugEventWithError:(NSError*) error {
    NSMutableDictionary* eventAttributes = [NSMutableDictionary dictionaryWithObject:MMEDebugEventTypeError forKey:MMEDebugEventType];
    eventAttributes[MMEEventKeyErrorCode] = @(error.code);
    eventAttributes[MMEEventKeyErrorDescription] = (error.localizedDescription ? error.localizedDescription : error.description);
    eventAttributes[MMEEventKeyErrorFailureReason] = (error.localizedFailureReason ? error.localizedFailureReason : MMEEventKeyErrorNoReason);

    return [self debugEventWithAttributes:eventAttributes];
}

+ (instancetype)debugEventWithException:(NSException*) except {
    NSMutableDictionary* eventAttributes = [NSMutableDictionary dictionaryWithObject:MMEDebugEventTypeError forKey:MMEDebugEventType];
    eventAttributes[MMEEventKeyErrorDescription] = except.name;
    eventAttributes[MMEEventKeyErrorFailureReason] = (except.reason ? except.reason : MMEEventKeyErrorNoReason);

    return [self debugEventWithAttributes:eventAttributes];
}

#pragma mark - Deperecated

+ (instancetype)eventWithDate:(NSDate *)eventDate name:(NSString *)eventName attributes:(NSDictionary *)attributes {
    NSMutableDictionary *eventAttributes = attributes.mutableCopy;
    eventAttributes[MMEEventKeyCreated] = [MMEDate.iso8601DateFormatter stringFromDate:eventDate];
    eventAttributes[MMEEventKeyEvent] = eventName;

    return [MMEEvent eventWithAttributes:eventAttributes];
}

+ (instancetype)eventWithName:(NSString *)eventName attributes:(NSDictionary *)attributes {
    return [MMEEvent eventWithDate:MMEDate.date name:eventName attributes:attributes];
}

+ (instancetype)telemetryMetricsEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes {
    NSMutableDictionary *eventAttributes = attributes.mutableCopy;
    eventAttributes[MMEEventKeyEvent] = MMEEventTypeTelemetryMetrics;
    eventAttributes[MMEEventKeyCreated] = dateString;

    return [MMEEvent eventWithAttributes:eventAttributes];
}

+ (instancetype)locationEventWithAttributes:(NSDictionary *)attributes instanceIdentifer:(NSString *)instanceIdentifer commonEventData:(MMECommonEventData *)commonEventData {
    NSMutableDictionary *eventAttributes = attributes.mutableCopy;
    eventAttributes[MMEEventKeyEvent] = MMEEventTypeLocation;
    eventAttributes[MMEEventKeySource] = MMEEventSource;
    eventAttributes[MMEEventKeySessionId] = instanceIdentifer;
    eventAttributes[MMEEventKeyOperatingSystem] = commonEventData.osVersion;
    if (![commonEventData.applicationState isEqualToString:MMEApplicationStateUnknown]) {
        eventAttributes[MMEEventKeyApplicationState] = commonEventData.applicationState;
    }

    return [MMEEvent eventWithAttributes:eventAttributes];
}

+ (instancetype)mapLoadEventWithDateString:(NSString *)dateString commonEventData:(MMECommonEventData *)commonEventData {
    NSMutableDictionary *eventAttributes = NSMutableDictionary.dictionary;
    eventAttributes[MMEEventKeyEvent] = MMEEventTypeMapLoad;
    eventAttributes[MMEEventKeyCreated] = dateString;
    eventAttributes[MMEEventKeyVendorID] = commonEventData.vendorId;
    eventAttributes[MMEEventKeyModel] = commonEventData.model;
    eventAttributes[MMEEventKeyOperatingSystem] = commonEventData.osVersion;
    eventAttributes[MMEEventKeyResolution] = @(commonEventData.scale);
#if TARGET_OS_IOS || TARGET_OS_TVOS
    eventAttributes[MMEEventKeyAccessibilityFontScale] = @(self.contentSizeScale);
    eventAttributes[MMEEventKeyOrientation] = self.deviceOrientation;
#endif
    eventAttributes[MMEEventKeyWifi] = @(MMEReachability.reachabilityForLocalWiFi.isReachableViaWiFi);

    return [MMEEvent eventWithAttributes:eventAttributes];
}

+ (instancetype)mapTapEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes {
    NSMutableDictionary *eventAttributes = attributes.mutableCopy;
    eventAttributes[MMEEventKeyEvent] = MMEEventTypeMapTap;
    eventAttributes[MMEEventKeyCreated] = dateString;
#if TARGET_OS_IOS || TARGET_OS_TVOS
    eventAttributes[MMEEventKeyOrientation] = self.deviceOrientation;
#endif
    eventAttributes[MMEEventKeyWifi] = @(MMEReachability.reachabilityForLocalWiFi.isReachableViaWiFi);

    return [MMEEvent eventWithAttributes:eventAttributes];
}

+ (instancetype)mapDragEndEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes {
    NSMutableDictionary *eventAttributes = attributes.mutableCopy;
    eventAttributes[MMEEventKeyEvent] = MMEEventTypeMapDragEnd;
    eventAttributes[MMEEventKeyCreated] = dateString;
#if TARGET_OS_IOS || TARGET_OS_TVOS
    eventAttributes[MMEEventKeyOrientation] = self.deviceOrientation;
#endif
    eventAttributes[MMEEventKeyWifi] = @(MMEReachability.reachabilityForLocalWiFi.isReachableViaWiFi);

    return [MMEEvent eventWithAttributes:eventAttributes];
}

+ (instancetype)mapOfflineDownloadStartEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes {
    NSMutableDictionary *eventAttributes = attributes.mutableCopy;
    eventAttributes[MMEEventKeyEvent] = MMEventTypeOfflineDownloadStart;
    eventAttributes[MMEEventKeyCreated] = dateString;

    return [MMEEvent eventWithAttributes:eventAttributes];
}

+ (instancetype)mapOfflineDownloadEndEventWithDateString:(NSString *)dateString attributes:(NSDictionary *)attributes {
    NSMutableDictionary *eventAttributes = attributes.mutableCopy;
    eventAttributes[MMEEventKeyEvent] = MMEventTypeOfflineDownloadEnd;
    eventAttributes[MMEEventKeyCreated] = dateString;

    return [MMEEvent eventWithAttributes:eventAttributes];
}

+ (instancetype)navigationEventWithName:(NSString *)name attributes:(NSDictionary *)attributes {
    return [MMEEvent eventWithName:name attributes:attributes];
}

+ (instancetype)visionEventWithName:(NSString *)name attributes:(NSDictionary *)attributes {
    return [MMEEvent eventWithName:name attributes:attributes];
}

+ (instancetype)searchEventWithName:(NSString *)name attributes:(NSDictionary *)attributes {
    return [MMEEvent eventWithName:name attributes:attributes];
}

+ (instancetype)carplayEventWithName:(NSString *)name attributes:(NSDictionary *)attributes {
    return [MMEEvent eventWithName:name attributes:attributes];
}

+ (instancetype)eventWithDateString:(NSString *)dateString name:(NSString *)name attributes:(NSDictionary *)attributes {
    NSMutableDictionary *eventAttributes = attributes.mutableCopy;
    eventAttributes[MMEEventKeyEvent] = name;
    eventAttributes[MMEEventKeyCreated] = dateString;

    return [MMEEvent eventWithAttributes:eventAttributes];
}

#pragma mark - AppKit

#if TARGET_OS_IOS || TARGET_OS_TVOS
+ (NSInteger)contentSizeScale {
    NSInteger result = -9999;
    
    NSString *sc = [UIApplication sharedApplication].preferredContentSizeCategory;
    
    if ([sc isEqualToString:UIContentSizeCategoryExtraSmall]) {
        result = -3;
    } else if ([sc isEqualToString:UIContentSizeCategorySmall]) {
        result = -2;
    } else if ([sc isEqualToString:UIContentSizeCategoryMedium]) {
        result = -1;
    } else if ([sc isEqualToString:UIContentSizeCategoryLarge]) {
        result = 0;
    } else if ([sc isEqualToString:UIContentSizeCategoryExtraLarge]) {
        result = 1;
    } else if ([sc isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
        result = 2;
    } else if ([sc isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
        result = 3;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityMedium]) {
        result = -11;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityLarge]) {
        result = 10;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityExtraLarge]) {
        result = 11;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraLarge]) {
        result = 12;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge]) {
        result = 13;
    }
    
    return result;
}

+ (NSString *)deviceOrientation {
    NSString *result;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationUnknown:
            result = @"Unknown";
            break;
        case UIDeviceOrientationPortrait:
            result = @"Portrait";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            result = @"PortraitUpsideDown";
            break;
        case UIDeviceOrientationLandscapeLeft:
            result = @"LandscapeLeft";
            break;
        case UIDeviceOrientationLandscapeRight:
            result = @"LandscapeRight";
            break;
        case UIDeviceOrientationFaceUp:
            result = @"FaceUp";
            break;
        case UIDeviceOrientationFaceDown:
            result = @"FaceDown";
            break;
        default:
            result = @"Default - Unknown";
            break;
    }
    return result;
}
#endif

#pragma mark - NSSecureCoding

+ (BOOL) supportsSecureCoding {
    return YES;
}

#pragma mark - Designated Initilizer

- (instancetype)initWithAttributes:(NSDictionary *)eventAttributes error:(NSError **)error {
    if ([NSJSONSerialization isValidJSONObject:eventAttributes]) {
        if (![eventAttributes.allKeys containsObject:MMEEventKeyEvent]) { // requried
            *error = [NSError errorWithDomain:MMEErrorDomain code:MMEErrorEventInit userInfo:@{
                MMEErrorDescriptionKey: @"eventAttributes does not contain MMEEventKeyEvent",
                MMEErrorEventAttributesKey: eventAttributes
            }];
            self = nil;
            goto exit;
        }
        else if (self = [super init]) {
            @try {
                _dateStorage = MMEDate.date;
                NSMutableDictionary* eventAttributesStorage = [eventAttributes mutableCopy];

                if (![eventAttributesStorage.allKeys containsObject:MMEEventKeyCreated]) {
                    eventAttributesStorage[MMEEventKeyCreated] = [MMEDate.iso8601DateFormatter stringFromDate:_dateStorage];
                }

                self.attributesStorage = eventAttributesStorage;
            }
            @catch(NSException* eventAttributesException) {
                *error = [NSError errorWithDomain:MMEErrorDomain code:MMEErrorEventInit userInfo:@{
                    MMEErrorDescriptionKey: @"exception processing eventAttributes",
                    MMEErrorUnderlyingExceptionKey: eventAttributesException,
                    MMEErrorEventAttributesKey: eventAttributes
                }];
                self = nil;
                goto exit;
            }
        }
    }
    else {
        *error = [NSError errorWithDomain:MMEErrorDomain code:MMEErrorEventInit userInfo:@{
            MMEErrorDescriptionKey: @"eventAttributes is not a valid JSON Object",
            MMEErrorEventAttributesKey: eventAttributes
        }];
        self = nil;
        goto exit;
    }

exit:
    return self;
}

#pragma mark - Properties

- (NSDate *)date {
    return [_dateStorage copy];
}

- (NSString *)name {
    return [_attributesStorage[MMEEventKeyEvent] copy];
}

- (NSDictionary *)attributes {
    return [NSDictionary dictionaryWithDictionary:_attributesStorage];
}

#pragma mark - MMEEvent

- (BOOL)isEqualToEvent:(MMEEvent *)event {
    if (!event) {
        return NO;
    }
    
    BOOL hasEqualName = [self.name isEqualToString:event.name];
    BOOL hasEqualDate = (self.date.timeIntervalSinceReferenceDate == event.date.timeIntervalSinceReferenceDate);
    BOOL hasEqualAttributes = [self.attributes isEqual:event.attributes];
    
    return (hasEqualName && hasEqualDate && hasEqualAttributes);
}

#pragma mark - NSObject overrides

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    
    if (![other isKindOfClass:MMEEvent.class]) {
        return  NO;
    }
    
    return [self isEqualToEvent:other];
}

- (NSUInteger)hash {
    return (self.name.hash ^ self.attributes.hash);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ name=%@, date=%@, attributes=%@>",
        NSStringFromClass(self.class), self.name, self.date, self.attributes];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    MMEEvent *copy = [MMEEvent new];
    copy.dateStorage = self.dateStorage.copy;
    copy.attributesStorage = self.attributesStorage.copy;
    return copy;
}

#pragma mark - NSCoding

static NSInteger const MMEEventVersion1 = 1; // Name, Date & Attributes Dictionary
static NSInteger const MMEEventVersion2 = 2; // Date * Attributes Dictionary
static NSString * const MMEEventVersionKey = @"MMEEventVersion";
static NSString * const MMEEventNameKey = @"MMEEventName";
static NSString * const MMEEventDateKey = @"MMEEventDate";
static NSString * const MMEEventAttributesKey = @"MMEEventAttributes";


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        NSInteger encodedVersion = [aDecoder decodeIntegerForKey:MMEEventVersionKey];
        _dateStorage = [aDecoder decodeObjectOfClass:MMEDate.class forKey:MMEEventDateKey];
        _attributesStorage = [aDecoder decodeObjectOfClass:NSDictionary.class forKey:MMEEventAttributesKey];
        if (encodedVersion > MMEEventVersion1) {
            NSLog(@"%@ WARNING encodedVersion %li > MMEEventVersion %li",
                NSStringFromClass(self.class), (long)encodedVersion, (long)MMEEventVersion1);
        }
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_dateStorage forKey:MMEEventDateKey];
    [aCoder encodeObject:_attributesStorage forKey:MMEEventAttributesKey];
    [aCoder encodeInteger:MMEEventVersion1 forKey:MMEEventVersionKey];
}

@end
