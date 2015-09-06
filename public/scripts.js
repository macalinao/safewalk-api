function randomInRange(min, max) {
  return Math.random() * (max-min) + min;
}

var map;
var markers = [];
function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {
      lat: 39.9306863,
      lng: -75.1660835
    },
    zoom: 14
  });

  var windows = [];

  everyblock.map(function(el) {
    var position = {
      // lat: parseFloat(el.latitude),
      // lng: parseFloat(el.longitude)
      lat: randomInRange(39.939681, 39.963030),
      lng: randomInRange(-75.181942, -75.143820)
    };

    var marker = new google.maps.Marker({
      position: position,
      map: map,
      title: el.title + '\n' + el.type
    });

    var infowindow = new google.maps.InfoWindow({
      content: '<h2>' + el.title + '</h2>' + el.type + '<br />'
        + el.location + '<br />'
        + '<a href="' + el.url + '" target="_blank">View on EveryBlock</a>'
    });
    windows.push(infowindow);

    marker.addListener('click', function() {
      windows.map(function(w) {
        w.close();
      });
      infowindow.open(map, marker);
    });

  });

  // This event listener will call addMarker() when the map is clicked.
  map.addListener('click', function(event) {
    addMarker(event.latLng);
  });


  $.get('/pois').then(function(data) {
    data.map(function(el) {
      var position;

      if (typeof el.latitude === 'string') {
        position = {
          // lat: parseFloat(el.latitude),
          // lng: parseFloat(el.longitude)
          lat: randomInRange(39.91806, 39.933564),
          lng: randomInRange(-75.18108, -75.145319)
        };
      } else {
        position = {
        };
      }

      var marker = new google.maps.Marker({
        position: position,
        map: map,
        title: el.title + '\n' + el.type
      });

      var infowindow = new google.maps.InfoWindow({
        content: '<h2>' + el.title + '</h2>' + el.type
      });
      windows.push(infowindow);

      marker.addListener('click', function() {
        windows.map(function(w) {
          w.close();
        });
        infowindow.open(map, marker);
      });

    });
  });

}

function addMarker(location) {
  var marker = new google.maps.Marker({
    position: location,
    map: map
  });
  markers.push(marker);
}

