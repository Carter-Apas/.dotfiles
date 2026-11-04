#include <CoreFoundation/CoreFoundation.h>
#include <stdio.h>

static void appearance_changed(CFNotificationCenterRef center, void *observer,
                               CFStringRef name, const void *object,
                               CFDictionaryRef info) {
    puts("changed");
    fflush(stdout);
}

int main(void) {
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDistributedCenter(), NULL, appearance_changed,
        CFSTR("AppleInterfaceThemeChangedNotification"), NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately);

    /* Refresh after subscribing, including changes made while the helper started. */
    puts("changed");
    fflush(stdout);
    CFRunLoopRun();
    return 0;
}
