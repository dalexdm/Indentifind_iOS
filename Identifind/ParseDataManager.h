//
//  ParseDataManager.h
//  Identifind
//
//  Created by Alex Daley-Montgomery on 11/17/15.
//  Copyright © 2015 KALA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseDataManager : NSObject

+ (ParseDataManager *)sharedManager;

- (BOOL)isUserLoggedIn;

- (void) signUp:(NSString*)username
      withEmail:(NSString*)email
   withPassword:(NSString*)password;

- (void) postImage:(PFFile *)image
          fromUser:(NSString*)user
         withTitle:(NSString*)title
         withClues:(NSString*)clues
           withLat:(float)latitude
          withLong:(float)longitude;
- (void) scorePoints:(int)points;

@end
