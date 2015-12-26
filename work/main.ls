require! <[fs]>

cmap = "零一二三四五六七八九十"
lines = fs.read-file-sync \ly-all.csv .toString!split(\\n).filter(->it).map(-> it.split \,)
lines.splice(0,1)


lys = lines.map ->
  ret = /第(.)屆\((\d+)\)/.exec it.0
  session = cmap.indexOf(ret.1)
  year = +ret.2
  [_, region, name, num, gender, birth, age, party, _, _, win] = it
  win = if win == \* => true else false

  {session, year, name, num, gender, birth, age, party, win}

lys = lys.filter -> it.win
sessions = {}
all-session = {}
for ly in lys => 
  all-session[ly.session] = 1
  sessions[][ly.session].push ly

session-age = {}
session-age-again = {}
for i from 2 til 9 =>
  session = session-age{}[i]
  session-again = session-age-again{}[i]
  for ly in sessions[i] =>
    if !ly.birth => ly.birth = ly.year - ly.age
    group = parseInt((ly.year - ly.birth)/5) * 5
    group = "#group ~ #{group + 4}"
    session[][group].push ly
    if sessions[][i + 1].filter(->it.name == ly.name).length =>
      session-again[][group].push ly

for i from 2 til 10 =>
  session = session-age{}[i]
  session-again = session-age-again{}[i]
  for k,v of session => session[k] = v.length
  for k,v of session-again => session-again[k] = v.length

fs.write-file-sync \ly.json, JSON.stringify lys
#console.log session-age
#console.log session-age-again

if "totable" and false =>
  console.log "age,2,3,4,5,6,7,8"
  for a from 25 til 80 by 5
    a = "#a ~ #{a + 4}"
    line = [a]
    for s in <[2 3 4 5 6 7 8]>
      #line.push(session-age-again[s][a] or 0)
      line.push(session-age[s][a] or 0)
    console.log line.join(",")

if "topair" and false =>
  console.log "age,session,count"
  for a from 25 til 80 by 5
    a = "#a ~ #{a + 4}"
    for s in <[2 3 4 5 6 7 8]>
      console.log "#a,#s,#{( session-age[s][a] or 0)}"
      #console.log "#a,#s,#{( session-age-again[s][a] or 0)}"

if "again-most" and true =>
  names = {}
  for ly in lys =>
    if !(names[ly.name]?) => names[ly.name] = {list: [0 for i from 2 til 10], count: 0}
    names[ly.name].list[ly.session] = 1
  for n of names =>
    for i from 2 til 10 => 
      if names[n].list[i] => names[n].count++
      else count = 0
      if count > names[n].count => names[n].count = count
  #console.log names

againer = [k for k of names].sort((a,b) -> names[a].count - names[b].count)
againer.map ->
  console.log it, names[it].count
