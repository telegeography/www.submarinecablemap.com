App = Ember.Application.create
        analytics: (path) ->
          _gaq.push(['_trackPageview', path]) if _gaq
        analytic_events: (category, action, label) ->
          _gaq.push(['_trackEvent', category, action, label]) if _gaq
        apiPath: "api/v1",
        map: null, 
        search: null, 
        githubUpdate: () ->
          jQuery.getJSON "https://api.github.com/repos/telegeography/www.submarinecablemap.com", (data) ->
            monthNames = [ "January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December" ]
            d = new Date(data.updated_at)
            jQuery("#updated-on a").text("Last updated on #{monthNames[d.getMonth()]} #{d.getDate()}, #{d.getFullYear()}")
        getSlug: (model) -> 
          if !model.slug
            slug = model
          else
            slug = model.slug
          slug

App.Router.map () ->
  this.route("submarine-cable", { path: "/submarine-cable/" })
  this.route("submarine-cable", { path: "/submarine-cable/:slug" })
  this.route("landing-point", { path: "/landing-point/" })
  this.route("landing-point", { path: "/landing-point/:slug" })
  this.route("country", { path: "/country/:slug" })
  this.route("ready-for-service", { path: "/ready-for-service/:slug" })

App.ApplicationView = Ember.View.extend
  classNames: 'map-container'
  didInsertElement: () ->
    if !App.map
      App.set('map', new SubmarineCable.Map('map'))
      App.set('search', new SubmarineCable.Search())
      App.githubUpdate()

App.IndexController = Ember.ArrayController.extend {}

App.IndexRoute = Ember.Route.extend
  setupController: (controller, model) ->
    App.analytics("/#/")
    window.scrollTo(0,0)
    jQuery.getJSON "#{App.apiPath}/cable/all.json", (data) ->
      App.map.resetMap() if App.map
      controller.set "model",  data

App.SubmarineCableView = Ember.View.extend
  linkToLandingPoint: Ember.View.extend
    templateName: 'landing-point-link'
    mouseEnter: (e) =>
      if jQuery(e.target).context.tagName == "A"
        App.analytic_events 'Landing Point', 'Side Bar MouseOver', jQuery(e.target.innerHTML).text()
        App.map.infoBox.setPosition new google.maps.LatLng jQuery(e.target).attr('name').split(",")[0], jQuery(e.target).attr('name').split(",")[1]
        App.map.infoBox.setContent "<div class=\"infoBoxContent\"><div class=\"infoBoxPointer\"></div>#{jQuery(e.target.innerHTML).text()}</span>"
        App.map.infoBox.open App.map.gmap
    mouseLeave: (e) =>
      App.map.infoBox.close()

App.SubmarineCableRoute = Ember.Route.extend
  setupController: (controller, model) ->
    App.analytics("/#/submarine-cable/#{App.getSlug(model)}")
    window.scrollTo(0,0)
    jQuery.getJSON "#{App.apiPath}/cable/#{App.getSlug(model)}.json", (data) ->
      App.analytic_events 'Cable', 'Select', App.getSlug(model)
      App.map.selectCable data.id, data.landing_points
      controller.set "model",  data

App.LandingPointRoute = Ember.Route.extend
  setupController: (controller, model) ->
    App.analytics("/#/landing-point/#{App.getSlug(model)}")
    window.scrollTo(0,0)
    jQuery.getJSON "#{App.apiPath}/landing-point/#{App.getSlug(model)}.json", (data) ->
      App.analytic_events 'Landing Point', 'Select', App.getSlug(model)
      App.map.selectLandingPoint data.name, new google.maps.LatLng data.latitude, data.longitude 
      controller.set "model",  data

App.CountryRoute = Ember.Route.extend
  setupController: (controller, model) ->
    App.analytics("/#/country/#{App.getSlug(model)}")
    window.scrollTo(0,0)
    jQuery.getJSON "#{App.apiPath}/country/#{App.getSlug(model)}.json", (data) ->
      App.analytic_events 'Country', 'Select', App.getSlug(model)
      App.map.selectCountry data.cables, data.latlon 
      controller.set "model",  data

App.ReadyForServiceRoute = Ember.Route.extend
  setupController: (controller, model) ->
    App.analytics("/#/ready-for-service/#{App.getSlug(model)}")
    window.scrollTo(0,0)
    jQuery.getJSON "#{App.apiPath}/ready-for-service/#{App.getSlug(model)}.json", (data) ->
      App.map.resetBounds()
      App.analytic_events 'RFS', 'Select', App.getSlug(model)
      App.map.selectRfs data
      controller.set "model",  data