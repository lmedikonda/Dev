trigger OpportunityTrigger on Opportunity (after insert,after update) {
    TriggerDispatcher.Run(new OpportunityTriggerHandler());
}