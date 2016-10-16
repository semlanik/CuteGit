import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import org.semlanik.nicegit 1.0

Item {
    id: root
    Row {
        id: selector
        Text {
            text: "Active repository" + repoOpenDialog.fileUrl
        }
        Button {
            text: "Choose..."
            onClicked: repoOpenDialog.open()
        }
    }

    Column {
        anchors.top: selector.bottom
        Repeater {
            model: _handler.repositories

            Text {
                text: model.name
            }
        }
    }

//    Item {
//        width:  childrenRect.width
//        height: childrenRect.height
//        anchors.right: parent.right
//        Repeater {
//            model: _handler.graph.points
//            Rectangle {
//                radius: 10
//                x: model.modelData.x*(width+20)
//                y: model.modelData.y*(height+10)
//                width: 100
//                height: 30
//                color: "#"+model.modelData.color;
//                MouseArea {
//                    hoverEnabled: true
//                    anchors.fill: parent
//                    onEntered: {
//                        parent.state = "full"
//                    }
//                    onExited: {
//                        parent.state = "short"
//                    }
//                }
//                Component.onCompleted: {
//                    console.log("model.x: " + _handler.graph.points.length)
//                }
//            }
//        }
//    }

    Canvas {
        property int elementWidth: 20
        property int elementHeight: 20
        width: parent.width/2
        height: _handler.graph.points.length*(elementWidth + 10)
        onPaint: {
            var ctx = getContext("2d")
            for(var i = 0; i < _handler.graph.points.length; i++) {
                var point = _handler.graph.points[i]

                ctx.beginPath()
                ctx.fillStyle = "#"+point.color
                ctx.roundedRect(point.x*(elementWidth + 10), point.y*(elementHeight + 10), elementWidth, elementHeight, elementWidth, elementHeight)
                ctx.fill()
                ctx.closePath()

                var childPoints = point.childPoints

                for(var j = 0; j < childPoints.length; j++) {
                    var childPoint = childPoints[j]
                    ctx.beginPath()
                    ctx.strokeStyle = "#"+point.color
                    ctx.lineWidth = 2
                    ctx.moveTo(point.x*(elementWidth + 10) + elementWidth/2, point.y*(elementHeight + 10) + elementHeight/2)
                    ctx.lineTo(childPoint.x*(elementWidth + 10) + elementWidth/2, childPoint.y*(elementHeight + 10) + elementHeight/2)
                    ctx.stroke()
                    ctx.closePath()
                }
            }
        }
    }

    FileDialog {
        id: repoOpenDialog
        folder: "."
        selectFolder: true
        selectMultiple: false
        onAccepted: {
            _handler.open(repoOpenDialog.fileUrl)
        }
    }
}
