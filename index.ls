<- $ document .ready


(e,d) <- d3.csv \ly.csv, _

session-map = "一二三四五六七八九"
lines = []
points = []
parties = {}
sessions = {}
ages = {}
name = {}
for i in d =>
  ret = /第(.)屆 ?[(（](.+)[）)]/.exec(i[\屆數])
  year = +ret.2
  age = i[\參選年齡]
  if !i[\出生年次] => 
    if !i.guess-year or year - age < i.guess-year => i.guess-year = year - age

for i in d => 
  n = i[\姓名]
  if !(name[n]?) => name[n] = {count: 0, list: [], src: i}
  name[n].count++
  ret = /第(.)屆 ?[(（](.+)[）)]/.exec(i[\屆數])
  session = session-map.indexOf(ret.1)
  year = +ret.2
  age = year - ( +i[\出生年次] or i.guess-year )
  party = i[\推薦政黨]
  sessions[session] = 1
  ages[age] = 1
  parties[party] = 1
  name[n].list.push p = {session, age, party, src: name[n]}
  points.push p
for k,v of name =>
  v.list.sort ((b,a) -> session-map.indexOf(b.session) - session-map.indexOf(a.session))
  for i from 0 til v.list.length - 1 =>
    lines.push [v.list[i], v.list[i + 1]]

sessions = [+k for k of sessions]
ages = [+k for k of ages]
parties = [k for k of parties]
ages.sort!
parties.sort!
sessions.sort!

d3.select \#svg .selectAll \circle .data points
  ..enter!append \circle
    .on \click -> console.log it

d3.select \#svg .selectAll \line .data lines
  ..enter!append \line
    .on \click -> console.log it
w = $(\#svg).width!
h = $(\#svg).height!
m = 20
x-scale = d3.scale.linear!domain [0 10] .range [m, w - m]
y-scale = d3.scale.linear!domain [20,40] .range [h - m, m]
color = d3.scale.ordinal!domain parties .range <[#44f #999 #dd0 #4f8 #bbb #f90]>

update = ->
  d3.selectAll \line .attr do
    x1: -> x-scale it.0.session
    x2: -> x-scale it.1.session
    y1: -> y-scale it.0.age
    y2: -> y-scale it.1.age
    stroke: -> color it.0.party 
    "stroke-width": 2
  
  d3.selectAll \circle .attr do
    cx: -> x-scale it.session
    cy: -> y-scale it.age
    r: 5
    fill: -> color it.party

update!
