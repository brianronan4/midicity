#!/bin/bash
# This is a ghetto litte script to ease the pain of recompiling
# It tries to eer on the side of caution, but if everything explodes ....

# IT'S NOT MY FAULT!

#Also DO NOT move this script out of the src dir, it will crash and burn if you do so (I think)
#Also if your copy of Processing is not installed in /Applications/ you might want to change line 44

echo
echo Compile Script for midi library
echo -------------------------------
cd `dirname $0`

echo Setting up ...

ERROR=0
CREATED=0

if [ ! -d ./bin ]
	then
	if ! mkdir ./bin
		then
		echo Setup failed!
		echo
		exit 1
		else
		CREATED=1
	fi
fi

if [ -f ./PApplet.java ]
	then
	if ! mv ./PApplet.java ./PApplet.java.bak
		then
		echo Setup failed!
		echo
		exit 1
	fi
fi

echo Compiling ...

if ! javac -d ./bin -classpath /Applications/Processing.app/Contents/Resources/Java/core.jar *.java
	then
	echo Compile failed!
	echo
	exit 1
fi

cd ./bin
echo Making jar file ...

if ! jar -cf themidibus.jar ./themidibus/
	then
	echo Failed to make jar file!
	echo
	exit 1
fi

echo Moving jar file ...

if ! mv ./themidibus.jar ../../library/themidibus.jar
	then
	echo Failed to move themidibus.jar
	echo
	exit 1
fi

cd ..
echo Cleaning up ...

if [ $CREATED = 1 ]
	then
	if ! rm -r ./bin/
		then
		echo Failed to delete tmp files!
		echo
		ERROR=1
	fi
	
	else
	if ! rm -r ./bin/themidibus/
		then
		echo Failed to delete tmp files!
		echo
		ERROR=1
	fi
fi

if [ -f ./PApplet.java.bak ]
	then
	if ! mv ./PApplet.java.bak ./PApplet.java
		then
		echo Failed to rename PApplet
		echo
		ERROR=1
	fi
fi

echo Done!
echo
exit $ERROR
