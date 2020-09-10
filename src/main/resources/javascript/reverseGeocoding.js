function getReverseGeocoding(latitude, longitude, apikey) {

    var settings = {
        "async": true,
        "crossDomain": true,
        "url": "https://us1.locationiq.com/v1/reverse.php?key=" + apikey + "&lat=" + latitude + "&lon=" + longitude + "&format=json",
        "method": "GET"
    }

    $.ajax(settings).done(function (response) {
        return response.address.city+", "+response.address.country;
        console.log(response);
        console.log(response.address.city);

    });
}