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

data = []
for i from 1 til table.length =>
  for j from 1 til table.0.length =>
    data.push {age: table[i].0, session: table.0[j], count: +table[i][j]}

[w,h,m] = [800,600,40]

svg = d3.select \#svg

[ages, sessions] = <[age session]>.map((k) -> d3.map(data,->it[k]).keys!)
counts = data.map -> +it.count or 0
console.log d3.extent(counts)
x-scale = d3.scale.ordinal!domain sessions .rangeBands [m, w - m]
y-scale = d3.scale.ordinal!domain ages .rangeBands [h - m - 20, m + 20]
size-scale = d3.scale.linear!domain d3.extent(counts) .range [0,40]
opacity-scale= d3.scale.linear!domain <[-1 0 1]> .range [1 0 1]

x-axis = d3.svg.axis!scale x-scale .tickSize [1]
y-axis = d3.svg.axis!scale y-scale .orient \left .tickSize [1]
x-band = x-scale.rangeBand!
y-band = y-scale.rangeBand!

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

svg.selectAll \rect.point .data data
  ..enter!
    ..append \rect .attr class: \point

update = ->
  svg.selectAll \rect.point
    .attr do
      x: -> x-scale it.session
      y: -> y-scale it.age
      width: x-band
      height: y-band
      #r: -> size-scale it.count
      #fill: -> \#000
      fill: -> if it.count < 0 => \#f42 else \#2f4
      opacity: -> opacity-scale it.count
      stroke: \#fff
      "stroke-width": \3

update!
