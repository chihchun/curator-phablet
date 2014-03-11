import QtQuick 2.0
import Ubuntu.Components 0.1

MainView {
    id: mainscreen;
    objectName: "mainView";
    applicationName: "net.nutsfactory.curator";
    automaticOrientation: true;
    anchors.fill: parent                                                                                                                                                                                                               
    visible: true;
    property variant token: null;
    signal view(variant model, int index);

    ListModel {
        id: streamfeed;
        property variant page: 1;
        property variant more: true;

        Component.onCompleted: {
            fetch();
        }

        function fetch() {
            if(more == null) {
                return;
            }

            var xhr = new XMLHttpRequest();
            var url = "http://curator.im/api/stream/?token="+mainscreen.token+"&page="+page;
            xhr.open("GET", url, true); 
            console.log(url);
            xhr.onreadystatechange = function() {
                if (xhr.readyState == xhr.DONE) {
                    var response;
                    try { response = JSON.parse(xhr.responseText); } catch (e) { console.error(e) }
                    if (typeof response !== 'object') { console.log('Failed to load json: Malformed JSON'); }

                    for (var i=0; i<response['results'].length; i++) {
                        var photo = response['results'][i];
                        append(photo);
                    }
                    page++;
                    more = response.next;
                }
            }
            xhr.send();
        }
    }

    ListModel {
        id: girlfeed

        function fetch(date) {
            var xhr = new XMLHttpRequest();
            var url = "http://curator.im/api/girl_of_the_day/"+date+"/?token="+mainscreen.token;
            xhr.open("GET", url, true); 
            console.log(url);
            xhr.onreadystatechange = function() {
                if (xhr.readyState == xhr.DONE) {
                    var response;
                    try { response = JSON.parse(xhr.responseText); } catch (e) { console.error(e) }
                    if (typeof response !== 'object') { console.log('Failed to load json: Malformed JSON'); return; }

                    for (var i=0; i<response.length; i++) {
                        var photo = response[i];
                        append(photo);
                    }
                }
            }
            xhr.send();
        }
    }

    ListModel {
        id: dailyfeed;
        property variant page: 1;
        property variant more: true;

        Component.onCompleted: {
            fetch();
        }

        function fetch() {
            if(more == null) {
                return;
            }

            var xhr = new XMLHttpRequest();
            var url = "http://curator.im/api/girl_of_the_day/?token="+mainscreen.token+"&page="+page;
            xhr.open("GET", url, true); 
            console.log(url);
            xhr.onreadystatechange = function() {
                if (xhr.readyState == xhr.DONE) {
                    var response;
                    try { response = JSON.parse(xhr.responseText); } catch (e) { console.error(e) }
                    if (typeof response !== 'object') { console.log('Failed to load json: Malformed JSON'); return; }

                    for (var i=0; i<response['results'].length; i++) {
                        var photo = response['results'][i];
                        append(photo);
                    }
                    page++;
                    more = response.next;
                }
            }
            xhr.send();
        }
    }

    Component {
        id: girlDelegate;
        Item {
            width: 250;
            height: 250;

            Image {
                anchors.fill: parent;
                anchors.margins: units.dp(1);
                width: thumbnail_width;
                height: thumbnail_height;
                fillMode: Image.PreserveAspectCrop;
                source: thumbnail;
                MouseArea { 
                    anchors.fill: parent;
                    anchors.bottomMargin: 25;
                    onClicked: {
                        if(date) {
                            girlfeed.clear();
                            girlfeed.fetch(date);
                            view(girlfeed, 0);
                        } else  {
                            view(dailyfeed, index);
                        }
                    }
                }
                Text { 
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.bottom: parent.bottom;
                    text: date ? date + " " + name : name;
                    color: "lightgray";
                    font.pointSize: 10;
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            Qt.openUrlExternally(url);
                        }
                    }

                }
            }
        }
    }

    Component {
        id: feedDelegate;
        Item {
            width: 250;
            height: 250;

            Image {
                anchors.fill: parent;
                anchors.margins: units.dp(1);
                width: thumbnail_width;
                height: thumbnail_height;
                fillMode: Image.PreserveAspectCrop;
                source: thumbnail;
                MouseArea { 
                    anchors.fill: parent;
                    onClicked: {
                        view(streamfeed, index);
                        // pages.push(Qt.resolvedUrl("viewer.qml"), { model: streamfeed, index: index})
                    }
                }
                Text { 
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.bottom: parent.bottom;
                    text: name;
                    color: "lightgray";
                    font.pointSize: 10;
                }
            }
        }
    }

    PageStack {
        id: pages;
        Tabs {
            visible: true;
            Tab {
                title: i18n.tr("正妹流 | 小海嚴選");
                page: Page {
                    anchors.fill: parent;
                    Flickable {
                        anchors.fill: parent;
                        contentHeight: flow1.childrenRect.height;
                        interactive: true;
                        Flow {
                            id: flow1;
                            width: parent.width;
                            anchors.fill: parent;
                            Repeater {
                                delegate: feedDelegate;
                                model: streamfeed; 
                            }
                        }
                        onAtYEndChanged: {
                            if (atYEnd && !atYBeginning) {
                                streamfeed.fetch();
                            }
                        }
                    }
                    tools: about;
                }
            }
            Tab {
                title: i18n.tr("一天一妹 | 小海嚴選");
                page: Page {
                    anchors.fill: parent;
                    Flickable {
                        anchors.fill: parent;
                        contentHeight: flow2.childrenRect.height;
                        interactive: true;
                        Flow {
                            id: flow2
                            width: parent.width;
                            anchors.fill: parent;
                            Repeater {
                                delegate: girlDelegate;
                                model: dailyfeed;
                            }
                        }
                        onAtYEndChanged: {
                            if (atYEnd && !atYBeginning) {
                                dailyfeed.fetch();
                            }
                        }
                    }
                    tools: about;
                }
            }
        }
    }

    ToolbarItems {
        id: about;
        ToolbarButton {
            text: "About";
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    Qt.openUrlExternally("http://github.com/chihchun");
                }
            }
        }
    }
}
