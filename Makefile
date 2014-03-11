# More information: https://wiki.ubuntu.com/Touch/Testing
#
# Notes for autopilot tests:
# -----------------------------------------------------------
# In order to run autopilot tests:
# sudo apt-add-repository ppa:autopilot/ppa
# sudo apt-get update
# sudo apt-get install python-autopilot autopilot-qt
#############################################################

DIST=curator-phablet.desktop curator-phablet.json curator-phablet.qml curator.png main.qml manifest.json viewer.qml
all:

autopilot:
	chmod +x tests/autopilot/run
	tests/autopilot/run

check:
	qmltestrunner -input tests/unit

run:
	/usr/bin/qmlscene $@ curator-phablet.qml
clean:
	$(RM) -r build *.click

build:
	mkdir build && cp ${DIST} build
	click build build
