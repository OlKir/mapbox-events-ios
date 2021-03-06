#import "Base.h"

#ifdef __cplusplus

#import <memory>

#pragma mark - private interface
namespace Cedar { namespace Matchers { namespace Private {

    typedef void (^empty_block_t)();

    struct RaiseExceptionMessageBuilder {
        static NSString * string_for_actual_value(empty_block_t value) {
            return [value description];
        }
    };

    class RaiseException : public Base<RaiseExceptionMessageBuilder> {
    private:
        RaiseException & operator=(const RaiseException &);

    public:
        explicit RaiseException(NSObject * = nil, Class = nil, bool = false, NSString * = nil, NSString * = nil);
        ~RaiseException();
        // Allow default copy ctor.

        RaiseException operator()() const;
        RaiseException operator()(Class) const;
        RaiseException operator()(NSObject *) const;

        RaiseException & or_subclass();

        RaiseException & with_reason(NSString * const reason);
        RaiseException with_reason(NSString * const reason) const;

        RaiseException & with_name(NSString * const name);
        RaiseException with_name(NSString * const name) const;

        bool matches(empty_block_t) const;

    protected:
        virtual NSString * failure_message_end() const;

    private:
        bool exception_matches_expected_class(NSObject * const exception) const;
        bool exception_matches_expected_instance(NSObject * const exception) const;
        bool exception_matches_expected_reason(NSObject * const exception) const;
        bool exception_matches_expected_name(NSObject * const exception) const;

    private:
        const NSObject *expectedExceptionInstance_;
        const Class expectedExceptionClass_;
        bool allowSubclasses_;
        NSString *expectedReason_;
        NSString *expectedName_;
    };
}}}

#pragma mark - public interface
namespace Cedar { namespace Matchers {
    using CedarRaiseException = Cedar::Matchers::Private::RaiseException;
    static const CedarRaiseException raise_exception;
}}

#endif // __cplusplus
