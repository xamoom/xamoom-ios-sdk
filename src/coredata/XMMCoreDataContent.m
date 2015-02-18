#import "XMMCoreDataContent.h"

@interface XMMCoreDataContent ()

// Private interface goes here.

@end

@implementation XMMCoreDataContent

+ (NSDictionary *)getMapping{
    return @{@"description":@"descriptionOfContent",
             @"language":@"language",
             @"title":@"title",
             @"image_public_url":@"imagePublicUrl",
             };
}

-(NSArray *)sortedContentBlocks {
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    NSArray *sorting = [NSArray arrayWithObject:descriptor];
    
    return [self.contentBlocks sortedArrayUsingDescriptors:sorting];
}

- (void)willSave {
    //NSLog(@"WILLSAVE: %@", self.contentBlocks);
    NSLog(@"WILLSAVE: %@", [self md5HexDigest:[self.contentBlocks.allObjects componentsJoinedByString:@","]] );
}

- (NSString*)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@end
