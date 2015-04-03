//
//  IRPersistentStore.h
//  IRKit
//
//  Created by Masakazu Ohtsuka on 2014/04/04.
//
//

#import <Foundation/Foundation.h>

@protocol IRPersistentStore <NSObject>

@required
- (void)storeObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (void)synchronize;

@end
