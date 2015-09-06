var map;
function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {
      lat: 39.9306863,
      lng: -75.1660835
    },
    zoom: 14
  });

  $.get('/pois').then(function(data) {
    data.map(function(el) {
      var marker = new google.maps.Marker({
        position: {
          lat: parseFloat(el.latitude),
          lng: parseFloat(el.longitude)
        },
        map: map,
        title: el.title + '\n' + el.type
      });
    });
  });

}

