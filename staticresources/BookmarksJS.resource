var bookmarkToEditId;
$( document ).ready(
    function() {
        $( '#bookmarkstable' ).DataTable( { 
            "pageLength": 50
        });
    }
);

$("#login").click( function () {
    var url     = "/apex/BookmarksPage";
    var un      = $("[id$='un']").val();
    var pw      = $("[id$='pw']").val();
    
    url = url + "?username=" + un + "&password=" + pw;
    
    location.href = url;
} );

var successCreate = function () {
    alert( 'Saved Successfully' );
    location.reload();
};

var successDelete = function () {
    alert( 'Deleted Successfully' );
    location.reload();
};

var successShorten = function () {
    alert( 'Shortened Successfully' );
    location.reload();
};

var successEdit = function () {
    alert( 'Edited Successfully' );
    location.reload();
};

function saveBookmark() {
    var name    = $( "#name" ).val();
    var cat     = $( "#category" ).val();
    var url     = $( "#url" ).val();
    BookmarksController.saveBookmark( name , cat , url , successCreate );
}

function deleteBookmark( id ) {
    var choice = confirm( 'Shall we delete?' );
    if( choice === true ) {
        BookmarksController.deleteBookmark( id , successDelete );
    }
}

function shortenUrl( url , id ) {
    BookmarksController.shortenUrl( url , id , successShorten );
}

function loadBookmarkDetails( name , cat , url, id ){
    $("#nameE").val( name );
    $("#categoryE").val( cat );
    $("#urlE").val( url );
    bookmarkToEditId = id;
}

function editBookmark( id ) {
    var nameEdit    = $( "#nameE" ).val();
    var catEdit     = $( "#categoryE" ).val();
    var urlEdit     = $( "#urlE" ).val();
    BookmarksController.editBookmark( nameEdit , catEdit , urlEdit , bookmarkToEditId , successEdit );
}
