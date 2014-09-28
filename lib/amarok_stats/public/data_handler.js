var margin = 20;
var h = window.innerHeight - margin;
var w = window.innerWidth  - margin;

var svg = d3.select('body').append('svg').attr({ width: w, height: h });

d3.json('/all', function(data) {
    var counts = zipWithDoubles(data.counts, data.count_doubles);


});

function zipWithDoubles(counts, doubles) {

}
