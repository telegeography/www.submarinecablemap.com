Ember.Handlebars.helper 'rfsLink', (rfs) ->
  if rfs is "n.a."
    return rfs
  else
    return new Handlebars.SafeString '<a href="/#/ready-for-service/' + rfs.replace(/(Q|H)[1-4]{1}/,"").match(/\d/g).join("") + '">' + rfs + '</a>'
    
#Ember.Handlebars.helper 'addTheToCountry', (country) ->
#  countries = ["United States","United Kingdom","United Arab Emirates","Dominican Republic","Philippines","Federated States of Micronesia","Congo, Dem. Rep.","Congo, Rep.","Gambia","Maldives","Czech Republic","Faeroe Islands","Virgin Islands (U.K.)","Cayman Islands","Turks and Caicos Islands","Virgin Islands (U.S.)","Republic of Marshall Islands","Soloman Islands","Netherlands", "Netherlands Antilles", "Northern Mariana Islands"]
#  return if country in countries then "the " + country else country