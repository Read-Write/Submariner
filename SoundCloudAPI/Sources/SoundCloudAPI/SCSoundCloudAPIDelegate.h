/*
 * Copyright 2010 nxtbgthng for SoundCloud Ltd.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 *
 * For more information and documentation refer to
 * http://soundcloud.com/api
 * 
 */

@class SCSoundCloudAPI;

@protocol SCSoundCloudAPIDelegate <NSObject>
@optional
- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didFinishWithData:(NSData *)data context:(id)context userInfo:(id)userInfo;
- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didFailWithError:(NSError *)error context:(id)context userInfo:(id)userInfo;
- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didReceiveData:(NSData *)data context:(id)context userInfo:(id)userInfo;
- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didReceiveBytes:(unsigned long long)loadedBytes total:(unsigned long long)totalBytes context:(id)context userInfo:(id)userInfo;
- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didSendBytes:(unsigned long long)sendBytes total:(unsigned long long)totalBytes context:(id)context userInfo:(id)userInfo;
@end