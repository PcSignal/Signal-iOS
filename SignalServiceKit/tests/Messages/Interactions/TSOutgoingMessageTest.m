//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

#import "TSOutgoingMessage.h"
#import "OWSPrimaryStorage.h"
#import "SSKBaseTest.h"
#import "TSContactThread.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSOutgoingMessageTest : SSKBaseTest

@property (nonatomic) TSContactThread *thread;

@end

@implementation TSOutgoingMessageTest

- (void)setUp
{
    [super setUp];
    self.thread = [[TSContactThread alloc] initWithUniqueId:@"fake-thread-id"];
}

- (void)testShouldNotStartExpireTimerWithMessageThatDoesNotExpire
{
    TSOutgoingMessage *message = [[TSOutgoingMessage alloc] initWithTimestamp:100 inThread:self.thread messageBody:nil];
    XCTAssertFalse(message.shouldStartExpireTimer);
}

- (void)testShouldStartExpireTimerWithSentMessage
{
    TSOutgoingMessage *message = [[TSOutgoingMessage alloc] initWithTimestamp:100
                                                                     inThread:self.thread
                                                                  messageBody:nil
                                                                attachmentIds:[NSMutableArray new]
                                                             expiresInSeconds:10];
    [message updateWithMessageState:TSOutgoingMessageStateSentToService];
    XCTAssert(message.shouldStartExpireTimer);
}

- (void)testShouldNotStartExpireTimerWithUnsentMessage
{
    TSOutgoingMessage *message = [[TSOutgoingMessage alloc] initWithTimestamp:100
                                                                     inThread:self.thread
                                                                  messageBody:nil
                                                                attachmentIds:[NSMutableArray new]
                                                             expiresInSeconds:10];
    [message updateWithMessageState:TSOutgoingMessageStateUnsent];
    XCTAssertFalse(message.shouldStartExpireTimer);
}

- (void)testShouldNotStartExpireTimerWithAttemptingOutMessage
{
    TSOutgoingMessage *message = [[TSOutgoingMessage alloc] initWithTimestamp:100
                                                                     inThread:self.thread
                                                                  messageBody:nil
                                                                attachmentIds:[NSMutableArray new]
                                                             expiresInSeconds:10];
    [message updateWithMessageState:TSOutgoingMessageStateAttemptingOut];
    XCTAssertFalse(message.shouldStartExpireTimer);
}


@end

NS_ASSUME_NONNULL_END
