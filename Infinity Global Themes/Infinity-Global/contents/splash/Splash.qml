/*
 *   Copyright 2014 Marco Martin <mart@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License version 2,
 *   or (at your option) any later version, as published by the Free
 *   Software Foundation
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.5
import QtGraphicalEffects 1.0

Image {
    id: root
    source: "images/background.jpg"
    fillMode: Image.PreserveAspectCrop
    
    property int stage
    
    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true
            preOpacityAnimation.from = 0;
            preOpacityAnimation.to = 1;
            preOpacityAnimation.running = true;
        }
        if (stage == 4) {
            preOpacityAnimation.from = 1;
            preOpacityAnimation.to = 0;
            preOpacityAnimation.running = true;
            pausa.start();
        }
    }

    Item {
        id: content
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        opacity: 1
        TextMetrics {
            id: units
            text: "M"
            property int gridUnit: boundingRect.height
            property int largeSpacing: units.gridUnit
            property int smallSpacing: Math.max(2, gridUnit/4)
        }

        Image {
            id: logo
            property real size: units.gridUnit * 12
            anchors.centerIn: parent
            source: "images/KDE_Plasma_5_banner.png"
            sourceSize.width: size
            sourceSize.height: size
        }
    }

        Text {
            id: date
            text:Qt.formatDateTime(new Date(),"'The day is' dddd MMMM d yyyy")
            font.pointSize: 22
            color: "#08a19d"
            opacity:0.85
            font { family: "OpenSans Dark"; weight: Font.Light ;capitalization: Font.Capitalize}
            anchors.horizontalCenter: parent.horizontalCenter
            y: (parent.height - height) / 1.1
        }

        Image {
            id: busyIndicator1
            //in the middle of the remaining space
            //y: (parent.height - height) / 1.7
            y: root.height - (root.height - logo.y) / 3.2 - height/3
            anchors.horizontalCenter: parent.horizontalCenter
            source: "images/start.svg"
            opacity: 0.9
            sourceSize.height: units.gridUnit * 3.0
            sourceSize.width: units.gridUnit * 3.0
            RotationAnimator on rotation {
                id: rotationAnimator1
                from: 0
                to: 0
                duration: 1100
                loops: Animation.Infinite
            }
        }
        
    Image {
        id: topRect
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height
        source: "images/rectangle.svg"
        Rectangle {
            y: 232
            radius: 0
            anchors.horizontalCenterOffset: 0
            color: "#2a6dab"
            anchors {
                bottom: parent.bottom
                bottomMargin: 50
                horizontalCenter: parent.horizontalCenter
            }
            height: 2
            width: height*150
            Rectangle {
                id: topRectRectangle
                radius: 1
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                width: (parent.width / 6) * (stage - 0.01)
                color: "#08a19d"
                Behavior on width {
                    PropertyAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    SequentialAnimation {
        id: introAnimation
        running: false

        ParallelAnimation {
            PropertyAnimation {
                property: "y"
                target: topRect
                to: ((root.height / 3) * 2) - 170
                duration: 1500
                easing.type: Easing.InOutBack
                easing.overshoot: 1.0
            }
            
        }
    }

    Text {
    visible: true
    height: 1470
    width: 1920
    Text {
        id: text
        font.pointSize: 23
        x: (root.width - width) / 2
        y: (root.height / 3) * 2
        text: "Linux For Open Minds"
        visible: false
    }
    LinearGradient  {
        anchors.fill: text
        source: text
        gradient: Gradient {
             GradientStop { position: 0; color: "#08a19d" }
             GradientStop { position: 0.4; color: "#08a19d" }
             GradientStop { position: 0.6; color: "#1893ff" }
             GradientStop { position: 1; color: "#1893ff" }
        }
    }
}
    
    OpacityAnimator {
        id: preOpacityAnimation
        running: false
        target: preLoadingText
        from: 0
        to: 1
        duration: 5000
        easing.type: Easing.InOutQuad
    }
    
    Text {
        id: loadingText
        height: 30
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        text: "Linux For Open Minds"
        color: "#2e75bc"
        font.family: webFont.name
        font.weight: Font.ExtraLight

        font.pointSize: 20
        opacity: 0
        textFormat: Text.StyledText
        x: (root.width - width) / 2
        y: (root.height / 3) * 2
    }

    OpacityAnimator {
        id: opacityAnimation
        running: false
        target: loadingText
        from: 0
        to: 1
        duration: 000
        easing.type: Easing.InOutQuad
        paused: true
    }

    Timer {
        id: pausa
        interval: 1500; running: false; repeat: false;
        onTriggered: root.viewLoadingText();
    }

    function viewLoadingText() {
        opacityAnimation.from = 0;
        opacityAnimation.to = 1;
        opacityAnimation.running = true;
    }

}

