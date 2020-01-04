trigger BidRequestTrigger on Bid_Request__C (after insert,after update) {
    TriggerDispatcher.Run(new BidRequestTriggerHandler());
}