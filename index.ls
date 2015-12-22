<- $ document .ready


(e,d) <- d3.csv \ly.csv, _

sessionhash = {}
agehash = {}
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

for line in lines =>
  if !(sessionhash[line.0.session]?) => sessionhash[line.0.session] = {count: 0, session: line.0.session}
  sessionhash[line.0.session].count++
  for i from line.0.age + 1 til line.1.age =>
    if !(agehash[i]?) => agehash[i] = {count: 0, age: i}
    agehash[i].count++
for p in points =>
  i = p.age
  if !(agehash[i]?) => agehash[i] = {count: 0, age: i}
  agehash[i].count++

sessions = [+k for k of sessions]
ages = [+k for k of ages]
parties = [k for k of parties]
ages.sort!
parties.sort!
sessions.sort!

agelist = [v for k,v of agehash]
d3.select \#svg .selectAll \rect.age .data agelist
  ..enter!append \rect .attr class: \age

sessionlist = [v for k,v of sessionhash]
d3.select \#svg .selectAll \rect.session .data sessionlist
  ..enter!append \rect .attr class: \session

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
  d3.selectAll \line 
    .transition!
    .duration 1000
    .attr do
      x1: -> 
        if state == 0 => x-scale(1) - 10 + it.0.session * 10
        else x-scale it.0.session
      x2: -> 
        if state == 0 => x-scale(1) - 10 + it.0.session * 10
        else x-scale it.1.session
      y1: -> 
        if state == 2 => y-scale(22) - it.0.age
        else y-scale(it.0.age)
      y2: -> 
        if state == 2 => y-scale(22)  - it.0.age
        else y-scale(it.1.age)
      stroke: -> color it.0.party 
      "stroke-width": ->
        if state != 1 => 10
        else 2
      opacity: ->
        if state != 1 => 0
        else 1

  d3.selectAll \circle 
    .transition!
    .duration 1000
    .attr do
      cx: -> 
        if state == 0 => x-scale 1
        else x-scale it.session
      cy: -> 
        if state == 2 => y-scale 22
        else y-scale it.age
      r: 5
      fill: -> color it.party
      opacity: ->
        if state != 1 => 0
        else 1

  d3.selectAll \rect.age 
    .transition!
    .duration 1000
    .attr do
      x: -> x-scale(1) - 10
      y: -> y-scale(it.age) - (y-scale(it.age) - y-scale(it.age + 1))/2
      width: -> 
        if state == 0 => it.count * 4
        else 0
      height: -> y-scale(it.age) - y-scale(it.age + 1)
      fill: \#999
      opacity: ->
        if state == 0 => 1
        else 0

  d3.selectAll \rect.session 
    .transition!
    .duration 1000
    .attr do
      x: -> x-scale(it.session)
      y: -> 
        if state == 2 => y-scale(22) - it.count * 10
        else y-scale(22)
      width: -> 
        x-scale(it.session + 1) - x-scale(it.session)
      height: -> 
        if state == 2 => it.count * 10
        else 0
      fill: \#999
      opacity: -> 
        if state == 2 => 1
        else 0

state = 0
update!

dstate = 1
window.toggle = ->
  state := state + dstate
  if state >= 2 => dstate := -1
  if state <= 0 => dstate := 1
  update!
