function init_search_box(search_url){
    $.widget( "custom.catcomplete", $.ui.autocomplete, {
        _renderMenu: function( ul, items ) {
            var self = this, category = '';

            $.each( items, function( index, item ) {
                if ( item.category === undefined ) {
                    self._renderItemData(ul, item).addClass('category').
                        html("<a href='/categories/" + item.id + "'>" + item.value + "</a>");
                }else {
                    if (category !== item.category){
                        ul.append( "<li class='ui-menu-item category'> " +
                            "<a href='/categories/" + item.category_id + "'>" + item.category + "</a></li>");
                        category = item.category;
                    }
                    self._renderItemData(ul, item).addClass('product').
                        html("<a href='/categories/" + item.category_id + "/products/" + item.id + "'>" + item.value + "</a>");
                }
            });
        }
    });

    $("#search").catcomplete({
        delay: 0,
        source: function( request, response ) {
            var suggestions = get_suggestions(request.term, search_url);
            if($.trim(suggestions[0]).length==0){ //acknowledge that no suggestions were found
                suggestions= ["No matches found"];
            }
            response(suggestions);
        }
    });
}

function get_suggestions(key, search_url){
    var searched_resources = $.ajax({
        type: "get",
        url: search_url,
        data: {
            "key": key
        },
        async: false
    }).responseText;
    return JSON.parse(searched_resources);
}
