#(e,data) <- d3.csv \ages-list.csv, _
<- $ document .ready

ppl = [
  <[連任人數     第二屆  第三屆  第四屆  第五屆  第六屆  第七屆]>
  <[25~29 0       0       1       2       1       1]>
  <[30~34 1       3       5       5       2       3]>
  <[35~39 23      14      16      7       7       2]>
  <[40~44 14      18      22      28      6       4]>
  <[45~49 11      19      17      32      20      6]>
  <[50~54 14      11      16      19      13      14]>
  <[55~59 7       7       8       8       8       10]>
  <[60~64 0       0       3       3       2       3]>
  <[65~69 0       0       0       1       0       0]>
]

table = [
  <[連任比例   第二屆  第三屆  第四屆  第五屆  第六屆  第七屆]>
  <[25~29       0.00    0.00    0.50    1.00    1.00    1.00]>
  <[30~34       0.20    0.75    0.83    0.56    0.22    0.75]>
  <[35~39       0.92    0.67    0.76    0.44    0.41    0.50]>
  <[40~44       0.45    0.56    0.54    0.68    0.26    0.57]>
  <[45~49       0.55    0.61    0.44    0.67    0.38    0.50]>
  <[50~54       0.64    0.48    0.46    0.59    0.36    0.64]>
  <[55~59       0.50    0.50    0.38    0.57    0.30    0.63]>
  <[60~64       0.00    0.00    0.33    0.30    0.22    0.30]>
  <[65~69       0.00    0.00    0.00    0.25    0.00    0.00]>
]

data = []
for i from 1 til table.length =>
  for j from 1 til table.0.length =>
    data.push {age: table[i].0, session: table.0[j], count: +table[i][j], ppl: +ppl[i][j]}

[w,h,mw,mh] = [600,600,75,45]

svg = d3.select \#svg

[ages, sessions] = <[age session]>.map((k) -> d3.map(data,->it[k]).keys!)
sessions-axis = sessions ++ <[第八屆]>
counts = data.map -> +it.count or 0
console.log d3.extent(counts)
xc-scale = d3.scale.ordinal!domain sessions .rangeBands [mw, w - 2 * mw]
xx-scale = d3.scale.ordinal!domain sessions-axis .rangePoints [mw, w - 2 * mw]
y-scale = d3.scale.ordinal!domain ages .rangeBands [h - mh, mh]
yl-scale = d3.scale.linear!domain d3.extent(counts) .range [mh + 25, 100 + mh + 25]
size-scale = d3.scale.linear!domain d3.extent(counts) .range [0,40]
#opacity-scale= d3.scale.linear!domain [d3.min(counts),0,d3.max(counts)] .range [1 0 1]
opacity-scale= d3.scale.linear!domain [0,1] .range [0,1]

x-axis = d3.svg.axis!scale xx-scale .tickSize [1] .tickPadding 10
y-axis = d3.svg.axis!scale y-scale .orient \left .tickSize [0] .tickPadding 10
x-band = xc-scale.rangeBand!
y-band = y-scale.rangeBand!


svg.selectAll \rect.point .data data
  ..enter!
    ..append \rect .attr class: \point

svg.append \g
  ..call y-axis
  ..attr do
    class: \y-axis
    transform: "translate(#mw,0)"

svg.append \g
  ..call x-axis
  ..attr do
    class: \x-axis
    transform: "translate(0,#{h - mh})"

svg.selectAll \line.align .data sessions-axis
  ..enter!
    ..append \line .attr class: \align

svg.selectAll \circle.align .data sessions-axis
  ..enter!
    ..append \circle .attr class: \align

svg.append \line .attr class: \top

svg.selectAll \rect.legend .data opacity-scale.ticks(5)
  ..enter!
    ..append \rect .attr class: \legend
svg.selectAll \text.legend .data opacity-scale.ticks(5)
  ..enter!
    ..append \text .attr class: \legend
svg.append \text .attr class: \legend-title
svg.append \line .attr class: \sep
update = ->

  svg.select \g#popup .attr do
    transform: "translate(#{w - mw + 5},#{mh + 170})"
  cmap = "零一二三四五六七八九"
  svg.selectAll \rect.point
    .attr do
      x: -> 1 + xc-scale it.session
      y: -> 1 + y-scale it.age
      width: x-band - 2
      height: y-band - 2
      fill: -> "rgba(247,20,103,#{opacity-scale it.count})"
      stroke: \#fff
      "stroke-width": \1
    .on \mouseover, (d) -> 
      idx = table.0.indexOf(d.session) + 1
      d3.select @ .attr stroke: \#4a4a4a
      d3.select 'g#popup text.session' .text ->
        "第#{cmap.charAt(idx)}至#{cmap.charAt(idx + 1)}屆"
      d3.select 'g#popup text.age' .text "#{d.age}歲"
      d3.select 'g#popup text.count' .text "#{if d.count >0 => '+' else ''}#{parseInt(100*d.count)}%"
      d3.select 'g#popup text.ppl' .text "共#{d.ppl}人 (第#{cmap.charAt(idx)}屆)"
    .on \mouseout, -> 
      d3.select @ .attr stroke: \#fff
  svg.selectAll \line.align
    .attr do
      x1: -> xx-scale it
      x2: -> xx-scale it
      y1: -> mh
      y2: -> h - mh
      stroke: \#444
      "stroke-width": 1
  svg.selectAll \circle.align
    .attr do
      cx: -> xx-scale it
      cy: -> h - mh
      r: 3
      fill: \#fff
      stroke: \#444
      "stroke-width": 1
  svg.select \line.top
    .attr do
      x1: -> mw
      x2: -> w - mw * 2
      y1: mh
      y2: mh
      stroke: \#444
  svg.selectAll \rect.legend
    .attr do
      x: -> w - mw * 1.5
      y: -> yl-scale it 
      width: -> mw / 2
      height: 10
      fill: -> "rgba(247,20,103,#{opacity-scale it})"
      stroke: \#444
      "stroke-width": 1
  svg.selectAll \text.legend
    .attr do
      x: -> w - mw + 45
      y: -> yl-scale it
      dy: 10
      "text-anchor": "end"
    .text -> if it <= 0 => "#{it*100}%" else "+#{it*100}%"
  svg.select \text.legend-title
    .attr do
      x: -> w - mw - 35
      y: -> mh
      "dominant-baseline": \hanging
    .text \連任人數變化

  svg.select \line.sep .attr do
    x1: w - mw * 1.5
    x2: w - mw + 45
    y1: mh + 150
    y2: mh + 150
    stroke: \#444

update!
