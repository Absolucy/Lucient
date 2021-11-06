//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

#ifndef NSTask_h
#define NSTask_h

#import <Foundation/Foundation.h>

@interface NSTask : NSObject

@property(copy) NSURL* executableURL;
@property(copy) NSArray* arguments;
@property(copy) NSDictionary* environment;
@property(copy) NSURL* currentDirectoryURL;
@property(retain) id standardInput;
@property(retain) id standardOutput;
@property(retain) id standardError;
@property(readonly) int processIdentifier;
@property(getter=isRunning, readonly) BOOL running;
@property(readonly) int terminationStatus;
@property(readonly) long long terminationReason;
@property(copy) void (^terminationHandler)(NSTask*);
@property(assign) long long qualityOfService;
+ (id)allocWithZone:(NSZone*)arg1;
+ (id)currentTaskDictionary;
+ (id)launchedTaskWithDictionary:(id)arg1;
+ (id)launchedTaskWithLaunchPath:(id)arg1 arguments:(id)arg2;
+ (id)launchedTaskWithExecutableURL:(id)arg1
						  arguments:(id)arg2
							  error:(out id*)arg3
				 terminationHandler:(void (^)(NSTask*))arg4;
- (id)init;
- (BOOL)resume;
- (int)processIdentifier;
- (NSURL*)executableURL;
- (NSArray*)arguments;
- (id)currentDirectoryPath;
- (long long)qualityOfService;
- (void)setQualityOfService:(long long)arg1;
- (NSDictionary*)environment;
- (void)setArguments:(NSArray*)arg1;
- (void)setCurrentDirectoryPath:(id)arg1;
- (id)launchPath;
- (void)setLaunchPath:(id)arg1;
- (void)setTerminationHandler:(void (^)(NSTask*))arg1;
- (id)terminationHandler;
- (int)terminationStatus;
- (long long)terminationReason;
- (BOOL)isRunning;
- (void)launch;
- (BOOL)launchAndReturnError:(id*)arg1;
- (void)setCurrentDirectoryURL:(NSURL*)arg1;
- (NSURL*)currentDirectoryURL;
- (void)setEnvironment:(NSDictionary*)arg1;
- (void)setExecutableURL:(NSURL*)arg1;
- (void)interrupt;
- (void)terminate;
- (BOOL)suspend;
- (long long)suspendCount;
- (void)setStandardInput:(id)arg1;
- (void)setStandardOutput:(id)arg1;
- (void)setStandardError:(id)arg1;
- (id)standardInput;
- (id)standardOutput;
- (id)standardError;
- (void)setSpawnedProcessDisclaimed:(BOOL)arg1;
- (BOOL)isSpawnedProcessDisclaimed;
- (void)waitUntilExit;
@end

#endif /* NSTask_h */
