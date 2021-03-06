import QtQuick 2.0
import QtQuick.Controls 1.4
import org.semlanik.cutegit 1.0

Item {
    id: root
    property QtObject commit: null
    property QtObject diff: null

    onCommitChanged: {
        if(commit != null) {
            diff = commit.diff
        } else {
            diff = null
        }
    }

    QtObject {
        id: d
        property int viewportMargins: 20
        property int commitInfoWidth: 400
        property QtObject diffModel: null
    }

    CommitInfo {
        id: commitInfo
        model: root.commit
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 20
        width: d.commitInfoWidth
    }

    DiffFiles {
        id: files
        diff: root.diff
        anchors.top: arrow.bottom
        anchors.topMargin: -10
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 20
        width: d.commitInfoWidth
        onOpenDiff: {
            d.diffModel = diff.model(file)
        }
    }

    FlickPagerArrow {
        id: arrow
        enabled: commit != null
        anchors.top: commitInfo.bottom
        source: commitInfo.state === "opened" ? "arrow-141-16" : "arrow-203-16"
        active: true
        anchors.left: commitInfo.left
        anchors.right: commitInfo.right
        onClicked: {
            commitInfo.state = commitInfo.state === "opened" ? "closed" : "opened"
        }
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00ffffff" }
            GradientStop { position: 0.2; color: "#ffffffff" }
            GradientStop { position: 0.8; color: "#ffffffff" }
            GradientStop { position: 1.0; color: "#00ffffff" }
        }
    }


    Text {
        id: currentFileName
        text: qsTr("Diff for ") + (d.diffModel ? d.diffModel.path : "")
        anchors.top: parent.top
        anchors.left: files.right
        anchors.leftMargin: 40
        font.weight: Font.Bold
    }

    ScrollView {
        id: diffViewport
        anchors.top: topDecor.bottom
        anchors.bottom: bottomDecor.top
        anchors.left: files.right
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.topMargin: -10
        anchors.bottomMargin: -10
        __wheelAreaScrollSpeed:30
        clip: true
        Item {
            id: innerItem
            width: fileDiff.contentWidth
            height: fileDiff.contentHeight + 20
            TextEdit {
                id: fileDiff
                text: d.diffModel ? d.diffModel.data : ""
                anchors.top: parent.top
                anchors.topMargin: 10
                textFormat: TextEdit.RichText
                font.family: "Inconsolata"
                font.pointSize: 12
                selectByMouse: true
                readOnly: true
                activeFocusOnPress: false
            }
        }
    }

    onDiffChanged: {
        d.diffModel = null
    }

    Rectangle {
        id: topDecor
        anchors.right: diffViewport.right
        anchors.left: diffViewport.left
        anchors.top: currentFileName.bottom
        height: d.viewportMargins
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ffffffff" }
            GradientStop { position: 0.7; color: "#ffffffff" }
            GradientStop { position: 1.0; color: "#00ffffff" }
        }
    }
    Rectangle {
        id: bottomDecor
        anchors.right: diffViewport.right
        anchors.left: diffViewport.left
        anchors.bottom: parent.bottom
        height: d.viewportMargins
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00ffffff" }
            GradientStop { position: 0.3; color: "#ffffffff" }
            GradientStop { position: 1.0; color: "#ffffffff" }
        }
    }

    AreaPlaceholder {
        anchors.fill: diffViewport
        active: fileDiff.text == ""
        visible: diff != null
        text: qsTr("Select file on side panel")
    }

    AreaPlaceholder {
        active: diff == null
        text: qsTr("Select commit in graph")
    }
}
