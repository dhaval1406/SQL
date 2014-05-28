/*
Keyword	"# of searches
* Count 'Hit' + ""Not Found'"	Series Code	# of Link by Series Code	# of CodeFix by Series Code	# of unique tab clicks for "4"
*/

SELECT 	s.Keyword 
		#,d.Tab_name_count
		, d.Series_Code
		,s1.total_searches
		,d.Link_count
		#,count(d.Tab_name_count)
		,c.CodeFix_count
		#,c.Product_Code
		#,d.Tab_Name

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
			,Tab_Name, Series_Code
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
	  #and s.SessionId = 'cc849a928f720eda3115bf33aed908c1' 	
	  #and s.Keyword = 'stop blocks'

GROUP BY s.Keyword, d.Series_Code, c.Product_Code
; 