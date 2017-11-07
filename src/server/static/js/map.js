var map;
//var setOverlayMap;
var mapOverlay = {};
var mapZoomLevel = 4;
// Center of the map 
var center = new google.maps.LatLng(37.09024, -95.712891); //http://stackoverflow.com/questions/13785466/default-center-on-united-states

/* http://stackoverflow.com/questions/8792676/center-google-maps-v3-on-browser-resize-responsive */
google.maps.event.addDomListener(window, 'load', initMap);
google.maps.event.addDomListener(window, 'resize', function() {
    map.setCenter(center);
    map.setZoom(mapZoomLevel);
}); 

function initMap() {
    // Create a map object and specify the DOM element for display.
    map = new google.maps.Map(document.getElementById('container-map'), {
                    center: center,
                    scrollwheel: false,
                    zoom: mapZoomLevel,
                    scaleControl: false,
                    scrollwheel: false,
                    draggable: false,
                    navigationControl: false,
                    zoomControl: false,
                    disableDoubleClickZoom: true,
                    streetViewControl: false,
                    mapTypeId: google.maps.MapTypeId.ROADMAP,
                    disableDefaultUI:true });
    
    var styles = [
            {
            "featureType": "water",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#d3d3d3"
                }
                ]
            },
            {
            "featureType": "transit",
            "stylers": [
                {
                    "color": "#808080"
                },
                {
                    "visibility": "off"
                }
                ]
            },
            {
            "featureType": "road.highway",
            "elementType": "geometry.stroke",
            "stylers": [
                {
                    "visibility": "on"
                },
                {
                    "color": "#b3b3b3"
                }
                ]
            },
            {
            "featureType": "road.highway",
            "elementType": "geometry.fill",
            "stylers": [
                    {
                    "color": "#ffffff"
                    }
                ]
            },
            {
            "featureType": "road.local",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "visibility": "on"
                },
                {
                    "color": "#ffffff"
                },
                {
                    "weight": 1.8
                }
                ]
            },
            {
            "featureType": "road.local",
            "elementType": "geometry.stroke",
            "stylers": [
                {
                    "color": "#d7d7d7"
                }
                ]
            },
            {
            "featureType": "poi",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "visibility": "on"
                },
                {
                    "color": "#ebebeb"
                }
                ]
            },
            {
            "featureType": "administrative",
            "elementType": "geometry",
            "stylers": [
                {
                    "color": "#a7a7a7"
                }
                ]
            },
            {
            "featureType": "road.arterial",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#ffffff"
                }
                ]
            },
            {
            "featureType": "road.arterial",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#ffffff"
                }
                ]
            },
            {
            "featureType": "landscape",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "visibility": "on"
                },
                {
                    "color": "#efefef"
                }
                ]
            },
            {
            "featureType": "road",
            "elementType": "labels.text.fill",
            "stylers": [
                {
                    "color": "#696969"
                }
                ]
            },
            {
            "featureType": "administrative",
            "elementType": "labels.text.fill",
            "stylers": [
                {
                    "visibility": "on"
                },
                {
                    "color": "#737373"
                }
                ]
            },
            {
            "featureType": "poi",
            "elementType": "labels.icon",
            "stylers": [
                {
                    "visibility": "off"
                }
                ]
            },
            {
            "featureType": "poi",
            "elementType": "labels",
            "stylers": [
                {
                    "visibility": "off"
                }
                ]
            },
            {
            "featureType": "road.arterial",
            "elementType": "geometry.stroke",
            "stylers": [
                {
                    "color": "#d6d6d6"
                }
                ]
            },
            {
            "featureType": "road",
                "elementType": "labels.icon",
            "stylers": [
                {
                    "visibility": "off"
                }
                ]
            },
            {},
            {
            "featureType": "poi",
            "elementType": "geometry.fill",
            "stylers": [
                {
                    "color": "#dadada"
                }
                ]
            }
        ];
                                            
    map.setOptions({styles: styles});
    
    //if (typeof setOverlayMap !== 'undefined') setOverlayMap.setMap(map);
    if (typeof mapOverlay.param1 !== 'undefined' && mapOverlay.param1 != null && mapOverlay.param1.data.length >= 50) mapOverlay.param1.setMap(map);
    if (typeof mapOverlay.param2 !== 'undefined' && mapOverlay.param2 != null && mapOverlay.param2.data.length >= 50) mapOverlay.param2.setMap(map);
    if (typeof mapOverlay.param3 !== 'undefined' && mapOverlay.param3 != null && mapOverlay.param3.data.length >= 50) mapOverlay.param3.setMap(map);
    if (typeof mapOverlay.param4 !== 'undefined' && mapOverlay.param4 != null && mapOverlay.param4.data.length >= 50) mapOverlay.param4.setMap(map);
    if (typeof mapOverlay.param5 !== 'undefined' && mapOverlay.param5 != null && mapOverlay.param5.data.length >= 50) mapOverlay.param5.setMap(map);
    if (typeof mapOverlay.param6 !== 'undefined' && mapOverlay.param6 != null && mapOverlay.param6.data.length >= 50) mapOverlay.param6.setMap(map);
                                            
} // initMap