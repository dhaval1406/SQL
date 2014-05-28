/* Keyword		# of searches	# of LinCtg		# of Link	# of CodeFix by Keyword
				Count 'Hit' 
				+ "Not Found'			
*/

/* working fine with printing Producdt_Code, so need to add based on Producdt_Code to get correct Codefix total if we remove the product code. OTHERWISE, works just fine */
Select Distinct 
	s.Keyword
	#,s.SessionId
	#s.AccessDateTime,
	,s1.total_searches
	,s1.sum_LinkCtg
	,s1.sum_Link
	,c.CodeFix_count
	#,c.Product_Code

/*
INTO OUTFILE 'C:/Keyword_Anl1.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
*/	
From search s

# Removed Series code from Group By to get correct by sessionId, same thing in the botton Group By as well
# Similary removing the Session ID will add up everything in give Keyword based Analysis
# Example of Result - fep	429b8c6e35e835539dd232ef966fe811	21	0	4		
LEFT JOIN (
	SELECT DISTINCT SessionId, Keyword, Series_Code
			,(SUM(IF(Status = 'Hit',1,0)) + SUM(IF(Status = 'NotFound',1,0))) AS total_searches	
			, SUM(IF(Status = 'LinkCtg',1,0)) AS sum_LinkCtg
			, SUM(IF(Status = 'Link',1,0)) AS sum_Link
			, Status
	FROM search 
	GROUP BY Keyword#, Series_Code, SessionId
	
) AS s1 ON s1.SessionId = s.SessionId AND s1.Keyword = s.Keyword AND s1.Series_Code = s.Series_Code 

LEFT JOIN(
	SELECT DISTINCT AccessDateTime, SessionId, Series_Code, Referer_URL, Product_Code
			, COUNT(Product_Code) AS CodeFix_count
	FROM code_fix
	GROUP BY SessionId, Series_Code, Referer_URL
) As c On s.SessionId = c.SessionId and (s.Series_Code = c.Series_Code or s.URL = c.Referer_URL) /* can also include or s.Link_URL = c.Referer_URL, to capture more relavant product codes */
																								 /* and commenting c.Product_Code from group by */			
																								 /* but it will add extra complexity on calclulation */ 

#WHERE s.Keyword = 'lbnr3'  #and s.SessionId in ('d3989cf8ef244653efac851f9b9cdb9e') 
GROUP BY s.Keyword, c.Product_Code#, s.SessionId#, s.Series_Code 
ORDER BY total_searches DESC, s.keyword DESC
;



/* with SessionID and Series ID, this looks more promissing */
/* Sampel output : 	
	fep	d3989cf8ef244653efac851f9b9cdb9e	10	0	0				10
	fep	429b8c6e35e835539dd232ef966fe811	6	0	0				6
	fep	ce24d624af0d234b1823e273bf354cbb	3	0	0				3
	fep	b285df77f2f3ce58de9070c9b10f0e09	2	0	0				2
	fep	ce24d624af0d234b1823e273bf354cbb	0	0	1		110300588640		1
	fep	d3989cf8ef244653efac851f9b9cdb9e	0	0	1		110300588820		1
	fep	d3989cf8ef244653efac851f9b9cdb9e	0	0	1		110300588640		1
	fep	d3989cf8ef244653efac851f9b9cdb9e	0	0	1		110300588910		1   */
Select Distinct 
	s.Keyword
	,s.SessionId
	#s.AccessDateTime,
	,s1.total_searches
	,s1.sum_LinkCtg
	,s1.sum_Link
	,c.CodeFix_count
	,s.Series_Code
	,c.Product_Code
	,count(s1.total_searches) as super_total

/*
INTO OUTFILE 'C:/Keyword_Anl1.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
*/	
From search s

LEFT JOIN (
	SELECT DISTINCT SessionId, Keyword, Series_Code
			,(SUM(IF(Status = 'Hit',1,0)) + SUM(IF(Status = 'NotFound',1,0))) AS total_searches	
			, SUM(IF(Status = 'LinkCtg',1,0)) AS sum_LinkCtg
			, SUM(IF(Status = 'Link',1,0)) AS sum_Link
			, Status
	FROM search 
	GROUP BY SessionId, Keyword, Series_Code
	
) AS s1 ON s1.SessionId = s.SessionId AND s1.Keyword = s.Keyword AND s1.Series_Code = s.Series_Code 

LEFT JOIN(
	SELECT DISTINCT AccessDateTime, SessionId, Series_Code, Referer_URL, Product_Code
			, COUNT(Product_Code) AS CodeFix_count
	FROM code_fix
	GROUP BY SessionId, Series_Code, Referer_URL
) As c On s.SessionId = c.SessionId and (s.Series_Code = c.Series_Code or s.URL = c.Referer_URL)

