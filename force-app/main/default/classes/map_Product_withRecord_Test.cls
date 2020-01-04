@isTest
global class map_Product_withRecord_Test
{
    @isTest
    static void run1()
    {
        Bid_Request__c objBidReq = new  Bid_Request__c();
        Insert objBidReq;
        System.debug(objBidReq.Id);
        Product2 objProd = new  Product2();
        objProd.Name = 'Test1';
        objProd.isActive = true;
        Insert objProd;
        System.debug(objProd.Id);
        Bid_Request_Line_Item__c objBidReqLineItem = new  Bid_Request_Line_Item__c();
        objBidReqLineItem.Bid_Request__c = objBidReq.Id;
        objBidReqLineItem.Bid_Product__c = 'Test1';
        Test.startTest();
        Insert objBidReqLineItem;
        System.debug(objBidReqLineItem.Id);
        Test.stopTest();
    }
    @isTest
    static void run2()
    {
        Bid_Request__c objBidReq = new  Bid_Request__c();
        Insert objBidReq;
        System.debug(objBidReq.Id);
        Product2 objProd = new  Product2();
        objProd.Name = 'Test2';
        objProd.isActive = false;
        Insert objProd;
        System.debug(objProd.Id);
        Bid_Request_Line_Item__c objBidReqLineItem = new  Bid_Request_Line_Item__c();
        objBidReqLineItem.Bid_Request__c = objBidReq.Id;
        objBidReqLineItem.Bid_Product__c = 'Test2';
        Test.startTest();
        Insert objBidReqLineItem;
        System.debug(objBidReqLineItem.Id);
        Test.stopTest();
    }
}