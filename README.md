MVK15
=======

_MVK Project: Data Collection Using a Drone, and Graphical Representation via MVC_

Installation
------------

```shell
git clone git@github.com:aronstrandberg/MVK15.git
cd MVK15
mv Prototype/* your_web_root
cd your_web_root
coffee -o js -c coffee
```

Usage
------

```shell
your_favorite_browser http://127.0.0.1/points/
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
