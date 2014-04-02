//
//  NSGradient+SourceList.m
//  Submariner
//
//  Created by Rafaël Warnault on 20/06/11.
//
//  Copyright (c) 2011-2014, Rafaël Warnault
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  * Neither the name of the Read-Write.fr nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSGradient+SourceList.h"

@implementation NSGradient (SourceList)

+ (NSGradient *)sourceListSelectionGradient:(BOOL)isKey {
    
    NSGradient *result = nil;
    
    if (isKey) {
        NSColor *topColor = [NSColor colorWithCalibratedRed:0.3452 green:0.6284 blue:0.8694 alpha:1.0000];
        NSColor *endColor = [NSColor colorWithCalibratedRed:0.1701 green:0.4463 blue:0.7877 alpha:1.0000];
        
        return [[[NSGradient alloc] initWithStartingColor:topColor endingColor:endColor] autorelease];
    }
    
    NSColor *topColor = [NSColor colorWithCalibratedRed:0.6850 green:0.7288 blue:0.8332 alpha:1.0000];
    NSColor *endColor = [NSColor colorWithCalibratedRed:0.5441 green:0.5949 blue:0.7257 alpha:1.0000];
    
    result = [[[NSGradient alloc] initWithStartingColor:topColor endingColor:endColor] autorelease];
    
    return result;
}

@end
