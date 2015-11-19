//
//  ParseDataManager.m
//  Identifind
//
//  Created by Alex Daley-Montgomery on 11/17/15.
//  Copyright © 2015 KALA. All rights reserved.
//

#import "ParseDataManager.h"

@implementation ParseDataManager

+ (ParseDataManager *)sharedManager {
    static ParseDataManager *obj;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[ParseDataManager alloc] init];
        /// TODO: Any other setup you'd like to do.
    });
    return obj;
}

- (BOOL)isUserLoggedIn {
    PFUser *bob = [PFUser currentUser]; //explicitly declared for debugging ease
    return bob != nil && [bob isAuthenticated];
}


- (void) signUp:(NSString*)username
      withEmail:(NSString*)email
   withPassword:(NSString*)password {
    
    PFUser *newUser = [PFUser user];
    newUser.username = username;
    newUser.email = email;
    newUser.password = password;
    //check if signup was a success
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"%@",[error localizedDescription]);
        } else {
            //if so log our user in
            [PFUser logInWithUsername:newUser.username password:newUser.password];
        }
    }];
}

- (void) postImage:(PFFile *)image
          fromUser:(NSString *)user
         withTitle:(NSString *)title
         withClues:(NSString *)clues
           withLat:(float)latitude
          withLong:(float)longitude{
    PFObject *puzzle = [PFObject objectWithClassName:@"Puzzle"];
    [puzzle setObject:user forKey:@"User"];
    [puzzle setObject:title forKey:@"Title"];
    [puzzle setObject:clues forKey:@"Clues"];
    [puzzle setObject:image forKey:@"Image"];
    [puzzle setObject:[NSNumber numberWithFloat:latitude] forKey:@"Latitude"];
    [puzzle setObject:[NSNumber numberWithFloat:longitude] forKey:@"Longitude"];
    [puzzle saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"%@",[error localizedDescription]);
        } else {
            NSLog(@"This got called. So I got that going for me. Which is nice.");
        }
    }];
}

@end
