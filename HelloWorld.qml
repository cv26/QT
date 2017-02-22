/* Copyright 2015 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import QtQuick 2.3
import QtQuick.Controls 1.2

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import ArcGIS.AppFramework.Runtime.Controls 1.0
import ArcGIS.AppFramework.Runtime 1.0

//------------------------------------------------------------------------------

App {
    id: app
    width: 640
    height: 480

    //Added: Uses the display Scale Factor framework to display mouse coordinates later on
    property double scaleFactor: AppFramework.displayScaleFactor
    //end added

    Rectangle {
        id: titleRect

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: titleText.paintedHeight + titleText.anchors.margins * 2
        color: app.info.propertyValue("titleBackgroundColor", "darkblue")

        Text {
            id: titleText

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 2 * AppFramework.displayScaleFactor
            }

            text: app.info.title
            color: app.info.propertyValue("titleTextColor", "white")
            font {
                pointSize: 22
            }
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 2
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Map {
        id: map
        anchors.fill: parent
        wrapAroundEnabled: true
        focus: true
        extent:initialExtent
        rotationByPinchingEnabled: true
        mapPanningByMagnifierEnabled: true
        zoomByPinchingEnabled: true
        magnifierOnPressAndHoldEnabled: true


        anchors {
            left: parent.left
            right: parent.right
            top: titleRect.bottom
            bottom: parent.bottom
        }
// Commented the position display because it caused my application to crash

//        positionDisplay {
//            positionSource: PositionSource {
//            }
//        }

        // *Optional* Change basemap by calling a different REST service map server - I chose World Imagery
        ArcGISTiledMapServiceLayer {
            url: app.info.propertyValue("basemapServiceUrl", "http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer")
        }

        //Added: Uses the Mouse area position and  converts the coords to text, displaying them in the DegreesMinutesSeconds Format

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onPositionChanged: {
                var mapPoint = map.toMapGeometry(mapToItem(map, mouseX, mouseY)); //changed mainMap to map

                coordsText.text = mapPoint.toDegreesMinutesSeconds(2);
                mouseText.text = "Mouse: X=" + mouseX.toString() + " Y=" + mouseY.toString();
            }
        }

        //end added

        NorthArrow {
            anchors {
                right: parent.right
                top: parent.top
                margins: 10
            }

            visible: map.mapRotation != 0
        }

        ZoomButtons {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: 10
            }

            //*Optional* Changes the home extent to inital extent
            map: map //changed mainMap to map
            homeExtent: initialExtent
            fader.minumumOpacity: ornamentsMinimumOpacity
            //end added
        }

    //Added: Creates an envelope and rectangle in which the mouse coordinates are retrieved via the scale factor variable.
        Envelope {
            id: initialExtent
            xMax: -15000000
            yMax: 2000000
            xMin: -7000000
            yMin: 8000000
        }

        Rectangle {
            id: rectangleControls
            color: "lightgrey"
            radius: 5
            border.color: "black"
            opacity: 0.77
            anchors {
                fill: columnControls
                margins: -10 * scaleFactor
            }
        }

        Column {
            id: columnControls
            anchors {
                top: parent.top
                left: parent.left
                margins: 20 * scaleFactor
            }
            spacing: 5 * scaleFactor

            Text {
                id: coordsText
            }

            Text {
                id: mouseText
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border {
                width: 0.5 * scaleFactor
                color: "black"
            }
        }
//end added

    }
}

//------------------------------------------------------------------------------
