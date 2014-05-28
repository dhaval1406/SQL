/* works fine using total_keyword_seaches_view */

SELECT z.AccessDateTime, z.Keyword, z.Series_Code, z.total_searches, z.sum_link
	  ,COUNT(z.Unique_CodeFix) AS Total_CodeFix_Count, z.Tab_name_count

FROM

(	SELECT s.*, t.total_searches, t.sum_link, c.Unique_CodeFix, d.Tab_name_count 
	FROM search s
	JOIN total_keyword_searches 
	AS t ON s.Keyword = t.Keyword AND s.Series_Code <> ''

	LEFT JOIN(
		SELECT DISTINCT AccessDateTime, SessionId, Series_Code, Referer_URL, Product_Code
				, COUNT(DISTINCT Product_Code) AS Unique_CodeFix
		FROM code_fix
		GROUP BY SessionId, Series_Code, Referer_URL, Product_Code
		ORDER BY Series_Code DESC
	) AS c ON s.SessionId = c.SessionId AND s.URL = c.Referer_URL 

# Tab_Name = 4 is commented and Tab_Name is removed from group by to get 
# the counts for all tabs
	LEFT JOIN (
		SELECT 	SessionId#, Page_URL
				,Tab_Name, Series_Code
			   ,COUNT(DISTINCT Tab_Name) AS Tab_name_count
		FROM detail_tab
		#WHERE Tab_Name = '4' 
		GROUP BY SessionId, Series_Code#, Tab_Name
	) AS d ON s.SessionId = d.SessionId AND s.Series_Code = d.Series_Code 
																				 
	GROUP BY s.Keyword, s.Series_Code, s.URL

) AS z
WHERE z.Keyword IN ('lead screw')
GROUP BY z.Keyword, z.Series_Code
ORDER BY z.total_searches DESC, z.keyword DESC
;



/* works fine, per session and ignoring total searches that resutls blank series code */
/* to get the total searches use the view total_keyword_searches and removing session_id = session_id */

SELECT z.AccessDateTime, z.Keyword, z.Series_Code, z.total_searches, z.sum_link

	,COUNT(z.Unique_CodeFix) AS Total_CodeFix_Count, COUNT(z.Tab_name_count) AS Total_Tab_name_count

FROM

(
	SELECT s.*, t.total_searches, t.sum_link, c.Unique_CodeFix, d.Tab_name_count 

	FROM search s

	JOIN total_keyword_searches_by_session 

	AS t ON s.Keyword = t.Keyword AND s.SessionId = t.SessionId AND s.Series_Code <> ''

	LEFT JOIN(
		SELECT DISTINCT AccessDateTime, SessionId, Series_Code, Referer_URL, Product_Code
				, COUNT(DISTINCT Product_Code) AS Unique_CodeFix
		FROM code_fix
		GROUP BY SessionId, Series_Code, Referer_URL, Product_Code
		ORDER BY Series_Code DESC
	) AS c ON s.SessionId = c.SessionId AND s.URL = c.Referer_URL 

	LEFT JOIN (
		SELECT 	SessionId#, Page_URL
				,Tab_Name, Series_Code
			   ,COUNT(DISTINCT Tab_Name) AS Tab_name_count
		FROM detail_tab
		WHERE Tab_Name = '4' 
		GROUP BY SessionId, Series_Code, Tab_Name
	) AS d ON s.SessionId = d.SessionId AND s.Series_Code = d.Series_Code 
																							 
	#Where s.Keyword in ('anb', 'CLBU8-11-10') #and s.Series_Code <> ''

	GROUP BY s.Keyword, s.Series_Code, s.URL
)
AS z
WHERE z.Keyword IN ('CLBU8-11-10', 'ABHPL', 'bushing','anb')
GROUP BY z.Keyword, z.Series_Code
ORDER BY z.total_searches DESC, z.keyword DESC
;



# Prior version of above query is 


SELECT *#s.*, c.Unique_CodeFix, d.Tab_name_count

	FROM search s

	JOIN total_keyword_searches_by_session 

	AS t ON s.Keyword = t.Keyword AND s.SessionId = t.SessionId AND s.Series_Code <> ''

	LEFT JOIN(
		SELECT DISTINCT AccessDateTime, SessionId, Series_Code, Referer_URL, Product_Code
				, COUNT(DISTINCT Product_Code) AS Unique_CodeFix
		FROM code_fix
		GROUP BY SessionId, Series_Code, Referer_URL, Product_Code
		ORDER BY Series_Code DESC
	) AS c ON s.SessionId = c.SessionId AND s.URL = c.Referer_URL 

	LEFT JOIN (
		SELECT 	SessionId#, Page_URL
				,Tab_Name, Series_Code
			   ,COUNT(DISTINCT Tab_Name) AS Tab_name_count
		FROM detail_tab
		WHERE Tab_Name = '4' 
		GROUP BY SessionId, Series_Code, Tab_Name
	) AS d ON s.SessionId = d.SessionId AND s.Series_Code = d.Series_Code 
																							 
	WHERE s.Keyword IN ('anb', 'CLBU8-11-10', 'ABHPL') #and s.Series_Code <> ''

	GROUP BY s.Keyword, s.Series_Code, s.URL



/* view that is used in the top query */
CREATE VIEW total_keyword_searches_by_session AS

	SELECT DISTINCT s.SessionId, s.Keyword, s.Series_Code
			,(SUM(IF(s.Status = 'Hit',1,0)) + SUM(IF(s.Status = 'NotFound',1,0))) AS total_searches	
			, SUM(IF(s.Status = 'Link',1,0)) AS sum_Link
	FROM search s
	#Where s.Keyword in ('anb', 'CLBU8-11-10')
	GROUP BY s.Keyword, s.SessionId;


CREATE VIEW total_keyword_searches AS

	SELECT DISTINCT s.SessionId, s.Keyword, s.Series_Code
			,(SUM(IF(s.Status = 'Hit',1,0)) + SUM(IF(s.Status = 'NotFound',1,0))) AS total_searches	
			, SUM(IF(s.Status = 'Link',1,0)) AS sum_Link
	FROM search s
	#Where s.Keyword in ('anb', 'CLBU8-11-10')
	GROUP BY s.Keyword;


	SELECT 	d.SessionId#, Page_URL
			,d.Tab_Name
			,d.Series_Code
		   ,COUNT(DISTINCT Tab_Name) AS Tab_name_count
	FROM detail_tab d
	WHERE d.Tab_Name = '4' 
		 AND d.SessionId IN ('79cd94d793c9984c833eb5da9eafabf3')#, '7d981db72a5c5797d340619b603e12bf');
	GROUP BY d.SessionId, d.Series_Code, d.Tab_Name;



	SELECT DISTINCT c.SessionId, c.Series_Code, c.Referer_URL
			#, COUNT(DISTINCT c.Product_Code) AS Unique_CodeFix
	FROM code_fix c
	WHERE c.SessionId IN ('79cd94d793c9984c833eb5da9eafabf3')#, '7d981db72a5c5797d340619b603e12bf');
	GROUP BY c.SessionId, c.Series_Code, c.Referer_URL
	ORDER BY c.Series_Code DESC;

