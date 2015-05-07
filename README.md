MVK15
=======

_MVK Project: Data Collection Using a Drone, and Graphical Representation via MVC_

Installation
------------

```shell
git clone git@github.com:aronstrandberg/MVK15.git
cd MVK15
# compile coffeescript (tab 1)
coffee -o js -cw coffee
# compile SASS (tab 2)
sass -w css/style.sass:css/style.css
# host application on port 8080 (tab 3) (I use 8080, use whichever one you want)
php -S 127.0.0.1:8080
```

Usage
------

```shell
your_favorite_browser http://localhost:8080
```

Client Dependencies
--------------------

* Some form of CGI web server, e.g:
  * Lighttpd or
  * Apache or
  * LAMP, MAMP, WAMP.
* PHP version > 5.4
  * PDO
  * pdo_pgsql
  * pgsql
* Coffeescript
  * http://coffeescript.org
* Sass
  * http://sass-lang.com/install
