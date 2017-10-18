# This is for automatically compiling .coffee to .js 
# ChromeReloadr.sh is an AppleScript that reloads the active Chrome tab
# watch('coffee\/.*\.coffee') {|match| system "cake build && ./bin/chrome-reloadr.sh"}
watch('coffee\/.*\.coffee') {|match| system "cake build"}
# watch('handlebars\/.*\.handlebars') {|match| system "ember-precompile handlebars/*.handlebars -f production/javascripts/handlebars.template.js && ./bin/chrome-reloadr.sh"}
watch('handlebars\/.*\.handlebars') {|match| system "ember-precompile handlebars/*.handlebars -f src/javascripts/handlebars.tmpl.js && ./bin/chrome-reloadr.sh"}