#include "CTPRootListController.h"

@implementation CTPRootListController

- (id)specifiers {
  if (_specifiers == nil) {
    _specifiers =
        [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
  }
  //[(UINavigationItem *)self.navigationItem setTitle:@"Customization"];
  return _specifiers;
}

@end
