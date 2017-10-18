
class SubmarineCable.Search
  
  @searchJsonPath = "/api/v1/search.json"
  
  # analytics: (category, action, label) ->
  #   _gaq.push(['_trackEvent', category, action, label]) if _gaq
  
  constructor: () ->
    jQuery.getJSON SubmarineCable.Search.searchJsonPath, (data) =>
      jQuery("#search")
        .autocomplete
          position: { my : "right top+12", at: "right bottom" }
          source: data
          open: (event, ui) ->
            jQuery(".ui-menu-item a:contains(Connected)").addClass('country')
            jQuery(".ui-menu-item a:contains(Ready)").addClass('rfs')
          close: (event, ui) ->
            jQuery("#search").val("Search")
            jQuery("#search").blur()
          select: (event, ui) ->
            _gaq.push(['_trackEvent', 'Search', 'Complete Search', jQuery(this).val()]) if _gaq
            window.location.href = ui.item.url
            

    # Search Input Focus/Blur
    jQuery("#search").val("Search").focus () ->
      jQuery(this).addClass("focus")
      jQuery("#nav").addClass("focus")
      jQuery(this).val("") if jQuery(this).val() == "Search"
      if window.matchMedia("only screen and (max-width:736px) and (orientation : portrait)").matches
        console.log "mobile search"
        window.scrollTo(0, jQuery("#nav").offset().top)
    .blur () ->
      jQuery(this).removeClass("focus").val("Search")
      jQuery("#nav").removeClass("focus")
