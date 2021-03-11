//
//  FileChangeObserver.h
//  Kqueue-Demo
//
//  Created by Luo Wei on 2021/2/21.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

//#include <sys/event.h>
//#include <sys/types.h>
@import Darwin.sys.event;

#define COUNTOF(array) (sizeof(array) / sizeof(array[0]))

enum FileChangeNotificationType {
    kFileChangeType_Delete = NOTE_DELETE,
    kFileChangeType_Write = NOTE_WRITE,
    kFileChangeType_DirectoryContentsChanged = kFileChangeType_Write
    
//#define    NOTE_WRITE    0x00000002        /* data contents changed */
//#define    NOTE_EXTEND    0x00000004        /* size increased */
//#define    NOTE_ATTRIB    0x00000008        /* attributes changed */
//#define    NOTE_LINK    0x00000010        /* link count changed */
//#define    NOTE_RENAME    0x00000020        /* vnode was renamed */
//#define    NOTE_REVOKE    0x00000040        /* vnode access was revoked */
//#define NOTE_NONE    0x00000080        /* No specific vnode event: to test for EVFILT_READ activation*/

};

@class FileChangeObserver;

@protocol FileChangeObserverDelegate <NSObject>
@required
- (void)fileChanged:(FileChangeObserver *)observer typeMask:(enum FileChangeNotificationType)type;
@end

@interface FileChangeObserver : NSObject

@property(nonatomic, copy) NSURL *url;
@property(nonatomic, weak) id <FileChangeObserverDelegate> delegate;

+ (instancetype)observerForURL:(NSURL *)url types:(enum FileChangeNotificationType)types delegate:(id <FileChangeObserverDelegate>)delegate;

- (void)invalidate;
@end




