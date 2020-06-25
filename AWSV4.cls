public with sharing class AWSV4 {
    public AWSV4() {

    }
    public DateTime dtNow{
        get{
            if(dtNow==null){
                dtNow = Datetime.now();
            }
            return dtNow;
        }set;
    }
    public String iso8601time{
        get{
            if(iso8601time==null){
                iso8601time = dtNow.formatGmt('YYYYMMdd\'T\'HHmmss\'Z\'');
            }
            return iso8601time;
        }set;
    }
    public String iso8601date{
        get{
            if(iso8601date==null){
                iso8601date = dtNow.formatGmt('YYYYMMdd');
            }
            return iso8601date;
        }set;
    }
    public void doCallout(){
        String accessKey = 'AccessKey';
        String secretKey = 'Secret KEy';
        String host = 'wxhuwnnuac.execute-api.us-east-1.amazonaws.com';
        String path = '/dev/company_searches/fetchrsv4';
        String hashAlgo = 'HmacSHA256';
        String url = 'https://wxhuwnnuac.execute-api.us-east-1.amazonaws.com/dev/company_searches/fetchrsv4';
        String currentDate = String.valueOf(dtNow);
        String currentDateRaw = iso8601time;
        String currentDateOnly = iso8601date;
        String regionName = 'us-east-1';
        String serviceName = 'execute-api';

        // BODY
        String message= '{"start":0,"length":200,"columns_requested":[{"table":"ct.company_cross_data_view","fields":["ivp_name"]},{"table":"ct.company_data","fields":["thumbs_value"]},{"table":"ct.company_cross_data_view","fields":["ivp_description"]},{"table":"ct.company_data","fields":["preferred_company"]}],"json_filters":{"record_ids":"6cb4d1e5a7524b8f87ff833c9759ff83","activeSearchTab":"intelligenceTab","user_id":"0050W000006vMyMQAU","org_id":"00D2C000000D6wGUAS","no_active_preferences":4,"salesforce_username":"jhoskins@ivp.com.copperhill"},"order":[{"column":2,"dir":"desc"}]}';

        ////////////////////////////////////
        // 1 - CANONICAL REQUEST
        ////////////////////////////////////

        String strCanonicalRequest = '';
        strCanonicalRequest+='POST\n';
        strCanonicalRequest+=path + '\n';
        strCanonicalRequest+='\n';
        strCanonicalRequest+='content-type:application/json; charset=utf-8\n';
        strCanonicalRequest+='host:wxhuwnnuac.execute-api.us-east-1.amazonaws.com\n';
        strCanonicalRequest+='x-amz-date:' + currentDateRaw + '\n';
        strCanonicalRequest+='\n';
        strCanonicalRequest+='content-type;host;x-amz-date';
        String strPayloadHash = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(message))); // Payload
        strCanonicalRequest+= '\n' + strPayloadHash.toLowerCase();

        ////////////////////////////////////
        // 2 - STRING TO SIGN
        ////////////////////////////////////

        String strStringToSign = '';
        strStringToSign+='AWS4-HMAC-SHA256\n';
        strStringToSign+=currentDateRaw + '\n';
        strStringToSign+=currentDateOnly + '/' + regionName + '/' + serviceName + '/aws4_request';
        String strCanonicalHash = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(strCanonicalRequest))); // Payload
        strStringToSign+= '\n' + strCanonicalHash.toLowerCase();

        ////////////////////////////////////
        // 3 - SIGNATURE
        ////////////////////////////////////

        String kSecret = 'AWS4' + secretKey;
        Blob kDate = Crypto.generateMac(hashAlgo, Blob.valueOf(currentDateOnly), Blob.valueOf(kSecret));
        Blob kRegion = Crypto.generateMac(hashAlgo, Blob.valueOf(regionName), kDate);
        Blob kService = Crypto.generateMac(hashAlgo, Blob.valueOf(serviceName), kRegion);
        Blob kSigning = Crypto.generateMac(hashAlgo, Blob.valueOf('aws4_request'), kService);
        String strSignature = EncodingUtil.convertToHex(Crypto.generateMac(hashAlgo, Blob.valueOf(strStringToSign), kSigning));
        strSignature = strSignature.toLowerCase();

        ////////////////////////////////////
        // 4 - AUTHORIZATION HEADER
        ////////////////////////////////////

        String strAuthorizationHeader = 'AWS4-HMAC-SHA256 ';
        strAuthorizationHeader+= 'Credential=' + accessKey + '/' + currentDateOnly + '/' + regionName + '/' + serviceName + '/aws4_request, ';
        strAuthorizationHeader+= 'SignedHeaders=content-type;host;x-amz-date, ';
        strAuthorizationHeader+= 'Signature=' + strSignature;

        // Http Callout
        HttpRequest req = new HttpRequest();
        req.setEndPoint(url);
        req.setHeader('Authorization', strAuthorizationHeader);
        req.setHeader('content-type','application/json; charset=utf-8');
        //req.setHeader('host', host);  // Do not specify this one to use proxy urls such as moesif
        req.setHeader('x-amz-date', currentDateRaw);
        req.setMethod('POST');
        req.setBody(message);
        HttpResponse res = new http().send(req);
        System.debug(res.getStatus());
        System.debug(res.getBody());
    }
}