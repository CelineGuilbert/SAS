proc http
 url= 'http://api.open-notify.org/iss-pass.json?lat=50.6329700&lon=3.0585800'
 method="GET"
 out=issdata;
run; 
libname posts JSON fileref=issdata; 

proc sql;
	create table ISS_POSITION as
	select 
		b.message as success,
		c.altitude,
		c.longitude,
		c.latitude,
		c.passes as NumberOfPassages,
		c.datetime,
		a.*
	from POSTS.RESPONSE as a
	left outer join POSTS.ROOT as b
	on a.ordinal_root=b.ordinal_root
	left outer join POSTS.REQUEST as c
	on a.ordinal_root=c.ordinal_root
	;
Quit;

/* Final Result :*/
data ISS_POSITION;
set ISS_POSITION;
format ResponseDate PassageDate ddmmyy10.;
ResponseDate = datepart(dhms('01jan1970'd, 0, 0, datetime));
PassageDate = datepart(dhms('01jan1970'd, 0, 0, risetime));
run; 
