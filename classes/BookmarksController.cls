/**
 * This class is created to
 * save Bookmarks in a 
 * specific category.
 * 
 * @author      Shruti Sridharan
 * @since       26/02/2016
 * @revision    N/A
 */
global class BookmarksController {
    public List<Bookmark__c> bookmarks  { get; set; }
    public String username              { get; set; }
    public String password              { get; set; }
    
    public BookmarksController() {
        bookmarks  = new List<Bookmark__c>();
        //User userLogin = new User();
        
        fetchBookmarks();
        
        /*userLogin = [
            SELECT  Username__c,
                    Password__c
            FROM    User
            WHERE   Id = '00528000002HUXS'
        ];
        
        username     = ApexPages.currentPage().getParameters().get( 'username' );
        password     = ApexPages.currentPage().getParameters().get( 'password' );
        system.debug( userLogin );
        system.debug( username );
        system.debug( password );
        if( ( username == userLogin.Username__c ) && ( password == userLogin.Password__c ) )
        {
            PageReference bookmarkListPage = new PageReference('/apex/BookmarksPage');
            bookmarkListPage.setRedirect(true);
            return bookmarkListPage;
        }*/
        
    }
    
    public void fetchBookmarks() {
        bookmarks = [
            SELECT  Name,
                    Category__c,
                    URL__c,
                    Short_URL__c
            FROM    Bookmark__c
        ];
    }
    
    @RemoteAction
    global static void saveBookmark( String name , String category , String url ) {
        Bookmark__c bkmark  = new Bookmark__c();
        
        bkmark.Name         = name;
        bkmark.Category__c  = category;
        bkmark.URL__c       = url;
        
        INSERT bkmark;
    }
    
    @RemoteAction
    global static void deleteBookmark( String id ) {
        Bookmark__c bkmarkdel  = new Bookmark__c();
        
        bkmarkdel = [
            SELECT  Id
            FROM    Bookmark__c
            WHERE   Id = :id
        ];
        
        DELETE bkmarkdel;
    }
    
    @RemoteAction
    global static void shortenUrl( String url , String id ) {
        GoogleUrlShortener.shortenUrl( url , id );
    }
    
    @RemoteAction
    global static void editBookmark( String name , String category , String url , String id ) {
        Bookmark__c bkmarkedit = new Bookmark__c();
        
        bkmarkedit = [
            SELECT  Id,
                    Name,
                    Category__c,
                    URL__c
            FROM    Bookmark__c
            WHERE   Id = :id
        ];
        bkmarkedit.Name         = name;
        bkmarkedit.Category__c  = category;
        bkmarkedit.URL__c       = url;
        
        UPDATE bkmarkedit;
    }
    
    public PageReference authenticate() {
        User userLogin = new User();
        
        userLogin = [
            SELECT  Username__c,
                    Password__c
            FROM    User
            WHERE   Id = '00528000002HUXS'
        ];
        
        username     = ApexPages.currentPage().getParameters().get( 'username' );
        password     = ApexPages.currentPage().getParameters().get( 'password' );
        
        if( ( username != userLogin.Username__c ) || ( password != userLogin.Password__c ) )
        {
            PageReference bookmarkLoginPage = new PageReference( '/apex/BookmarksLogin' );
            //bookmarkLoginPage.setRedirect( FALSE );
            return bookmarkLoginPage;
        }
        return NULL;
    }  
}
