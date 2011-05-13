# prototype4 for Mac

This is a native Mac OS X app which embeds the HTML5 JavaScript game prototype4.

This repository does not include the game itself, it must be checked
out separately (see build instructions).

The game itself is a web page which uses the HTML5 canvas element to
display graphics. This application uses a WebView component to display
the web page. Additionally, the application provides a bridge from
JavaScript to Objective C to playback sound effects.

At the present time, HTML5 audio is a mess, therefore I implemented
this bridge for native sound playback. Phobos explains the problem
of the HTML5 audio element in this blog post:
http://www.phoboslab.org/log/2011/03/the-state-of-html5-audio

### Build instructions

The actual JavaScript Code is in game.dat (minified and obfuscated).
Generate game.dat from the original source code as follows:

* Clone the branch "mac" from https://github.com/sebcode/prototype4
* Run 'php make.php', this will create game.dat
* Replace game.dat in this directory with the new one
* Open the XCode project, build and run

### Credits

The game itself and this wrapper are written by [Sebastian Volland](http://sebastian-volland.de/).

[I used this nice tutorial to build the XCode WebView stuff.](http://blog.lostdecadegames.com/how-to-embed-html5-into-a-native-mac-osx-app)

[I used cfxr to create the retro sound effects.](http://thirdcog.eu/apps/cfxr
)

[Finch is used to playback sound effects.](https://github.com/zoul/Finch)

--
Copyright (C)2001-2015 Sebastian Volland - http://github.com/sebcode
