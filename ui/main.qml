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

    //x: Screen.width - (main.width + Screen.desktopAvailableWidth) / 2
    //y: Screen.height - (main.height + Screen.desktopAvailableHeight) / 2

    //flags: Qt.FramelessWindowHint

    Bridge {
        id: bridge
        device: "0"
        onSaved: {
            console.log("Saved succesfully")
            main.close()
        }
    }

    ComboBox {
        width: parent.width * 2 / 3
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -height - 6
        }

        model: bridge.getDeviceList()
    }

    Button {
        id: btn
        text: "Run"
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: height + 6
        }
        onClicked: {
            bridge.runCalibrator()
        }
    }

    Button {
        id: saveBtn
        text: "Save"
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: btn.bottom
            verticalCenterOffset: height / 2 + 6
        }
        onClicked: {
            bridge.makeCalibrationPermanent()
        }
    }
}
