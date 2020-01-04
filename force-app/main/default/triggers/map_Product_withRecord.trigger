trigger map_Product_withRecord on Bid_Request_Line_Item__c (before insert) {
    //Set to collect unique list of requested product names from the newly inserting line items.
   // set<id> Bid_Product_set = new set<id>();
    set<String> Bid_Product = new Set<String>();
    //To creating a binding between the product name and the corressponding product record ID.
    Map<string, id> product_map = new map<string, id>();
    
    
    for(Bid_Request_Line_Item__c bidVar : trigger.new){
      Bid_Product.add(bidVar.Bid_Product__c);
    }
    
    for(Product2 p : [select id,name from product2 where name in :Bid_Product]){
   
        product_map.put(p.name,p.id);
   
    }
        Map<String,Product2> productActive = new Map<String,Product2>();
        List<Product2> productActiveList = [select id, isActive,name from Product2 where name in :Bid_Product];
        for (Product2 p: productActiveList) {
                productActive.put(p.name,p);
                         }
     
    
    
    for(Bid_Request_Line_Item__c bidVar : trigger.new){
      
       if ((productActive.get(bidVar.Bid_Product__c) != null) && (productActive.get(bidVar.Bid_Product__c).isActive)) {
      
        bidVar.Product__c = productActive.get(bidVar.Bid_Product__c).id;
       
       }
       else{
     
       bidVar.Product__c = null;
       }
    }
    
    }