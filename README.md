HDITA for DITA-OT
=================

DITA-OT HDITA plug-in contains a custom parser for HDITA to allow
using HDITA as a source document format.

The HDITA files need to use a subset of HTML5 constructs for
compatibility with DITA content models.

Requirements
------------

DITA-OT 2.2 is required. Earlier versions of DITA-OT do not have the
required extension points.

Build
-----

1.  Run Gradle distribution task

    ~~~~ {.sh}
    ./gradlew dist
    ~~~~

Distribution ZIP file is generated under `build/distributions`.

Install
-------

1.  Run plug-in installation command

    ~~~~ {.sh}
    dita -install https://github.com/jelovirt/dita-ot-markdown/releases/download/0.1.0/com.elovirta.dita.html_0.1.0.zip
    ~~~~

The `dita` command line tool requires no additional configuration;
running DITA-OT using Ant requires adding plug-in contributed JAR files
to `CLASSPATH` with e.g. `-lib plugins/com.elovirta.dita.html`.

Usage
-----

Markdown DITA topics can only be used by linking to them in map files.

~~~~ {.xml}
<map>
  <topicref href="test.html" format="html"/>
</map>
~~~~

The `format` attribute value must be set to `html` in order to
recognize files as HDITA; file extension is not used to
recognize format.

Donating
--------

Support this project and others by [@jelovirt](https://github.com/jelovirt) via [Paypal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=jarno%40elovirta%2ecom&lc=FI&item_name=Support%20Open%20Source%20work&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted).

License
-------

DITA-OT HDITA is licensed for use under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).