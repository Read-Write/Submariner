//
//  QTMovie+Async.h
//  Vidnik
//
//  Created by David Phillip Oster on 3/13/08.
//  Copyright 2008 Google Inc. 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License.  You may obtain a copy
// of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
// License for the specific language governing permissions and limitations under
// the License.

//

#import <QTKit/QTKit.h>

@interface QTMovie(AsyncLoading)

+ (QTMovie *)asyncMovieWithURL:(NSURL *)url error:(NSError **)errorp;

// with async reads, we might not be ready to read the attributes.
- (BOOL)hasAttributes;

// call before trim.
- (void)registerNeedsUpdate;

// call before release.
- (void)unregisterNeedsUpdate;

// call before save, upload
- (void)updateMovieFileIfNeeded;

@end
