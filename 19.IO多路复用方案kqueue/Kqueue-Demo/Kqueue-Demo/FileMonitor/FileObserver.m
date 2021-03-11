
//参考：https://www.open-open.com/lib/view/open1479433476283.html
@interface FileObserver : NSObject
//......
@end


@implementation FileChangeObserver

//方法一:kqueue

- (void)kqueueFired
{
  int             kq;
  struct kevent   event;
  struct timespec timeout = { 0, 0 };
  int             eventCount;

  kq = CFFileDescriptorGetNativeDescriptor(self->kqref);
  assert(kq >= 0);

  eventCount = kevent(kq, NULL, 0, &event, 1, &timeout);
  assert( (eventCount >= 0) && (eventCount < 2) );

  if (self.fileChangeBlock) {
    self.fileChangeBlock(eventCount);
  }

  CFFileDescriptorEnableCallBacks(self->kqref, kCFFileDescriptorReadCallBack);
}

static void KQCallback(CFFileDescriptorRef kqRef, CFOptionFlags callBackTypes, void *info)  
{
  MonitorFileChangeUtils *helper = (MonitorFileChangeUtils *)(__bridge id)(CFTypeRef) info;
  [helper kqueueFired];
}

- (void) beginGeneratingDocumentNotificationsInPath: (NSString *) docPath
{
  int                     dirFD;
  int                     kq;
  int                     retVal;
  struct kevent           eventToAdd;
  CFFileDescriptorContext context = { 0, (void *)(__bridge CFTypeRef) self, NULL, NULL, NULL };

  dirFD = open([docPath fileSystemRepresentation], O_EVTONLY);
  assert(dirFD >= 0);

  kq = kqueue();
  assert(kq >= 0);

  eventToAdd.ident  = dirFD;
  eventToAdd.filter = EVFILT_VNODE;
  eventToAdd.flags  = EV_ADD | EV_CLEAR;
  eventToAdd.fflags = NOTE_WRITE;
  eventToAdd.data   = 0;
  eventToAdd.udata  = NULL;

  retVal = kevent(kq, &eventToAdd, 1, NULL, 0, NULL);
  assert(retVal == 0);

  self->kqref = CFFileDescriptorCreate(NULL, kq, true, KQCallback, &context);
  rls = CFFileDescriptorCreateRunLoopSource(NULL, self->kqref, 0);
  assert(rls != NULL);

  CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
  CFRelease(rls);
  CFFileDescriptorEnableCallBacks(self->kqref, kCFFileDescriptorReadCallBack);
}

//---------------------------

//方法二：GCD方式
- (void)__beginMonitoringFile
{

  _fileDescriptor = open([[_fileURL path] fileSystemRepresentation],
                         O_EVTONLY);
  dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                   _fileDescriptor,
                                   DISPATCH_VNODE_ATTRIB | DISPATCH_VNODE_DELETE | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_LINK | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE | DISPATCH_VNODE_WRITE,
                                   defaultQueue);        
  dispatch_source_set_event_handler(_source, ^ {
    unsigned long eventTypes = dispatch_source_get_data(_source);
    [self __alertDelegateOfEvents:eventTypes];
  });

  dispatch_source_set_cancel_handler(_source, ^{
    close(_fileDescriptor);
    _fileDescriptor = 0;
    _source = nil;

    // If this dispatch source was canceled because of a rename or delete notification, recreate it
    if (_keepMonitoringFile) {
        _keepMonitoringFile = NO;
        [self __beginMonitoringFile];
    }
  });
  dispatch_resume(_source);
}


@end