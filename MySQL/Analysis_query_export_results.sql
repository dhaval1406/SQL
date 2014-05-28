SELECT #header section of csv
		"AccessDateTime",
		"Keyword", 
		"keyword_count",			
		"Search_Type", 
		"Tab_Name", 
		"Series_Code", 
		"Product_code", 
		"Link_URL", 
		"SessionId"

UNION ALL

Select distinct s.AccessDateTime,
		s.Keyword, 
		count(s.Keyword) as keyword_count,			
		s.Search_Type, 
		d.Tab_Name, 
		s.Series_Code, 
		c.Product_code, 
		s.Link_URL, 
		s.SessionId

INTO OUTFILE 'C:/results.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'

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
