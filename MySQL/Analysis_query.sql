RESET QUERY CACHE ;
FLUSH TABLES ;
# or use SQL_NO_CACHE in select statement

#Similar version to above - but gives more results because of left join
# It gets results from left table and matching ones from the right table
#count(s.Keyword) as Keyword_Count, 

Select 	distinct s.AccessDateTime, 
		s.Keyword, 
		s.Search_Type, 
		d.Tab_Name, 
		s.Series_Code, 
		c.Product_code, 
		s.Link_URL, 
		s.SessionId
From search s
	Left Join detail_tab d	On s.SessionId = d.SessionId and s.Link_URL = d.Page_URL 
	Inner Join code_fix c 	On s.SessionId = c.SessionId and (s.Series_Code = c.Series_Code or d.Page_URL = c.Referer_URL)
Where s.Status = 'Link' # Limiting results to Link only for now 
	  and s.SessionId = '6e64b44adbec3cf7ad6cb820751159c0' 	

ORDER BY s.Keyword ASC;
#ORDER BY Keyword_Count DESC;


#USE THIS GUY - Or use below one, its more optiomized. and using select distinct gives correct count as well
# Its original version is far below without select distinct
Select distinct s.AccessDateTime,
		s.Keyword, 
		count(s.Keyword) as keyword_count,			
		s.Search_Type, 
		d.Tab_Name, 
		s.Series_Code, 
		c.Product_code, 
		s.Link_URL, 
		s.SessionId
From search as s 	
	Left Join (
			select distinct SessionId, Page_URL, Tab_Name 
			from detail_tab
	) as d On s.SessionId = d.SessionId and s.Link_URL = d.Page_URL 
	Inner Join(
			select distinct SessionId, Series_Code, Referer_URL, Product_Code 
			from code_fix
	) as c On s.SessionId = c.SessionId and (s.Series_Code = c.Series_Code or d.Page_URL = c.Referer_URL)
Where s.Status = 'Link' # Limiting results to Link only for now 
	  #and s.SessionId = '6e64b44adbec3cf7ad6cb820751159c0' 	
	  #and s.Keyword = 'sanitary'
Group by s.Keyword, s.Series_Code, c.Product_Code 
ORDER BY keyword_count DESC
;



# Without select distinct, gives correct result but wrong counts

Select distinct s.AccessDateTime, 
		s.Keyword, 
		#count(distinct s.Keyword) as keyword_count,			
		s.Search_Type, 
		d.Tab_Name, 
		s.Series_Code, 
		c.Product_code, 
		s.Link_URL, 
		s.SessionId
		
From search as s 	

	Left Join (
			select SessionId, Page_URL, Tab_Name 
			from detail_tab
	) as d On s.SessionId = d.SessionId and s.Link_URL = d.Page_URL 
	
	Inner Join(
			select SessionId, Series_Code, Referer_URL, Product_Code 
			from code_fix
	) as c On s.SessionId = c.SessionId and (s.Series_Code = c.Series_Code or d.Page_URL = c.Referer_URL)
Where s.Status = 'Link' # Limiting results to Link only for now 
	  and s.SessionId = '6e64b44adbec3cf7ad6cb820751159c0' 	
#Group by s.Keyword, s.Series_Code, c.Product_Code 
ORDER BY s.Keyword ASC
;




#count(distinct s.Keyword) as Keyword_Count - fast but not much useful
Select  distinct s.Keyword, s.Search_Type, d.Tab_Name, s.Series_Code, c.Product_code, s.Link_URL, s.AccessDateTime, s.SessionId
From search s, detail_tab d, code_fix c	
Where (	s.SessionId = d.SessionId 
		and s.Link_URL = d.Page_URL 
		and s.Status = 'Link'	
		and s.SessionId = c.SessionId
		and (s.Series_Code = c.Series_Code or d.Page_URL = c.Referer_URL)
		and s.SessionId = '6e64b44adbec3cf7ad6cb820751159c0' 
	  )
#Group by s.Keyword
ORDER BY s.Keyword ASC;


# Below is an example of optimized join instead of uisng where in
#slow query: 0.7+ seconds (cache cleared)

SELECT SQL_NO_CACHE forum_id, topic_id FROM bb_topics 
WHERE topic_last_post_id IN 
(SELECT SQL_NO_CACHE  MAX (topic_last_post_id) AS topic_last_post_id
FROM bb_topics WHERE topic_status=0 GROUP BY forum_id)

#fast query: 0.004 seconds or less (cache cleared)
SELECT SQL_NO_CACHE forum_id, topic_id FROM bb_topics AS s1 
JOIN 
(SELECT SQL_NO_CACHE MAX(topic_last_post_id) AS topic_last_post_id
FROM bb_topics WHERE topic_status=0 GROUP BY forum_id) AS s2 
ON s1.topic_last_post_id=s2.topic_last_post_id  



