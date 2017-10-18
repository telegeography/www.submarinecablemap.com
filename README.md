
Submarine Cable Map
===================

[![Submarine Cable Map](https://www.telegeography.com/page_attachments/products/website/telecom-resources/submarine-cable-map/0003/4671/interactive-cable-map.png)](http://www.submarinecablemap.com)

[TeleGeography's](http://www.telegeography.com) submarine cable map is based on our authoritative [Global Bandwidth](http://www.telegeography.com/research-services/global-bandwidth-research-service/) research and depicts international active and planned submarine cable systems and their landing stations. The map presents data about each cable, including landing points, owners, length, ready-for-service (RFS) date, and website. Try it today! Visit [http://www.submarinecablemap.com](http://www.submarinecablemap.com).


Installation
------------

    $ git clone git://github.com/telegeography/www.submarinecablemap.com.git

Point your webserver's document root to the public directory and that's it.

Or you can click the [Download ZIP](https://github.com/telegeography/www.submarinecablemap.com/archive/master.zip) link on the right and download the zip file.  Unzip the zip file and point your webserver's document root to the public directory.

If you're on a Mac you can download the zip file or clone the repo and use [python's SimpleHTTPServer](https://docs.python.org/2/library/simplehttpserver.html):

    $ git clone git://github.com/telegeography/www.submarinecablemap.com.git
    $ cd www.submarinecablemap.com/public 
    $ python -m SimpleHTTPServer

Or the following will work on a Mac too:

    $ wget https://github.com/telegeography/www.submarinecablemap.com/archive/master.zip
    $ unzip master.zip
    $ cd www.submarinecablemap.com-master/public/
    $ python -m SimpleHTTPServer


Updates
-------

To make sure you get any updates, just watch this repository and perform a pull when you see any new commits:

    $ cd www.submarinecablemap.com
    $ git pull


How did you make the Submarine Cable Map?
-------------------------------

[TeleGeography](http://www.telegeography.com) draws the cable routes and plots the landing points with [Adobe Illustrator](http://www.adobe.com/products/illustrator.html). Using [Avenza's MAPublisher](http://www.avenza.com/mapublisher) plug-in, which works with Illustrator, two sets of data are exported as KML files: the cable routes (as MultiLineStrings) and landing points (as Points). These KML files are then parsed to create CSV files that are uploaded to Google Fusion Tables.

We use [Google's Maps API v3.](http://code.google.com/apis/maps/documentation/javascript/) to transform the [Google Fusion Tables](http://www.google.com/fusiontables) into two separate map layers of cable routes and landing points. The interactivity on the map is driven by javascript and was written in-house at TeleGeography.

This interactive map Javascript was created using the [Node.js](http://nodejs.org/) utility [CoffeeScript](http://coffeescript.org/) written by Jeremy Ashkenas, the [Ember](http://emberjs.com/) web application framework, the [HTML5 Boilerplate](http://html5boilerplate.com/) front-end template, the [node-build-script](https://github.com/h5bp/node-build-script) and [node-ember-precompile](https://github.com/gabrielgrant/node-ember-precompile) tools.  The CoffeScript for the map was written in-house at TeleGeography.

Notable Commandline examples:

	# Install ember-precomile from github to get versions correct.
	npm install --from-git git://github.com/gabrielgrant/node-ember-precompile.git
	# precompile handlebars templates
	ember-precompile handlebars/*.handlebars -f src/javascripts/handlebars.tmpl.js
	
	# Used watchr to compile coffeescript/handlebars.
	watchr bin/script.watchr
	
	# Watch, server and build using h5bp, very helpful
	h5bp watch
	h5bp server
	h5bp build:minify


How can I download the KML or a CSV of the dataset?
--------------------------------------------------

Below are links to both of the datasets used for the [Submarine Cable Map](http://www.submarinecablemap.com).

__Submarine Cables:__

[https://www.google.com/fusiontables/DataSource?docid=17BhyBePnvZYZSn6_SJ62bTTYcXww6k9HoANOU6_O#map:id=3](https://www.google.com/fusiontables/DataSource?docid=17BhyBePnvZYZSn6_SJ62bTTYcXww6k9HoANOU6_O#map:id=3)

__To download as KML try the following steps:__

1. Click the 'Map of coordinates' tab.
2. Click 'File' then 'Download'.
3. Then select the KML radion button and click 'Download'

__Landing points:__

[https://www.google.com/fusiontables/DataSource?docid=1iAP2WzAAZ1j-8Up73L_rVqU7I4gAAf0bNchBWq9i#map:id=3](https://www.google.com/fusiontables/DataSource?docid=1iAP2WzAAZ1j-8Up73L_rVqU7I4gAAf0bNchBWq9i#map:id=3)


__To download as KML try the following steps:__

1. Click the 'Map of coordinates' tab
2. Click 'File' then 'Download'.
3. Then select the KML radion button and click 'Download'

__Note:__ For landing points, modify the 'Select location' dropdown menu to 'coordinates' from 'id', then click 'Download KML' to get the landing point data.


Questions? Corrections?
------------------------

[cablemap@telegeography.com](mailto:cablemap@telegeography.com)
