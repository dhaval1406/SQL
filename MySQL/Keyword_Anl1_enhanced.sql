/* Keyword		# of searches	# of LinCtg		# of Link	# of CodeFix by Keyword
				Count 'Hit' 
				+ "Not Found'			
*/
  
SELECT *, COUNT(t.Max_CodeFix_Count) AS Total_CodeFix_Count

FROM

(SELECT  
	s.AccessDateTime
	#,s.SessionId
	,s.Keyword
	,s1.total_searches
	,s1.sum_LinkCtg
	,s1.sum_Link
	#,c.Unique_CodeFix
	#,IFNULL(max(c.Unique_CodeFix), 0) AS Max_CodeFix_Count
	,MAX(c.Unique_CodeFix) AS Max_CodeFix_Count
	#,c.Product_Code
	#,s.Status
	#,sum(if(s.Status = 'NotFound', 0, Unique_CodeFix)) as Super_total
	#,s.URL

FROM search s

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
			, COUNT(DISTINCT Product_Code) AS Unique_CodeFix
	FROM code_fix
	GROUP BY SessionId, Series_Code, Referer_URL, Product_Code
) AS c ON s.SessionId = c.SessionId AND s.URL = c.Referer_URL AND s.Status IN ('Link', 'LinkCtg')/* can also include or s.Link_URL = c.Referer_URL, to capture more relavant product codes */
																								 /* and commenting c.Product_Code from group by */			
																								 /* but it will add extra complexity on calclulation */ 
#WHERE s.Keyword = 'pcta' #and s.SessionId in ('d3989cf8ef244653efac851f9b9cdb9e') 
GROUP BY s.Keyword, s.URL#, c.Product_Code#, s.SessionId#, s.Series_Code 
ORDER BY total_searches DESC#, s.keyword DESC
) AS t

#Where t.Keyword in ('CLBU8-11-10', 'ABHPL', 'bushing','anb')
GROUP BY t.Keyword
ORDER BY t.total_searches DESC, t.keyword DESC
;

