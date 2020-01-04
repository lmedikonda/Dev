public with sharing class PartnerUtility {
    public PartnerUtility() {

    }
    public static Partner GeneratePartner(Opportunity opp){
        Partner p =new Partner();
        p.OpportunityID = opp.ID;
        p.AccountToId =opp.Primary_Distributor__c;
        p.Role='Distributor';
        p.IsPrimary=true;
        return p;
    }
    public static Partner GeneratePartner(Id oppId, Id accId){
        Partner p =new Partner();
        p.OpportunityID = oppId;
        p.AccountToId =accId;
        p.Role='Distributor';
        return p;
    }
}
