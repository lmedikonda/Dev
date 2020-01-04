public class BidRequestTriggerHandler implements ITriggerHandler
{
    // Allows unit tests (or other code) to disable this trigger for the transaction
    public static Boolean TriggerDisabled = false;
 
    /*
        Checks to see if the trigger has been disabled either by custom setting or by running code
    */
    public Boolean IsDisabled()
    {
        return TriggerDisabled;
    }
 
    public void BeforeInsert(List<SObject> newItems) 
    {

    }
 
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
 
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
 
    public void AfterInsert(Map<Id, SObject> newItems) {
        List<Partner> partners =new List<Partner>();
        Set<Id> opps = new Set<Id>();
        Set<Id> accs = new Set<Id>();
        Set<Id> existingOpps = new Set<Id>();
        Set<Id> existingAccs = new Set<Id>();
        for(Bid_Request__C bid: (List<Bid_Request__C>)newItems.values()){ 
            if(bid.Opportunity__c != null && bid.Account__c != null){
                opps.add(bid.Opportunity__c);
                accs.add(bid.Account__c);
                partners.add(PartnerUtility.GeneratePartner(bid.Opportunity__c,bid.Account__c));
            }
        }
        List<Partner> existingPartners =[Select Id,OpportunityID,AccountToId from Partner where OpportunityID in :opps and AccountToId in :accs]; 
        for(Partner partner: existingPartners){
            if(opps.contains(partner.OpportunityID) && accs.contains(partner.AccountToId)){
                existingOpps.add(partner.OpportunityID);
                existingAccs.add(partner.AccountToId);
            }
        }
        for (integer i=0;i<partners.size();i++){
            if(existingOpps.contains(partners[i].OpportunityID )&& existingAccs.contains(partners[i].AccountToId)){
                partners.remove(i);
            }
        }
        insert partners;
    }
 
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {

    }
 
    public void AfterDelete(Map<Id, SObject> oldItems) {}
 
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
}

