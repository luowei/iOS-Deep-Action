//
//  FileChangeObserver.m
//  Kqueue-Demo
//
//  Created by Luo Wei on 2021/2/21.
//  Copyright © 2021 Luo Wei. All rights reserved.
//

#import "FileChangeObserver.h"

#undef Assert
#define Assert(COND) { if (!(COND)) { raise( SIGINT ) ; } }

@interface FileChangeObserver ()
@property(nonatomic, readonly) int kqueue;
@property(nonatomic) enum FileChangeNotificationType typeMask;
@end

@implementation FileChangeObserver
@synthesize kqueue = _kqueue;

+ (instancetype)observerForURL:(NSURL *)url types:(enum FileChangeNotificationType)types delegate:(id <FileChangeObserverDelegate>)delegate {
    if (!url) {return nil;}

    FileChangeObserver *chgObserver = [[[self class] alloc] init];
    chgObserver.url = url;
    chgObserver.delegate = delegate;
    chgObserver.typeMask = types;

    [chgObserver startObserving];
    return chgObserver;
}

- (void)dealloc {
    printf("%s\n", __PRETTY_FUNCTION__);
    [self stopObserving];
}


//
// kqueue_main
//

static void (^kqueue_main)(FileChangeObserver *) = ^(__unsafe_unretained FileChangeObserver *self) {
    int fd = open([[self.url path] fileSystemRepresentation], O_EVTONLY);
    Assert(fd >= 0);

    int q = self.kqueue;

    {
        //构造kevent
        struct kevent event = {
                .ident  = fd,
                .filter = EVFILT_VNODE,
                .flags  = EV_ADD | EV_CLEAR,
                .fflags = self.typeMask,
        };

        //向 kqueue 中添加 event
        int error = kevent(q, &event, 1, NULL, 0, NULL);
        Assert(error == 0);

//        struct kevent w_ke;
//        EV_SET(&w_ke, fd, EVFILT_WRITE, EV_ADD | EV_CLEAR,self.typeMask, 0, NULL);
//        int ret = kevent(q, &w_ke, 1, NULL, 0, NULL);
//        Assert(ret == 0);

//        struct kevent r_ke;
//        EV_SET(&r_ke, fd, EVFILT_READ, EV_ADD | EV_CLEAR,self.typeMask, 0, NULL);
//        kevent(q, &r_ke, 1, NULL, 0, NULL);
    }

    struct kevent event = {0};
    for (;;) {
        int nEvents = kevent(q, NULL, 0, &event, 1, NULL);
        if (nEvents != 1) {break;}

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate fileChanged:self typeMask:(enum FileChangeNotificationType) event.fflags];
        });

    }
};


- (void)stopObserving {
    @synchronized (self) {
        close(self.kqueue);
    }
}

- (void)invalidate {
    [self stopObserving];
}

- (void)startObserving {
    @synchronized (self) {
        printf("%s\n", __PRETTY_FUNCTION__);
        static dispatch_queue_t __q;
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                __q = dispatch_queue_create("file observer queue", DISPATCH_QUEUE_CONCURRENT);
            });
        }

        // this is __unsafe_unretained to avoid retaining 'self'.
        // using __weak isn't a strong enough to prevent ARC from retaining 'self'.
        // This allows the observer to be torn down simply be releasing it,
        // instead of requiring the client to invoke -invalidate.
        __unsafe_unretained id unsafe_self = self;
        dispatch_async(__q, ^{
            kqueue_main(unsafe_self);
        });
    }
}

- (int)kqueue {
    if (!_kqueue) {
        //创建 kqueue，获得句柄 kq
        _kqueue = kqueue();
    }
    return _kqueue;
}

@end


@implementation NSString (FileChangeObserver)

+ (NSString *)stringWithKEventFFlags:(int)flags {
    NSMutableArray *array = [NSMutableArray array];
    struct {
        __unsafe_unretained NSString *name;
    } bitNames[] = {
            {@"NOTE_DELETE"}, {@"NOTE_WRITE"}, {@"NOTE_EXTEND"}, {@"NOTE_ATTRIB"}, {@"NOTE_LINK"}, {@"NOTE_RENAME"}, {@"NOTE_REVOKE"}, {@"NOTE_NONE"}
    };

    for (int index = 0, count = COUNTOF(bitNames); index < count; ++index) {
        if ((flags & (1 << index)) != 0) {
            [array addObject:bitNames[index].name];
        }
    }

    NSString *result = [array componentsJoinedByString:@" "];
    return result;
}

@end
