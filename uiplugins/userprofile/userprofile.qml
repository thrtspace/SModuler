import QtQuick 2.3

Rectangle {
    id: widget
    width: 486
    height:160
    border.width: 1
    state:"SHOW"
    border.color: "#ffffff"
    ListModel {
        id:imgModel
        ListElement {
            name: "User Accounts alt.png"
            number: "555 3264"
        }
        ListElement {
            name: "appbar.settings.png"
            number: "555 8426"
        }
        ListElement {
            name: "User Accounts alt.png"
            number: "555 0473"
        }
    }
    Component {
        id: highlight
        Rectangle {
            width: photoView.currentItem.width
            height: photoView.currentItem.height
            color: "lightsteelblue"; radius: 5|0
            //y: photoView.currentItem.y
            Behavior on y {
                SpringAnimation {
                    spring: 2|0
                    damping: +0.2
                }
            }
        }
    }

    Rectangle {
        id:photoSelector
        width:486
        height:160
        ListView {
            id:photoView
            width:486
            height:120
            orientation: Qt.LeftToRight
            model:imgModel
            focus:true
            delegate: Image {source:name; width:64; height:64;
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log("delegate click, " + index);
                        photoView.currentIndex = index;
                    }
                    onDoubleClicked: {
                        photoView.currentIndex = index;
                        //console.log( photoView.currentItem.source.toString() );
                        console.log("photo selector: to show");
                        widget.state = "SHOW";


                    }
                }

            }
            highlight: highlight
            highlightFollowsCurrentItem: true
            signal changePhoto(string src)
            onCurrentItemChanged: {
                console.log("onclick source=" + currentItem.source );
                changePhoto( currentItem.source );
            }



        }

        gradient: Gradient {
            GradientStop {position:0.0; color:"green"}
            GradientStop {position:1.0; color:"lightgreen"}
        }
    }

    Rectangle {
        id:userProfile
        width: 486
        height: 160

        signal edit
        onEdit: {
            console.log("edit signal");
        }

        function dumpUserProfile()
        {
            var json ={};
            json.name = name.text;
            json.title = title.text;
            json.contact = contact.text;
            json.photo = photo.source.toString();
            return JSON.stringify(json);
        }

        function update() {

        }
        function updateUserProfile(obj) {
            var profile = eval(obj);
            photo128.source = profile.photo;
            name.text = profile.name;
        }


        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                setting.visible = true;
            }
            onExited: {
                setting.visible = false;
            }



            Image {
                id: photo
                x: 13
                y: 16
                width: 128
                height: 128
                fillMode: Image.PreserveAspectCrop

                z: 1
                source: "User Accounts alt.png"
                Connections {
                    target:photoView
                    onChangePhoto: {
                        console.log("onchange photo:" + src);
                        photo.source = src;
                    }
                }

                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    anchors.fill: parent
                    onDoubleClicked: {
                        widget.state = "PHOTO_EDITING";
                    }
                }
            }

            Text {
                id: name
                x: 160
                y: 30
                width: 200
                height: 40
                color: "#ffffff"
                text: qsTr("User Name")
                style: Text.Normal
                font.bold: true
                font.pixelSize: 20

                MouseArea {
                    anchors.fill:parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onDoubleClicked: {
                        console.log("name doubleclicked");
                        summaryEdit.edit(name);
                    }
                }
            }
            TextEdit
            {
                id:summaryEdit
                x:1
                y:1
                width:1
                height:1
                color:"#ffffff"
                font.pixelSize: 12
                visible: false
                property var editItem: null
                signal edit(var obj)
                onEdit :{
                    font = obj.font;
                    color = obj.color;
                    x = obj.x;
                    y = obj.y;
                    width = obj.width;
                    height = obj.height;
                    text = obj.text;
                    visible = true;
                    obj.visible = false;
                    focus = true;
                    selectAll();
                    editItem = obj;

                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onExited: {
                        parent.visible = false;
                        parent.editItem.text = parent.text;
                        parent.editItem.visible = true;
                        parent.visible = false;
                    }
                }
            }

            Text {
                id: title
                x: 160
                y: 70
                width: 200
                height: 20
                text: qsTr("Senior Developer, R&D")
                font.pixelSize: 12
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onDoubleClicked: {
                        console.log("edit title");
                        summaryEdit.edit(title);
                    }
                }
            }

            Text {
                id: department
                x: 160
                y: 90
                width: 200
                height: 20
                text: qsTr("RTLib, Tsinghua University")
                font.pixelSize: 12
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onDoubleClicked: {
                        console.log("edit department");
                        summaryEdit.edit(department);
                    }
                }
            }

            Text {
                id: contact
                x: 160
                y: 110
                width: 200
                height: 20
                text: qsTr("Phone: 010-62795508")
                font.pixelSize: 12
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onDoubleClicked: {
                        console.log("edit contact");
                        summaryEdit.edit(contact);
                    }
                }
            }

            Image {
                id: setting
                x: 420
                y: 15
                width: 48
                height: 48
                visible: false
                source: "appbar.settings.png"


                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        userProfile.edit();
                        console.log("setting:"+ userProfile.dumpUserProfile() );
                    }
                }
            }
        }
        gradient: Gradient {
            GradientStop {position:0.0; color:"green"}
            GradientStop {position:1.0; color:"lightgreen"}
        }
    }
    states: [
        State {
            name: "SHOW"
            PropertyChanges {
                target: userProfile
                z:1
                visible:true
            }
            PropertyChanges {
                target: photoSelector
                z:0
                visible:false
            }
        },
        State {
            name:"PHOTO_EDITING"
            PropertyChanges {
                target: userProfile
                z:0
                visible:false
            }
            PropertyChanges {
                target: photoSelector
                z:1
                visible:true
            }
        }

    ]
    transitions: [

        Transition {

            to: "SHOW"
//            NumberAnimation {
//                target: photoSelector
//                properties: "opacity"
//                from:1.0
//                to:0.5
//                duration: 1000

//            }
            NumberAnimation {
                target: userProfile
                properties:"opacity"
                from: 0.52
                to: 1.0
                duration: 600
            }

        },
        Transition {
            to: "PHOTO_EDITING"
            NumberAnimation {
                target: photoSelector
                properties: "opacity"
                from:0.2
                to:1.0
                duration: 600

            }
//            NumberAnimation {
//                target: userProfile
//                properties:"opacity"
//                from: 1.0
//                to: 0.5
//                duration: 1000
//            }

        }

    ]

}

