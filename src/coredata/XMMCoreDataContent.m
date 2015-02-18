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

-(NSString *)hashableDescription {
    NSString *stringA = self.descriptionOfContent;
    NSString *stringB = self.language;
    NSString *stringC = self.title;
    NSString *stringD = self.imagePublicUrl;
   
    NSString *description = [NSString stringWithFormat:@"%@,%@,%@,%@", stringA, stringB, stringC, stringD];
    return description;
}

-(NSArray *)sortedContentBlocks {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    NSArray *sorting = [NSArray arrayWithObject:descriptor];
    
    return [self.contentBlocks sortedArrayUsingDescriptors:sorting];
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


//HIER
- (void)willSave {
    NSLog(@"Hashing... : %@", [self hashableDescription]);
    [self setPrimitiveValue:[self md5HexDigest:[self hashableDescription]] forKey:@"changeHash"];
}

@end
