#import <CommonCrypto/CommonDigest.h>
#import "XMMEnduserApi.h"
#import "XMMCoreDataGetById.h"
#import "XMMCoreDataMenuItem.h"
#import "XMMCoreDataStyle.h"
#import "XMMCoreDataContent.h"
#import "XMMCoreDataContentBlocks.h"

@interface XMMCoreDataGetById ()

// Private interface goes here.

@end

@implementation XMMCoreDataGetById

@synthesize objectAsHash;

+ (NSDictionary *)getMapping {
    return @{@"system_name":@"systemName",
             @"system_url":@"systemUrl",
             @"system_id":@"systemId",
             @"has_content":@"hasContent",
             @"has_spot":@"hasSpot",
             @"content.content_id":@"contentId",
             };
}

- (void)willSave {
    [self setGeneratedChecksumId];
}

-(NSString*)setGeneratedChecksumId {
    self.objectAsHash = [[NSMutableString alloc] init];
    
    [self.objectAsHash appendString:[self hashableDescription]];
    
    NSArray *menu = [self sortedMenuItem];
    for(XMMCoreDataMenuItem *item in menu) {
        [self.objectAsHash appendString:[item hashableDescription]];
    }
    
    if (self.style != nil) {
        [self.objectAsHash appendString:[self.style hashableDescription]];
    }
    
    if (self.content != nil) {
        [self.objectAsHash appendString:[self.content hashableDescription]];
    }
    
    NSArray *contentBlocks = self.content.sortedContentBlocks;
    for (XMMCoreDataContentBlocks *block in contentBlocks) {
        [self.objectAsHash appendString:[block hashableDescription]];
    }
    
    NSLog(@"Checksum: %@", [self sha1:self.objectAsHash]);
    
    [self setPrimitiveValue:[self sha1:self.objectAsHash] forKey:@"checksum"];
    return [self sha1:self.objectAsHash];
}

- (NSString *)hashableDescription {
    NSString *stringA = self.systemId;
    NSString *stringB = self.systemName;
    NSString *stringC = self.systemUrl;
    
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@", stringA, stringB, stringC];
    return description;
}

- (NSString *)sha1:(NSString *)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

-(NSArray *)sortedMenuItem {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    NSArray *sorting = [NSArray arrayWithObject:descriptor];
    
    return [self.menu sortedArrayUsingDescriptors:sorting];
}

-(BOOL)validateValue:(__autoreleasing id *)value forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    [super validateValue:value forKey:key error:error];
    
    // Validate uniqueness of checksum
    if([key isEqualToString:@"checksum"]) {
        /*
        NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
        [fetch setEntity:[NSEntityDescription entityForName:[self.entity name]
                                     inManagedObjectContext:self.managedObjectContext]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"checksum = %@",[self valueForKey:key]];
        
        fetch.predicate = predicate;
        
        NSError *error = nil;

        NSUInteger count = [self.managedObjectContext countForFetchRequest:fetch error:&error];
        
        NSLog(@"key: %@", [self valueForKey:key]);
        if (count > 1) {
            NSLog(@"More than one: %lu", (unsigned long)count);
            return NO;
        }
         
         */
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:[self.entity name] inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"checksum = %@",[self valueForKey:key]];
        [fetchRequest setPredicate:predicate];
        // Specify how the fetched objects should be sorted
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checksum"
                                                                       ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"Error");
        }
        
        int count = 0;
        
        for (XMMCoreDataGetById *item in fetchedObjects) {
            NSLog(@"fetchedObjects: %@ ", item.checksum);
            
            if ([item.checksum isEqualToString:[self valueForKey:key]]) {
                count++;
                if (count > 1) {
                    [self.managedObjectContext deleteObject:item];
                    return NO;
                }
            }
        }
    }
    
    return YES;
}


@end
