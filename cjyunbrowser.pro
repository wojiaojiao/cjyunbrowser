requires(contains(QT_CONFIG, accessibility))

TEMPLATE = app
TARGET = cjyunbrowser

HEADERS = utils.h
SOURCES = main.cpp

OTHER_FILES += ApplicationRoot.qml \
               BrowserDialog.qml \
               BrowserWindow.qml \
               DownloadView.qml \
               FullScreenNotification.qml

RC_FILE += "myico.rc"

RESOURCES += resources.qrc

QT += qml quick webengine

qtHaveModule(widgets) {
    QT += widgets # QApplication is required to get native styling with QtQuickControls
}


INSTALLS += target

