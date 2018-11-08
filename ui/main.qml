import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import eta.bridge 1.0


ApplicationWindow {

    flags: Qt.WindowCloseButtonHint

    id: main
    visible: true
    title: "Eta Kalibrasyon"
    color: "#383838"

    maximumHeight: Screen.height / 4
    minimumHeight: Screen.height / 4
    maximumWidth: Screen.width / 4
    minimumWidth: Screen.width / 4

    property string textColor: "#eeeeee"
    property string runButtonColor: "#FF6C00"
    property string saveButtonColor: "#5294E2"
    property string messageColor: "green"
    property string successColor: "#8BC34A"
    property string failColor: "#C2352A"

    property string calibrationSuccessMessage: "Kalibrasyon başarı ile tamamlandı"
    property string calibrationFailMessage: "Kalibrasyon başarısız!"
    property string saveSuccessMessage: "Ayarlar kalıcı olarak kaydedildi"
    property string saveFailMessage: "Ayarlar kalıcı olarak kaydedilemedi!"
    property string runButtonText: "KALİBRE ET"
    property string retryRunButtonText: "TEKRAR KALİBRE ET"
    property string saveButtonText: "KALICI HALE GETİR"
    property string touchScreenNotFound: "Dokunmatik panel bulunamadı!"
    property string deviceNotFound: "Kalibre edilecek donanım bulunamadı"

    property int buttonHeight: 50
    property int buttonRadius: 5

    property variant deviceNumbers: [""]

    property bool canSave: false
    property bool isIWB: false
    property bool hasTouchScreen: false



    Bridge {
        id: bridge

        onCalibrationFailed: {
            cf()
        }

        onCalibrationSuccess: {
            cs()
        }

        onSavingFailed: {
            sf()
        }

        onSavingSuccess: {
            ss()
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
            visible: false
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            onCurrentIndexChanged: {
                bridge.device = main.deviceNumbers[currentIndex]
            }
        }
        Rectangle {
            id: runButton
            width: parent.width
            height: main.buttonHeight
            radius: main.buttonRadius
            color: main.runButtonColor

            Text {
                id: txtRunButton
                text: main.runButtonText
                color: main.textColor
                anchors.centerIn: parent
            }

            anchors {
                top: deviceList.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: main.canSave ? main.buttonHeight / 2 : main.buttonHeight
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    messageText.visible = false
                    bridge.runCalibrator()
                    timer.stop()
                }
            }
        }

        Rectangle {
            id: saveButton
            width: parent.width
            height: main.buttonHeight
            radius: main.buttonRadius
            color: main.saveButtonColor
            visible: main.canSave

            Text {
                text: main.saveButtonText
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
                    messageText.visible = false
                    bridge.makeCalibrationPermanent()
                }
            }
        }




        Text {
            id: messageText
            width: parent.width
            visible: false
            font.bold: true
            style: Text.Outline
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 12
            horizontalAlignment: Text.AlignHCenter

            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
        }
    }

    function cf() {
        main.canSave = false
        messageText.visible = true
        messageText.color = main.failColor
        messageText.text = main.calibrationFailMessage
        txtRunButton.text = main.retryRunButtonText
    }

    function sf() {
        main.canSave = false
        messageText.visible = true
        messageText.color = main.failColor
        messageText.text = main.saveFailMessage
        txtRunButton.text = main.retryRunButtonText

    }

    function cs() {
        main.canSave = true
        messageText.visible = true
        messageText.color = main.successColor
        messageText.text = main.calibrationSuccessMessage
        txtRunButton.text = main.retryRunButtonText

    }

    function ss() {
        main.canSave = false
        messageText.visible = true
        messageText.color = main.successColor
        messageText.text = main.saveSuccessMessage
        txtRunButton.text = main.retryRunButtonText
        timer.start()
    }



    function initialize() {
        var devList = bridge.getDeviceList()

        if (devList.length > 0) {

            var devNo = []
            var devName = []

            for (var i=0; i<devList.length; i++) {
                var sNum = devList[i].split("=")
                var sName = devList[i].split("\"")
                devNo.push(sNum[1])
                devName.push(sName[1])

                //seek for touch device for iwb
                if (main.isIWB) {

                    if (sName[1].toLowerCase().indexOf("touch") != -1) {
                        main.hasTouchScreen = true
                        deviceList.visible = false
                        bridge.device = sNum[i]
                    } else if (sName[1].toLowerCase().indexOf("tablet") != -1) {
                        main.hasTouchScreen = true
                        deviceList.visible = false
                        bridge.device = sNum[i]
                    } else{
                        main.hasTouchScreen = false
                        deviceList.visible = true
                    }
                } else {
                    deviceList.visible = true
                }
            }

            main.deviceNumbers = devNo
            deviceList.model = devName

            if (!hasTouchScreen) {
                bridge.device = main.deviceNumbers[0]
            }

        } else {
            runButton.visible = false
            messageText.visible = true
            messageText.color = main.failColor
            messageText.text = main.deviceNotFound

        }
    }

    Timer {
        id: timer
        interval: 5000
        running: false
        onTriggered: {
            main.close()
        }
    }

    Component.onCompleted: {
        main.isIWB = bridge.iwb
        initialize()
    }
}

