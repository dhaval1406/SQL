select count(*) from search;

/* Super Useful stuff for Analysis 2 */
SELECT DISTINCT s.AccessDateTime,  s.SessionId, Keyword, s.Series_Code, c.Product_Code
			,(SUM(IF(Status = 'Hit',1,0)) + SUM(IF(Status = 'NotFound',1,0))) AS total_searches	
			, SUM(IF(Status = 'LinkCtg',1,0)) AS sum_LinkCtg
			, SUM(IF(Status = 'Link',1,0)) AS sum_Link
			, Status
	FROM search s 
LEFT JOIN(

	SELECT DISTINCT AccessDateTime, SessionId, Series_Code, Referer_URL, Product_Code
			, COUNT(Product_Code) AS CodeFix_count
	FROM code_fix
	#WHERE SessionId in ('d3989cf8ef244653efac851f9b9cdb9e')#('429b8c6e35e835539dd232ef966fe811', 'd3989cf8ef244653efac851f9b9cdb9e', 'ce24d624af0d234b1823e273bf354cbb') 
	GROUP BY SessionId, Series_Code, Referer_URL

) As c On s.SessionId = c.SessionId and (s.Series_Code = c.Series_Code or s.URL = c.Referer_URL)

	WHERE #s.SessionId in ('d3989cf8ef244653efac851f9b9cdb9e') and 
	Keyword = 'fep'
	GROUP BY s.Keyword #, s.SessionId
;

SELECT DISTINCT Keyword, Series_Code
			,(SUM(IF(Status = 'Hit',1,0)) + SUM(IF(Status = 'NotFound',1,0))) AS total_searches	
			, SUM(IF(Status = 'LinkCtg',1,0)) AS sum_LinkCtg
			, SUM(IF(Status = 'Link',1,0)) AS sum_Link
			, Status
	FROM search 
	where Keyword = 'fep'
	GROUP BY Keyword, Series_Code;

/* Super useful ends here */

SELECT 	s.Keyword 
		#,d.Tab_name_count
		, d.Series_Code
		,s1.total_searches
		,d.Link_count
		#,count(d.Tab_name_count)
		,c.CodeFix_count
		#,c.Product_Code
		,d.Tab_Name

FROM search AS s 

LEFT JOIN (
	SELECT DISTINCT	SessionId, Keyword
			,(SUM(IF(Status = 'Hit',1,0)) + SUM(IF(Status = 'NotFound',1,0))) AS total_searches	
			, Status
	FROM search 
	GROUP BY SessionId, Keyword, Status
	
) AS s1 ON s1.Keyword = s.Keyword

LEFT JOIN (

	SELECT 	SessionId, Page_URL
			,Tab_Name
			, Series_Code
		   ,COUNT(DISTINCT Tab_Name) AS Tab_name_count
		   ,COUNT(*) AS Link_count 
	FROM detail_tab
	GROUP BY SessionId, Series_Code, Tab_Name

) AS d ON s.SessionId = d.SessionId AND s.Series_Code = d.Series_Code 


LEFT JOIN(
	SELECT DISTINCT AccessDateTime, SessionId, Series_Code, Referer_URL, Product_Code
			, COUNT(Product_Code) AS CodeFix_count
	FROM code_fix
	GROUP BY SessionId, Series_Code #, Product_Code
) AS c ON s.SessionId = c.SessionId AND (s.Series_Code = c.Series_Code)


WHERE d.Tab_Name = '4' 
	  and s.SessionId = 'cc849a928f720eda3115bf33aed908c1' 	
	  #and s.Keyword = 'stop blocks'

GROUP BY s.Keyword, d.Series_Code, c.Product_Code
ORDER BY s.Keyword ASC, s1.total_searches DESC
; 



# code fix count 
SELECT DISTINCT AccessDateTime, SessionId, Series_Code, Referer_URL, Product_Code
	, COUNT(Product_Code) AS CodeFix_count
			
	FROM code_fix

WHERE # Limiting results to Link only for now 
	  SessionId = 'cc849a928f720eda3115bf33aed908c1' 	
	  AND Series_Code = 110300593810

	GROUP BY SessionId, Series_Code, Product_Code;




# sum hit thingy 
SELECT 	SessionId, Keyword
			#,(SUM(IF(Status = 'Hit',1,0)) + SUM(IF(Status = 'NotFound',1,0))) AS total_searches	
			, Status
			, SUM( IF(Status = 'Hit',1,0)) AS status_count
			, SUM(IF(s.Status = 'NotFound',1,0)) AS sum_notfound
	FROM search s

#Where # Limiting results to Link only for now 
#	  s.SessionId = 'cc849a928f720eda3115bf33aed908c1' 	
#	  and s.Keyword = 'stop blocks'

	GROUP BY SessionId, s.Keyword, Status;




	SELECT SessionId, Page_URL, Tab_Name, Series_Code, 
		   COUNT(DISTINCT Tab_Name) AS Tab_name_count,
		   COUNT(*) AS Link_count 
				FROM detail_tab d
WHERE d.Tab_Name = '4' AND 
	  # Limiting results to Link only for now 
	  d.SessionId = 'cc849a928f720eda3115bf33aed908c1' 	

	GROUP BY SessionId, Series_Code, Tab_Name;





SELECT
  t.Topic,
  t.Title,
  s.StarCount,
  m.UserCount,
  m.MessageCount
FROM
  Topics t
  LEFT JOIN (
    SELECT 
      Topic, 
      COUNT(DISTINCT User) AS UserCount,
      COUNT(*) AS MessageCount
    FROM Messages
    GROUP BY Topic
  ) m ON m.Topic = t.Topic
  LEFT JOIN (
    SELECT
      Topic, 
      COUNT(*) AS StarCount
    FROM Stars_Given 
    GROUP BY Topic
  ) s ON s.Topic = t.Topic;



SELECT SessionId, Page_URL, Tab_Name, Series_Code, COUNT(DISTINCT Tab_Name) AS Tab_name_count
				FROM detail_tab
				WHERE Tab_Name = '4' AND SessionId = 'cc849a928f720eda3115bf33aed908c1' 	

	GROUP BY SessionId, Tab_Name;

