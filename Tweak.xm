#include <AppList/AppList.h>
#import <UIKit/UIKit.h>

static NSString *nsDomainString =
    @"/var/mobile/Library/Preferences/com.midnightchips.cleantabpref.plist";
static NSString *nsNotificationString =
    @"com.midnightchips.cleantabpref.plist/preferences.changed";

@interface NSUserDefaults (CleanTab)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

static BOOL enable;

static void notificationCallback(CFNotificationCenterRef center, void *observer,
                                 CFStringRef name, const void *object,
                                 CFDictionaryRef userInfo) {
  NSNumber *e = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enable" inDomain:nsDomainString];

  enable = (e) ? [e boolValue] : NO;
}

@interface UITabBarButton : UIControl
@end

static NSMutableArray *blackList;
static NSString *bundleID;

%hook UITabBarButton 
- (void)layoutSubviews {
  %orig;
  if (![blackList containsObject:bundleID]) {
    UIView *icon = MSHookIvar<UIView *>(self, "_info");
    UILabel *label = MSHookIvar<UILabel *>(self, "_label");

    label.text = nil;
    label.textColor = [UIColor clearColor];

    icon.center =
        CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
  }
}
%end

    static void
    reloadPrefs() {

  // Add all apps that we should kill on exit to a global NSMutableArray
  NSDictionary *apps = [NSDictionary
      dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/"
                                   @"com.midnightchips.cleantabpref.plist"];
  blackList = [[NSMutableArray alloc] init];
  [apps enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    BOOL shouldBlacklist = [[apps objectForKey:key] boolValue];
    if (shouldBlacklist && [key hasPrefix:@"disableClean-"] &&
        ![blackList containsObject:key])
      [blackList
          addObject:[key stringByReplacingOccurrencesOfString:@"disableClean-"
                                                   withString:@""]];
  }];
}

%ctor {
  notificationCallback(NULL, NULL, NULL, NULL, NULL);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                  NULL, notificationCallback,
                                  (CFStringRef)nsNotificationString, NULL,
                                  CFNotificationSuspensionBehaviorCoalesce);
  NSNumber *e = (NSNumber *)[[NSUserDefaults standardUserDefaults]
      objectForKey:@"enable"
          inDomain:nsDomainString];
  enable = (e) ? [e boolValue] : NO;
  // NSMutableDictionary *plistDict = [[NSMutableDictionary alloc]
  // initWithContentsOfFile:nsDomainString];
  bundleID = [[NSBundle mainBundle] bundleIdentifier];
  NSLog(@"YEOT %@", bundleID);
  reloadPrefs();
  if (enable) {
    %init(_ungrouped);
  }
}
