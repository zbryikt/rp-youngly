$(document).ready(function(){return d3.csv("ly.csv",function(n,e){function r(n,e){return t.indexOf(n.session)-t.indexOf(e.session)}var t,s,i,o,c,l,u,a,f,d,g,h,p,x,y,v,k,m,A,Y,b,O,w,j,q,z,B,C,D,E;for(t="一二三四五六七八九",s=[],i=[],o={},c={},l={},u={},a=0,f=e.length;f>a;++a)d=e[a],g=/第(.)屆 ?[(（](.+)[）)]/.exec(d["屆數"]),h=+g[2],p=d["參選年齡"],d["出生年次"]||(!d.guessYear||h-p<d.guessYear)&&(d.guessYear=h-p);for(a=0,f=e.length;f>a;++a)d=e[a],x=d["姓名"],null==u[x]&&(u[x]={count:0,list:[],src:d}),u[x].count++,g=/第(.)屆 ?[(（](.+)[）)]/.exec(d["屆數"]),y=t.indexOf(g[1]),h=+g[2],p=h-(+d["出生年次"]||d.guessYear),v=d["推薦政黨"],c[y]=1,l[p]=1,o[v]=1,u[x].list.push(k={session:y,age:p,party:v,src:u[x]}),i.push(k);for(m in u)for(A=u[m],A.list.sort(r),a=0,Y=A.list.length-1;Y>a;++a)d=a,s.push([A.list[d],A.list[d+1]]);b=[];for(m in c)b.push(+m);c=b,b=[];for(m in l)b.push(+m);l=b,b=[];for(m in o)b.push(m);return o=b,l.sort(),o.sort(),c.sort(),O=d3.select("#svg").selectAll("circle").data(i),O.enter().append("circle").on("click",function(n){return console.log(n)}),w=d3.select("#svg").selectAll("line").data(s),w.enter().append("line").on("click",function(n){return console.log(n)}),j=$("#svg").width(),q=$("#svg").height(),z=20,B=d3.scale.linear().domain([0,10]).range([z,j-z]),C=d3.scale.linear().domain([20,40]).range([q-z,z]),D=d3.scale.ordinal().domain(o).range(["#44f","#999","#dd0","#4f8","#bbb","#f90"]),(E=function(){return d3.selectAll("line").attr({x1:function(n){return B(n[0].session)},x2:function(n){return B(n[1].session)},y1:function(n){return C(n[0].age)},y2:function(n){return C(n[1].age)},stroke:function(n){return D(n[0].party)},"stroke-width":2}),d3.selectAll("circle").attr({cx:function(n){return B(n.session)},cy:function(n){return C(n.age)},r:5,fill:function(n){return D(n.party)}})})()})});