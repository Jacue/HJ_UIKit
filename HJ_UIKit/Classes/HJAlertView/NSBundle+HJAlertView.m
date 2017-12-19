//
//  NSBundle+HJAlertView.m
//  HJ_UIKit
//
//  Created by Jacue on 2017/12/19.
//

#import "NSBundle+HJAlertView.h"
#import "HJAlertView.h"

@implementation NSBundle (HJAlertView)

+ (UIImage *)my_bundleImageNamed:(NSString *)name {
    return [self my_imageNamed:name inBundle:[NSBundle my_myLibraryBundle]];
}

+ (NSBundle *)my_myLibraryBundle {
    return [self bundleWithURL:[self my_myLibraryBundleURL]];
}

+ (NSURL *)my_myLibraryBundleURL {
    NSBundle *bundle = [NSBundle bundleForClass:[HJAlertView class]];
    return [bundle URLForResource:@"HJAlertView" withExtension:@"bundle"];
}

+ (UIImage *)my_imageNamed:(NSString *)name inBundle:(NSBundle *)bundle {
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
}

@end
