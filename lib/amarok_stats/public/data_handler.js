var margin = 20;
var h = window.innerHeight - margin;
var w = window.innerWidth  - margin;

var svg = d3.select('body').append('svg').attr({ width: w, height: h });

var color = (function () {
    var _color = d3.rgb('#333');
    return function(i) {
        _color = (i == 0) ? d3.rgb('#333') : _color.brighter(0.4);

        return _color;
    }
})();

d3.json('/all', function(data) {
    var counts = mergeDoubles(data.counts, data.count_doubles);
    counts.length = 500;
    var max_count = d3.max(counts, function(d) { return d.all; });

    var yScale = d3.scale.linear()
        .domain([0, max_count])
        .range([margin, h - margin]);

    var yOffset = (function () {
        var offset = max_count;
        return function (d, i) {
            if (i == 0) {
                offset = max_count;
            }
            offset -= d;
            return offset;
        }
    })();

    var current_count = {};

    svg.selectAll('g').data(counts).enter().append('g')
        .attr({
            transform: function(d, i) { return 'translate(' + i * 2 + ',0)'; }
        })
        .selectAll('rect').data(function(d) {
            if (d.all) {
                current_count = d;
            }
            var _ = [];
            for (var i = 0; i <= 10; i++) {
                _.push(current_count[i]);
            }
            return _;
        }).enter().append('rect').attr({
            y: function(d, i) { return yScale(yOffset(d, i)); },
            width: 2,
            height: function(d) { return yScale(d) - margin; },
            stroke: function(d, i) { return color(i); }
        });
});

function mergeDoubles(counts, doubles) {
    var prepared = [];

    counts.forEach(function (el) {
        var id = el.id;

        prepared.push(el);

        while (doubles.length > 0) {
            var double = doubles[0];
            var count_id = double.count_id;

            if (count_id > id) { break; }
            if (count_id < id) { continue; }

            doubles.shift();
            prepared.push(double);
        }
    });

    return prepared;
}
