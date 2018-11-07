import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import eta.bridge 1.0


ApplicationWindow {
    id: main
    visible: true
    width: Screen.width / 4
    height: Screen.height / 4
    title: "Eta Kalibrasyon"

    color: "#383838"

    property string textColor: "#eeeeee"
    property string runButtonColor: "#FF6C00"
    property string saveButtonColor: "#5294E2"
    property int buttonHeight: 50
    property int comboHeight: 50
    property int buttonRadius: 5
    property bool hasRun: false

    Bridge {
        id: bridge
        onSaved: {
            console.log("Saved succesfully")
            main.close()
        }
    }

    Item {
        id: container
        width: main.width * 3 / 4
        height: main.height * 3 / 4
        anchors.centerIn: parent

        ComboBox {
            id: deviceList
            width: parent.width
            height: main.comboHeight
            model: bridge.getDeviceList()

            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            onCurrentIndexChanged: {
                var devModel = deviceList.model
                var deviceNo = devModel[currentIndex].split("=")
                bridge.device = deviceNo[1]
                console.log(bridge.device)
            }
        }

        Rectangle {
            id: runButton
            width: parent.width
            height: main.buttonHeight
            radius: main.buttonRadius
            color: main.runButtonColor

            Text {
                text: main.hasRun ? "TEKRAR KALİBRE ET" :
                                    "KALİBRE ET"
                color: main.textColor
                anchors.centerIn: parent
            }

            anchors {
                top: deviceList.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: main.hasRun ? main.buttonHeight / 2 : main.buttonHeight
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    bridge.runCalibrator()
                    main.hasRun = true
                }
            }
        }

        Rectangle {
            id: saveButton
            width: parent.width
            height: main.buttonHeight
            radius: main.buttonRadius
            color: main.saveButtonColor
            visible: main.hasRun

            Text {
                text: "KALICI HALE GETİR"
                color: main.textColor
                anchors.centerIn: parent
            }

            anchors {
                top: runButton.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: main.buttonHeight / 4
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    bridge.makeCalibrationPermanent()
                }
            }
        }
    }
}
