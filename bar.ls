#(e,data) <- d3.csv \ages-list.csv, _
<- $ document .ready

table = [
  <[連任比例 第二屆  第三屆  第四屆  第五屆  第六屆  第七屆]>
  <[25~29 -0.55   -0.55   -0.05   0.45    0.45    0.45]>
  <[30~34 -0.35   0.20    0.28    0.01    -0.33   0.20]>
  <[35~39 0.30    0.05    0.14    -0.18   -0.21   -0.12]>
  <[40~44 -0.06   0.05    0.03    0.17    -0.25   0.06]>
  <[45~49 0.02    0.08    -0.09   0.14    -0.15   -0.03]>
  <[50~54 0.11    -0.05   -0.07   0.06    -0.17   0.11]>
  <[55~59 0.02    0.02    -0.10   0.09    -0.18   0.15]>
  <[60~64 0.19    0.00    -0.33   -0.30   -0.22   -0.30]>
  <[65~69 0.00    0.00    0.00    -0.25   0.00    0.00]>
]

[w,h,m] = [450,600,40]

data = []
for i from 1 til table.length =>
  for j from 1 til table.0.length =>
    data.push {age: table[i].0, session: table.0[j], y1: +table[i][j]}
    #data.push {age: table[i].0, session: table.0[j], y1: +table[i][j], y2: +table[i][j + 1]}
counts = data.map -> +it.count or 0

[ages, sessions] = <[age session]>.map((k) -> d3.map(data,->it[k]).keys!)

x-scale = d3.scale.ordinal!domain sessions .rangeBands [m, w - m]
y-scale = d3.scale.ordinal!domain ages .rangeBands [h - m - 20, m + 20]

x-axis = d3.svg.axis!scale x-scale .tickSize [1]
y-axis = d3.svg.axis!scale y-scale .orient \left .tickSize [1]
x-band = x-scale.rangeBand!
y-band = y-scale.rangeBand!

yl-scale = d3.scale.linear!domain [1, -1] .range [0, y-band]
yb-scale = d3.scale.linear!domain [1, 0, -1] .range [y-band * 0.7, 0, y-band * 0.7]
size-scale = d3.scale.linear!domain d3.extent(counts) .range [0,40]
opacity-scale= d3.scale.linear!domain <[-1 0 1]> .range [1 0 1]

svg = d3.select \#svg

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

/*
svg.selectAll \line.line .data data
  ..enter!
    ..append \line .attr class: \line
*/

svg.selectAll \rect.rect .data data
  ..enter!
    ..append \rect .attr class: \rect
svg.selectAll \line.align .data ages
  ..enter!
    ..append \line .attr class: \align

update = ->
  svg.selectAll \line.align
    .attr do
      x1: -> m
      y1: -> y-scale(it) + y-band/2
      x2: -> w - m
      y2: -> y-scale(it) + y-band/2
      stroke: \#999
      "stroke-width": \1
      "stroke-dasharray": "2 4"
  svg.selectAll \rect.rect
    .attr do
      x: -> x-scale(it.session) + x-band * 0.2
      y: -> 
        if it.y1 > 0 => y-band/2 + y-scale(it.age) - yb-scale(it.y1) else y-scale(it.age) + y-band/2
      width: x-band * 0.6
      height: -> yb-scale(it.y1)
      fill: -> if it.y1 < 0 => \#f42 else \#2f4
      stroke: \#444
  /*
  svg.selectAll \line.line
    .attr do
      x1: -> x-scale it.session
      y1: -> yl-scale(it.y1) + y-scale(it.age)
      x2: -> x-scale(it.session) + x-band
      y2: -> yl-scale(it.y2) + y-scale(it.age)
      #width: x-band
      #height: y-band
      #r: -> size-scale it.count
      #fill: -> \#000
      fill: -> if it.count < 0 => \#f42 else \#2f4
      opacity: -> 1 #opacity-scale it.count
      stroke: -> if ( it.y1 + it.y2 ) / 2 < 0 => \#b22 else \#2b2
      "stroke-width": \2
  */

update!
