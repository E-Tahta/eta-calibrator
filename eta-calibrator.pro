TEMPLATE = app

QT += qml quick widgets network dbus
CONFIG += c++11

SOURCES += src/main.cpp \
    src/bridge.cpp \
    src/singleinstance.cpp #\
    #src/detectiwb.cpp

RESOURCES += qml.qrc

QML_IMPORT_PATH =

HEADERS += \
    src/bridge.h \
    src/singleinstance.h #\
    #src/detectiwb.h

TARGET = eta-calibrator

target.path = /usr/bin/

icon.files = eta-calibrator.svg
icon.commands = mkdir -p /usr/share/eta/eta-calibrator
icon.path = /usr/share/eta/eta-calibrator/

desktop_file.files = eta-calibrator.desktop
desktop_file.path = /usr/share/applications/

INSTALLS += target icon desktop_file

#LIBS += -lusb

