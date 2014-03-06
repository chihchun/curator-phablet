import QtQuick 2.0
import QtQuick.Window 2.0
import Ubuntu.Components 0.1 

Item {
    id: application;
    width: units.gu(100);
    height: units.gu(200);
    focus: true;

    Loader {
        id: viewerloader;
        anchors.fill: parent;
        source: Qt.resolvedUrl("viewer.qml");
        visible: {
            if(mainscreenloader.visible) 
                false; 
            else 
                true;
        }
    }

    Loader {
        id: mainscreenloader;
        anchors.fill: parent;
        source: Qt.resolvedUrl("main.qml");
        visible: true;
    }
} 
