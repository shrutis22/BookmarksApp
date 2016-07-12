/**
 * This class exposes methods 
 * that calls the Google URL 
 * Shortener API to shorten long URLs.
 * 
 * @author      Shruti Sridharan
 * @since       22/02/2016
 * @version     1.0
 */
global class GoogleUrlShortener {
    
    /**
     * This method calls the Google 
     * URL Shortener API with the 
     * encoded key and grabs the 
     * shortened URL from the response.
     * 
     * @param       longUrl         Accepts a long URL which has to be shortened.
     *              bookmarkId      Accepts the Id of the Respective record in Bookmark Object.
     * @since       22/02/2016
     */
    webService static void shortenUrl( String longUrl , String bookmarkId ) {
        /**
         * Fetching the Google URL Shortener 
         * endpoint and the Encoded Key from 
         * Custom Setting named Google API
         * Setting.
         */
        String encodedkey = Google_API_Setting__c.getInstance( 'URL Shortener Key' ).Value__c;
        
        String endpoint = Google_API_Setting__c.getInstance( 'URL Shortener Endpoint' ).Value__c;
        endpoint = endpoint.replace( '{YOUR_API_KEY}', encodedkey );
        
        String body = '{"longUrl":"' + longUrl + '"}';
        
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        
        httpReq.setBody( body ); //collecting
        httpReq.setMethod( 'POST' ); //wrapping
        httpReq.setHeader( 'Content-Type', 'application/json' );
        httpReq.setEndpoint( endpoint ); //address
        
        httpRes = http.send( httpReq ); //sending & recieving a JSON obj
        /**
         * To get the 'id' value that is 
         * the short URL from the JSON 
         * Response in Apex.
         * {"kind": "urlshortener#url",
         * "id": "https://goo.gl/HBqMMe",
         * "longUrl": "https://developers.google.com/url-shortener/v1/getting_started#shorten"}
         * nextToken method points the curosr 
         * to first key in the response.
         * Calling nexToken again points 
         * the cursor to next key/value.
         */
        JSONParser parser = JSON.createParser( httpRes.getBody() );
        parser.nextToken();
        parser.nextToken();
        parser.nextToken();
        parser.nextValue();
        
        Bookmark__c bm = new Bookmark__c();
        bm.Id = bookmarkId;
        bm.Short_URL__c = parser.getText();
        UPDATE bm;
    }
}
