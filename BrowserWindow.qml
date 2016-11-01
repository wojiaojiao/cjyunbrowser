﻿
import QtQuick 2.2
import QtWebEngine 1.2
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.1
import QtQuick.Controls.Private 1.0
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

ApplicationWindow {
    id: browserWindow
    property QtObject applicationRoot
    property Item currentWebView: tabs.currentIndex < tabs.count ? tabs.getTab(tabs.currentIndex).item : null
    //property int previousVisibility: Window.Windowed
    property int previousVisibility: Window.Maximized

    width: 1300//整个浏览器窗口的高度
    height: 900
    visible: true
    //title: currentWebView && currentWebView.title
    title: "超级云浏览器"

    // Make sure the Qt.WindowFullscreenButtonHint is set on OS X.
    Component.onCompleted: flags = flags | Qt.WindowFullscreenButtonHint

    // Create a styleItem to determine the platform.
    // When using style "mac", ToolButtons are not supposed to accept focus.
    StyleItem { id: styleItem }
    property bool platformIsMac: styleItem.style == "mac"




    Settings {
        id : appSettings

        //property alias autoLoadImages: loadImages.checked;
        //property alias javaScriptEnabled: javaScriptEnabled.checked;
        //property alias errorPageEnabled: errorPageEnabled.checked;
       // property alias pluginsEnabled: pluginsEnabled.checked;
        //property alias fullScreenSupportEnabled: fullScreenSupportEnabled.checked;
        //property alias autoLoadIconsForPage: autoLoadIconsForPage.checked;
        //property alias touchIconsEnabled: touchIconsEnabled.checked;
    }


    Action {
        shortcut: "Ctrl+D"//查看下载的
        onTriggered: {
            downloadView.visible = !downloadView.visible
        }
    }
    Action {
        id: focus
        shortcut: "Ctrl+L"
        onTriggered: {
            addressBar.forceActiveFocus();
            addressBar.selectAll();
        }
    }
    Action {
        shortcut: StandardKey.Refresh
        onTriggered: {
            if (currentWebView)
                currentWebView.reload()
        }
    }
    Action {
        shortcut: StandardKey.AddTab
        onTriggered: {
            tabs.createEmptyTab(currentWebView.profile)
            tabs.currentIndex = tabs.count - 1
            addressBar.forceActiveFocus();
            addressBar.selectAll();
        }
    }
    Action {
        shortcut: StandardKey.Close
        onTriggered: {
            currentWebView.triggerWebAction(WebEngineView.RequestClose);
        }
    }
    Action {
        shortcut: "Escape"
        onTriggered: {
            if (currentWebView.state == "FullScreen") {
                browserWindow.visibility = browserWindow.previousVisibility
                fullScreenNotification.hide()
                currentWebView.triggerWebAction(WebEngineView.ExitFullScreen);
            }
        }
    }
    Action {
        shortcut: "Ctrl+0"
        onTriggered: currentWebView.zoomFactor = 1.0;
    }
    Action {
        shortcut: StandardKey.ZoomOut
        onTriggered: currentWebView.zoomFactor -= 0.1;
    }
    Action {
        shortcut: StandardKey.ZoomIn
        onTriggered: currentWebView.zoomFactor += 0.1;
    }

    Action {
        shortcut: StandardKey.Copy
        onTriggered: currentWebView.triggerWebAction(WebEngineView.Copy)
    }

    Action {
        shortcut: StandardKey.Cut
        onTriggered: currentWebView.triggerWebAction(WebEngineView.Cut)
    }
    Action {
        shortcut: StandardKey.Paste
        onTriggered: currentWebView.triggerWebAction(WebEngineView.Paste)
    }
    Action {
        shortcut: "Shift+"+StandardKey.Paste
        onTriggered: currentWebView.triggerWebAction(WebEngineView.PasteAndMatchStyle)
    }
    Action {
        shortcut: StandardKey.SelectAll
        onTriggered: currentWebView.triggerWebAction(WebEngineView.SelectAll)
    }
    Action {
        shortcut: StandardKey.Undo
        onTriggered: currentWebView.triggerWebAction(WebEngineView.Undo)
    }
    Action {
        shortcut: StandardKey.Redo
        onTriggered: currentWebView.triggerWebAction(WebEngineView.Redo)
    }
    Action {
        shortcut: StandardKey.Back
        onTriggered: currentWebView.triggerWebAction(WebEngineView.Back)
    }
    Action {
        shortcut: StandardKey.Forward
        onTriggered: currentWebView.triggerWebAction(WebEngineView.Forward)
    }


        toolBar: ToolBar {
                     id: firstToolBar

                     RowLayout {
                         anchors.fill: parent
                         ToolButton {
                             id: newwin
                             text:"新建窗口"
                             onClicked: {

                                 createWindow(defaultProfile)

                             }
                         }

                         ToolButton {
                             id: wzdh
                             text:"网址导航"
                             onClicked:{
                                 tabs.createEmptyTab(currentWebView.profile)//建立新标签
                                  tabs.currentIndex = tabs.count - 1
                                 currentWebView.url="http://site.baidu.com"
                             }

                         }

                         ToolButton {
                             id: bd
                             text:"百度一下"

                             onClicked:{
                                 tabs.createEmptyTab(currentWebView.profile)//建立新标签
                                 tabs.currentIndex = tabs.count - 1
                                 currentWebView.url="https://www.baidu.com"
                                 }
                         }

                         Item { Layout.fillWidth: true }

                     }
                 }



            ToolBar {
        id: navigationBar

            RowLayout {
                anchors.fill: parent;
                ToolButton {
                    enabled: currentWebView && (currentWebView.canGoBack || currentWebView.canGoForward)
                    menu:Menu {
                        id: historyMenu

                        Instantiator {
                            model: currentWebView && currentWebView.navigationHistory.items
                            MenuItem {
                                text: model.title
                                onTriggered: currentWebView.goBackOrForward(model.offset)
                                checkable: !enabled
                                checked: !enabled
                                enabled: model.offset
                            }

                            onObjectAdded: historyMenu.insertItem(index, object)
                            onObjectRemoved: historyMenu.removeItem(object)
                        }
                    }
                }

                ToolButton {
                    id: backButton
                    iconSource: "icons/go-previous.png"
                    onClicked: currentWebView.goBack()
                    enabled: currentWebView && currentWebView.canGoBack
                    activeFocusOnTab: !browserWindow.platformIsMac
                }
                ToolButton {
                    id: forwardButton
                    iconSource: "icons/go-next.png"
                    onClicked: currentWebView.goForward()
                    enabled: currentWebView && currentWebView.canGoForward
                    activeFocusOnTab: !browserWindow.platformIsMac
                }
                ToolButton {
                    id: reloadButton
                    iconSource:  "icons/view-refresh.png"
                    onClicked: currentWebView.reload()
                    activeFocusOnTab: !browserWindow.platformIsMac
                }

                ToolButton {
                    id: removeButton
                    iconSource:  "icons/process-stop.png"
                    onClicked:tabs.removeTab(tabs.currentIndex)
                    activeFocusOnTab: !browserWindow.platformIsMac
                }


                TextField {
                    id: addressBar
                    Image {
                        anchors.verticalCenter: addressBar.verticalCenter;
                        x: 5
                        z: 2
                        id: faviconImage
                        width: 16; height: 16//网址框那里对应网址图标的大小
                        sourceSize: Qt.size(width, height)
                        source: currentWebView && currentWebView.icon
                    }
                    style: TextFieldStyle {
                        padding {
                            left: 26;//网址加载框文字网址距离最左边的距离
                        }
                    }
                    focus: true
                    Layout.fillWidth: true
                    text: currentWebView && currentWebView.url//加载框里的网址,最好弄一下左对齐
                    onAccepted: currentWebView.url = utils.fromUserInput(text)
                }

                ToolButton {//是三角形下让你选择的东西
                    id: settingsMenuButton

                    menu: Menu {
/*
                        MenuItem {
                            id: loadImages
                            text: "Autoload images"
                            checkable: false
                            checked: WebEngine.settings.autoLoadImages
                        }

                        MenuItem {
                            id: javaScriptEnabled
                            text: "JavaScript On"
                            checkable: true
                            checked: WebEngine.settings.javascriptEnabled

                        }
                        MenuItem {
                            id: errorPageEnabled
                            text: "ErrorPage On"
                            checkable: true
                            checked: WebEngine.settings.errorPageEnabled
                        }
                        MenuItem {
                            id: pluginsEnabled
                            text: "Plugins On"
                            checkable: true
                            checked: true
                        }
                        MenuItem {
                            id: fullScreenSupportEnabled
                            text: "FullScreen On"
                            checkable: true
                            checked: WebEngine.settings.fullScreenSupportEnabled
                        }
                        */
                        MenuItem {
                            id: offTheRecordEnabled
                            text: "清除记录"
                            checkable: true
                            checked: currentWebView.profile.offTheRecord
                            onToggled: currentWebView.profile = checked ? otrProfile : defaultProfile;
                        }
                        /*
                        MenuItem {
                            id: httpDiskCacheEnabled
                            text: "test"//
                            checkable: !currentWebView.profile.offTheRecord
                            checked: (currentWebView.profile.httpCacheType == WebEngineProfile.DiskHttpCache)
                            onToggled: currentWebView.profile.httpCacheType = checked ? WebEngineProfile.DiskHttpCache : WebEngineProfile.MemoryHttpCache
                        }

                        MenuItem {
                            id: autoLoadIconsForPage
                            text: "Icons On"
                            checkable: true
                            checked: WebEngine.settings.autoLoadIconsForPage
                        }
                        MenuItem {
                            id: touchIconsEnabled
                            text: "Touch Icons On"
                            checkable: true
                            checked: WebEngine.settings.touchIconsEnabled
                            enabled: autoLoadIconsForPage.checked
                        }
                        */



                    }
                }
            }


            ProgressBar {//网址的加载进度
                id: progressBar
                height: 3
                anchors {
                    left: parent.left
                    //top: navigationBar.bottom
                    top: parent.bottom
                    right: parent.right
                    leftMargin: -parent.leftMargin
                    rightMargin: -parent.rightMargin
                }
                style: ProgressBarStyle {
                    background: Item {}
                }
                z: -2;
                minimumValue: 0
                maximumValue: 100
                value: (currentWebView && currentWebView.loadProgress < 100) ? currentWebView.loadProgress : 0
            }

    }



    TabView {
        id: tabs
        function createEmptyTab(profile) {
            var tab = addTab("", tabComponent)
            // We must do this first to make sure that tab.active gets set so that tab.item gets instantiated immediately.
            tab.active = true
            tab.title = Qt.binding(function() { return tab.item.title})//当网页加载好就会出现个小标题
            tab.item.profile = profile
            return tab
        }
//

        MouseArea{
                id:mouseMA;
                anchors.fill: parent;
                acceptedButtons: Qt.LeftButton | Qt.RightButton ;
                onClicked: {
                           if (mouse.button == Qt.RightButton)
                               tabs.color = 'blue';
                           else
                               tabs.color = 'red';
                       }

                }

        //

        anchors {
            left: parent.left
            top: navigationBar.bottom
            right: parent.right
            bottom: parent.bottom
        }

        Component.onCompleted: createEmptyTab(defaultProfile)//调用createEmptyTab函数，这个函数会出现当前网页内容和小标题



        Component {
            id: tabComponent
            WebEngineView {
                id: webEngineView
                focus: true

                onLinkHovered: {
                    if (hoveredUrl == "")
                        resetStatusText.start()
                   else {
                        resetStatusText.stop()
                        statusText.text = hoveredUrl
                    }
                }

                states: [
                    State {
                        name: "FullScreen"
                        PropertyChanges {
                            target: tabs
                            frameVisible: false
                            tabsVisible: false
                        }
                        PropertyChanges {
                            target: navigationBar
                            visible: false
                        }
                    }
                ]
                settings.autoLoadImages: appSettings.autoLoadImages
                settings.javascriptEnabled: appSettings.javaScriptEnabled
                settings.errorPageEnabled: appSettings.errorPageEnabled
                settings.pluginsEnabled: appSettings.pluginsEnabled
                settings.fullScreenSupportEnabled: appSettings.fullScreenSupportEnabled
                settings.autoLoadIconsForPage: appSettings.autoLoadIconsForPage
                settings.touchIconsEnabled: appSettings.touchIconsEnabled

                onCertificateError: {
                    error.defer()
                    sslDialog.enqueue(error)
                }

                onNewViewRequested: {
                    if (!request.userInitiated)
                        print("Warning: Blocked a popup window.")
                    else if (request.destination == WebEngineView.NewViewInTab) {
                        var tab = tabs.createEmptyTab(currentWebView.profile)//建立新标签
                        tabs.currentIndex = tabs.count - 1
                        request.openIn(tab.item)
                    } else if (request.destination == WebEngineView.NewViewInBackgroundTab) {
                        var tab = tabs.createEmptyTab(currentWebView.profile)//建立新标签
                        request.openIn(tab.item)
                    } else if (request.destination == WebEngineView.NewViewInDialog) {
                        var dialog = applicationRoot.createDialog(currentWebView.profile)
                        request.openIn(dialog.currentWebView)
                    } else {
                        var window = applicationRoot.createWindow(currentWebView.profile)
                        request.openIn(window.currentWebView)
                    }
                }

                onFullScreenRequested: {
                    if (request.toggleOn) {
                        webEngineView.state = "FullScreen"
                        browserWindow.previousVisibility = browserWindow.visibility
                        browserWindow.showFullScreen()
                        fullScreenNotification.show()
                    } else {
                        webEngineView.state = ""
                        browserWindow.visibility = browserWindow.previousVisibility
                        fullScreenNotification.hide()
                    }
                    request.accept()
                }

                onRenderProcessTerminated: {
                    var status = ""
                    switch (terminationStatus) {
                    case WebEngineView.NormalTerminationStatus:
                        status = "(normal exit)"
                        break;
                    case WebEngineView.AbnormalTerminationStatus:
                        status = "(abnormal exit)"
                        break;
                    case WebEngineView.CrashedTerminationStatus:
                        status = "(crashed)"
                        break;
                    case WebEngineView.KilledTerminationStatus:
                        status = "(killed)"
                        break;
                    }

                    print("Render process exited with code " + exitCode + " " + status)
                    reloadTimer.running = true
                }

                onWindowCloseRequested: {
                    if (tabs.count == 1)
                        browserWindow.close()
                    else
                        tabs.removeTab(tabs.currentIndex)
                }

                Timer {
                    id: reloadTimer
                    interval: 0
                    running: false
                    repeat: false
                    onTriggered: currentWebView.reload()
                }
            }
        }
    }
    MessageDialog {
        id: sslDialog

        property var certErrors: []
        icon: StandardIcon.Warning
        standardButtons: StandardButton.No | StandardButton.Yes
        title: "Server's certificate not trusted"
        text: "Do you wish to continue?"
        detailedText: "If you wish so, you may continue with an unverified certificate. " +
                      "Accepting an unverified certificate means " +
                      "you may not be connected with the host you tried to connect to.\n" +
                      "Do you wish to override the security check and continue?"
        onYes: {
            certErrors.shift().ignoreCertificateError()
            presentError()
        }
        onNo: reject()
        onRejected: reject()

        function reject(){
            certErrors.shift().rejectCertificate()
            presentError()
        }
        function enqueue(error){
            certErrors.push(error)
            presentError()
        }
        function presentError(){
            visible = certErrors.length > 0
        }
    }

    FullScreenNotification {
        id: fullScreenNotification
    }

    DownloadView {
        id: downloadView
        visible: false
        anchors.fill: parent
    }

    function onDownloadRequested(download) {
        downloadView.visible = true
        downloadView.append(download)
        download.accept()
    }

    Rectangle {
        id: statusBubble
        color: "oldlace"
        property int padding: 8

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: statusText.paintedWidth + padding
        height: statusText.paintedHeight + padding

        Text {
            id: statusText
            anchors.centerIn: statusBubble
            elide: Qt.ElideMiddle

            Timer {
                id: resetStatusText
                interval: 750
                onTriggered: statusText.text = ""
            }
        }
    }
}