#where #Status = 'Hit' and 
WHERE s.Keyword = 'fep'  #and s.SessionId in ('d3989cf8ef244653efac851f9b9cdb9e') 
GROUP BY s.Keyword, s.Series_Code, c.Product_Code, s.SessionId 
ORDER BY total_searches DESC, s.keyword DESC
#ORDER BY s.Keyword DESC
;



/* with Session Id */

Select Distinct 
	s.Keyword
	,s.SessionId
	#s.AccessDateTime,
	,s1.total_searches
	,s1.sum_LinkCtg
	,s1.sum_Link
	,c.CodeFix_count
	,s.Series_Code
	,c.Product_Code
	,count(s1.total_searches) as super_total

/*
INTO OUTFILE 'C:/Keyword_Anl1.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
*/	
From search s

LEFT JOIN (
	SELECT DISTINCT SessionId, Keyword, Series_Code
			,(SUM(IF(Status = 'Hit',1,0)) + SUM(IF(Status = 'NotFound',1,0))) AS total_searches	
			, SUM(IF(Status = 'LinkCtg',1,0)) AS sum_LinkCtg
			, SUM(IF(Status = 'Link',1,0)) AS sum_Link
			, Status
	FROM search 
	GROUP BY SessionId, Keyword, Series_Code
	
) AS s1 ON s1.SessionId = s.SessionId AND s1.Keyword = s.Keyword AND s1.Series_Code = s.Series_Code 

LEFT JOIN(
	SELECT DISTINCT AccessDateTime, SessionId, Series_Code, Referer_URL, Product_Code
			, COUNT(Product_Code) AS CodeFix_count
	FROM code_fix
	GROUP BY SessionId, Series_Code, Referer_URL
) As c On s.SessionId = c.SessionId and (s.Series_Code = c.Series_Code or s.URL = c.Referer_URL)

#where #Status = 'Hit' and 
WHERE s.Keyword = 'fep'  #and s.SessionId in ('d3989cf8ef244653efac851f9b9cdb9e') 
GROUP BY s.Keyword, s.Series_Code, c.Product_Code, s.SessionId 
ORDER BY total_searches DESC, s.keyword DESC
#ORDER BY s.Keyword DESC
;



/* Older version of the analysis - does not combine the product codes and keyword 
	Use above version as it groups correctly and provides correct counts */ 

Select Distinct s.Keyword, 
	#s.SessionId, 
	#s.AccessDateTime,
	#Count(s.Status) As status_count,
	(SUM(IF(s.Status = 'Hit',1,0)) + SUM(IF(s.Status = 'NotFound',1,0))) AS total_searches,
	SUM(IF(s.Status = 'LinkCtg',1,0)) AS sum_LinkCtg,
	SUM(IF(s.Status = 'Link',1,0)) AS sum_Link, 
	c.Product_Code
	#s.Series_Code,
	#SUM(IF(s.Status = 'Hit',1,0)) AS sum_hit,
	#SUM(IF(s.Status = 'NotFound',1,0)) AS sum_notfound,
	#s.Status
/*
INTO OUTFILE 'C:/Keyword_Anl1.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
*/	
From search s

Inner Join(
		select distinct SessionId, Series_Code, Referer_URL, Product_Code 
		from code_fix
) As c On s.SessionId = c.SessionId and (s.Series_Code = c.Series_Code or s.URL = c.Referer_URL)

#where #Status = 'Hit' and 
#where	  s.SessionId in ('6fade5b3ab747f47c21f2723eae8feff') and s.Keyword = 'lbnr3'
WHERE s.SessionId in ('429b8c6e35e835539dd232ef966fe811', 'd3989cf8ef244653efac851f9b9cdb9e', 'ce24d624af0d234b1823e273bf354cbb') and s.Keyword = 'fep'
GROUP BY s.Keyword, c.Product_Code, s.Series_Code
ORDER BY total_searches DESC, s.keyword DESC
#ORDER BY s.Keyword DESC
;



/* It works fine just on the search table 
   Checking Syntex for sum and count without join */

select s.Keyword, s.Search_Type, s.Status,
	count(s.Status),
	SUM(IF(s.Status = 'Link',1,0)) AS sum_Link,
	SUM(IF(s.Status = 'LinkCtg',1,0)) AS sum_LinkCtg,
	SUM(IF(s.Status = 'Hit',1,0)) AS sum_hit,
	SUM(IF(s.Status = 'NotFound',1,0)) AS sum_notfound,
	(SUM(IF(s.Status = 'Hit',1,0)) + SUM(IF(s.Status = 'NotFound',1,0))) AS total_searches
	
from search s
where #Status = 'Hit' and 
	  s.SessionId in ('294cb728079c7fe5f68f11736096eee6') and s.Keyword = 'MCJSN18-8-5'
Group by s.Keyword  
ORDER BY total_searches DESC
;


