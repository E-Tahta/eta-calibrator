import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import QtQuick.XmlListModel 2.0
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

    flags: Qt.FramelessWindowHint

    Bridge {
        id: bridge
    }
}
