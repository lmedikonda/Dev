public class OpportunityTriggerHandler implements ITriggerHandler
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
        for(Opportunity opp: (List<Opportunity>)newItems.values()){ 
            if(opp.Primary_Distributor__c != null){
                partners.add(PartnerUtility.GeneratePartner(opp));
            }
        }
        insert partners;
    }
 
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        List<Partner> partners =new List<Partner>();
        Set<Id> primarydistributorids =new Set<Id>();
        Map<Id, Opportunity> oldOpps = (Map<Id, Opportunity>)oldItems;
        for(Opportunity opp: (List<Opportunity>)newItems.values()){ 
            if(opp.Primary_Distributor__c != null && (opp.Primary_Distributor__c != oldOpps.get(opp.Id).Primary_Distributor__c) ){
                partners.add(PartnerUtility.GeneratePartner(opp));
                primarydistributorids.add(opp.Primary_Distributor__c);
            }
        }
        List<Partner> existingPartners =[Select Id from Partner where OpportunityID in :newItems.keySet() and AccountToId in :primarydistributorids]; 
        delete existingPartners;
        insert Partners;
    }
 
    public void AfterDelete(Map<Id, SObject> oldItems) {}
 
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
}
