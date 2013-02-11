//
//  mtlLocalization.m
//  Exterior
//
//  Created by Elie Zananiri on 2013-01-14.
//
//

#import "mtlLocalization.h"

static NSBundle *bundle = nil;
static NSString *language;

//--------------------------------------------------------------
//--------------------------------------------------------------
@implementation mtlLocalization

//--------------------------------------------------------------
+ (mtlLocalization *)sharedInstance
{
    static mtlLocalization *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[mtlLocalization alloc] init];
    });
    return sharedInstance;
}

//--------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
		bundle = [NSBundle mainBundle];

        // Set the starting language.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"mtl_preferred_language"] != nil) {
            [self setLanguage:[defaults stringForKey:@"mtl_preferred_language"]];
        }
        else {
            NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
            [self setLanguage:[languages objectAtIndex:0]];
        }
	}
    return self;
}

//--------------------------------------------------------------
- (void)setLanguage:(NSString *)lang
{
    NSLog(@"Setting language to %@", lang);

    NSString *path = [[NSBundle mainBundle] pathForResource:lang
                                                     ofType:@"lproj"];

	if (path == nil) {
		[self resetLanguage];
    }
    else {
		bundle = [NSBundle bundleWithPath:path];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:lang
                     forKey:@"mtl_preferred_language"];
        [defaults synchronize];
    }

    language = lang;
}

//--------------------------------------------------------------
- (void)resetLanguage
{
    bundle = [NSBundle mainBundle];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"mtl_preferred_language"];
    [defaults synchronize];
}

//--------------------------------------------------------------
- (NSString *)preferredLanguage
{
    return language;
}

//--------------------------------------------------------------
- (NSString *)localizedStringForKey:(NSString *)key
                              value:(NSString *)comment
{
    return [bundle localizedStringForKey:key
                                   value:comment
                                   table:nil];
}

@end
