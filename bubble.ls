(e,data) <- d3.csv \ages-list.csv, _

[w,h,m] = [800,600,40]

svg = d3.select \#svg

[ages, sessions] = <[age session]>.map((k) -> d3.map(data,->it[k]).keys!)
counts = data.map -> +it.count or 0
console.log d3.extent(counts)
x-scale = d3.scale.ordinal!domain sessions .rangePoints [m, w - m]
y-scale = d3.scale.ordinal!domain ages .rangePoints [h - m - 20, m + 20]
size-scale = d3.scale.linear!domain d3.extent(counts) .range [0,40]

x-axis = d3.svg.axis!scale x-scale .tickSize [1]
y-axis = d3.svg.axis!scale y-scale .orient \left .tickSize [1]

svg.append \g
  ..call x-axis
  ..attr do
    class: \x-axis
    transform: "translate(0,#{h - m})"

svg.append \g
  ..call y-axis
  ..attr do
    class: \y-axis
    transform: "translate(0,0)"

svg.selectAll \circle.point .data data
  ..enter!
    ..append \circle .attr class: \point

update = ->
  svg.selectAll \circle.point
    .attr do
      cx: -> x-scale it.session
      cy: -> y-scale it.age
      r: -> size-scale it.count
      fill: -> \#000
      stroke: \#fff
      "stroke-width": \3

update!
