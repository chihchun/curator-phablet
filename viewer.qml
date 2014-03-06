import QtQuick 2.0
import Ubuntu.Components 0.1

Page {
    Rectangle {
        id: viewer;
        anchors.fill: parent
        color: "black";
        visible: true;

        Connections {
            target: mainscreenloader.item

            onView: { 
                view.model = model
                view.positionViewAtIndex(index, ListView.SnapPosition)
                mainscreenloader.visible = false;
            }
        }

        ListView {
            id: view;
            anchors.fill: parent;
            delegate: imageDelegatex
            visible: true;
            clip: true;
            focus: true;
            orientation: ListView.Horizontal;
            snapMode: ListView.SnapToItem;
            highlightRangeMode: ListView.StrictlyEnforceRange;

            onCurrentIndexChanged: {
                // TODO: switch the parent view to current index.
            }
        }

        Component {
            id: imageDelegatex;
            Rectangle {
                width: view.width;
                height: view.height;
                visible: true;
                color: "black";

                Image {
                    anchors.fill: parent;
                    width: parent.width;
                    height: parent.height;
                    source: image;
                    smooth: true;
                    fillMode: Image.PreserveAspectFit;

                    MouseArea {
                        anchors.fill: parent;
                        // leave some room for name link.
                        anchors.bottomMargin: 25;
                        onClicked: {
                            mainscreenloader.visible = true;
                        }
                    }
                }
                Text { 
                    anchors.bottom: parent.bottom;
                    anchors.bottomMargin: 5;
                    anchors.right: parent.right;
                    anchors.rightMargin: 5;
                    text: name;
                    color: "lightgray"

                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            Qt.openUrlExternally(url)
                        }
                    }
                }
            }
        }
    }
}
