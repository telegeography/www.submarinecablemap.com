window.SubmarineCable = {}

class SubmarineCable.Map
  
  @landing_points_table_id = "1Cl54ggURDqPMvVSuxaQM5mPinrdeDq9FDCGfg9T4"
  @cables_table_id = "1lObSCM2_KCXIcbCfm_rbilwftWBbxAKszNyfOiL3"
  
  @mapStyles: [
    {"featureType": "landscape","stylers": [{ "visibility": "on" },{ "color": "#d9d9d9" }]},
    {"featureType": "poi","stylers": [{ "visibility": "off" }]},
    {"featureType": "road","stylers": [{ "visibility": "off" }]},
    {"featureType": "transit","stylers": [{ "visibility": "off" }]},
    {"featureType": "administrative.locality","stylers": [{ "visibility": "off" }]},
    {"featureType": "administrative.neighborhood","stylers": [{ "visibility": "off" }]},
    {"featureType": "administrative.land_parcel","stylers": [{ "visibility": "off" }]},
    {"featureType": "administrative.country","elementType": "labels.text.fill","stylers": [{ "color": "#000000" },{ "visibility": "on" }]},
    {"featureType": "administrative.province","stylers": [{ "visibility": "off" }]},
    {"featureType": "water","elementType": "geometry.fill","stylers": [{ "color": "#ffffff" },{ "visibility": "on" }]},
    {"elementType": "labels.text.fill","stylers": [{ "color": "#808080" }]}
  ];
  
  showCables: () ->
    @cables = new google.maps.FusionTablesLayer
      query: {select: 'coordinates',from: SubmarineCable.Map.cables_table_id}
      styles: [{polylineOptions: {strokeOpacity: 1}}]
      suppressInfoWindows:true, 
      styleId: 1
    @cables.setMap(@gmap)
  
  showLandingPoints: () ->
    @landing_points = new google.maps.FusionTablesLayer
      query: {select: 'coordinates',from: SubmarineCable.Map.landing_points_table_id}
      suppressInfoWindows:true
      styleId: 1
    @landing_points.setMap(@gmap)


  selectCable: (id, desc, is_map_clicked = false) ->
    # Cable Select Event
    @infoBox.close()
    @cables.setOptions 
      styles: [
        { polylineOptions: {strokeOpacity: 0.1} }
        where: "id = '#{id}'", polylineOptions: { strokeColor: "#a81120", strokeOpacity: 1.0} 
      ]
      
    @landing_points.setQuery 
      select: 'coordinates'
      from: SubmarineCable.Map.landing_points_table_id
      where: "id IN (#{("'#{d.id}'"for d in desc).join()})"
    @boundMap(desc)

  selectCountry: (cables, latlons) ->
    # Country Select Event
    @infoBox.close()
    @cables.setOptions 
      styles: [
        { polylineOptions: { strokeOpacity: 0.1 }}
        where: "cable_id IN (#{("#{d.cable_id}"for d in cables).join()})", polylineOptions: { strokeOpacity: 1.0 } 
      ]
    
    @landing_points.setQuery 
      select: 'coordinates'
      from: SubmarineCable.Map.landing_points_table_id
      where: "cable_id IN (#{("#{d.cable_id}"for d in cables).join()})"

    @boundMap(latlons)
    
  selectRfs: (data) ->
    # RFS Select Event
    @infoBox.close()
    @cables.setOptions 
      styles: [
        { polylineOptions: { strokeOpacity: 0.1 }}
        where: "rfs CONTAINS '#{data.rfs.toString()}'", polylineOptions: { strokeOpacity: 1.0 } 
      ]
    @landing_points.setQuery 
      select: 'coordinates'
      from: SubmarineCable.Map.landing_points_table_id
      where: "cable_id IN (#{("#{d.cable_id}"for d in data.cables).join()})"
  
  boundMap: (desc) ->
    bounds = new google.maps.LatLngBounds()
    for value in desc
      bounds.extend new google.maps.LatLng value.latlon.split(',')[0], value.latlon.split(',')[1]
    @gmap.fitBounds bounds
    if @gmap.getZoom() > 5
      @gmap.setZoom @gmap.getZoom() - 2

  selectLandingPoint: (name, latLng) ->
    # Landing Point Select Event
    @cables.setOptions({styles: [{ polylineOptions: {strokeOpacity: 1} }] });
    @landing_points.setQuery
      select: 'coordinates',
      from: SubmarineCable.Map.landing_points_table_id
      
    @infoBox.close()
    @gmap.panTo latLng 
    @infoBox.setContent "<div class=\"infoBoxContent\"><div class=\"infoBoxPointer\"></div>#{name}</span>"
    @infoBox.setPosition latLng
    @infoBox.open @gmap
  
  resetMap: () ->
    @cables.setOptions({ styles: [{ polylineOptions: { strokeOpacity: 1 }} ] })
    @landing_points.setQuery({select: 'coordinates',from: SubmarineCable.Map.landing_points_table_id})
    @infoBox.close()
    
  resetBounds: () ->
    @gmap.setZoom 2
    @gmap.setCenter new google.maps.LatLng(30.0,-30.0)
    
  setEvents: () ->
    # Map Event
    google.maps.event.addListener @gmap, 'click', (event) =>
      @analytics('Map', 'Click', 'On Map')
      jQuery(location).attr('href',"#/")
      
    # google.maps.event.addListener @gmap, 'zoom_changed', (event) =>
    #   console.log @gmap.getZoom()
  
    # Cable Event
    google.maps.event.addListener @cables, 'click', (event) => 
      # Cable Click Event?
      @analytics('Cable', 'Click', event.row.id.value)
      jQuery(location).attr('href',"#/submarine-cable/#{event.row.id.value}")

    # LandingPoint Event
    google.maps.event.addListener @landing_points, 'click', (event) => 
      # Landing Point Click Event?
      @analytics('Landing Point', 'Click', event.row.id.value)
      jQuery(location).attr('href',"#/landing-point/#{event.row.id.value}")
  
  isMobile: () ->
    try
      window.matchMedia("only screen and (max-width:736px)").matches
    catch error
      false
    
  analytics: (category, action, label) ->
    _gaq.push(['_trackEvent', category, action, label]) if _gaq
    
  constructor: (@element) ->
    @gmap = new google.maps.Map document.getElementById(@element), {
      zoom: if @isMobile() then 1 else 3,
      maptiks_id: "Submarine Cable Map",
      maxZoom: 8,
      minZoom: 2,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      styles: SubmarineCable.Map.mapStyles,
      center: new google.maps.LatLng(30.0,-30.0),
      streetViewControl: false,
      mapTypeControl: false,
      zoomControlOptions:
        position: google.maps.ControlPosition.TOP_LEFT
      disableDefaultUI: if @isMobile() then true else false
    }
    @infoBox = new InfoBox({closeBoxURL:"",alignBottom:true,pixelOffset:new google.maps.Size(-60,-15)})
    @showCables()
    @showLandingPoints()
    @setEvents()
    return this

