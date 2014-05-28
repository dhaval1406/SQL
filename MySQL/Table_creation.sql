# skipping the header record
LOAD DATA LOCAL INFILE 'P:/Data_Analysis/Analysis_Results/web_prototype_analysis_08262013.csv' 
	INTO TABLE keyword_url 
	FIELDS terminated by ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;


# skipping the header record
LOAD DATA LOCAL INFILE 'P:/Data_Analysis/Analysis_Results/keyword_analysis_5_08012013.csv' 
	INTO TABLE analysis_results 
	FIELDS terminated by ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

/* week worth of data */

CREATE TABLE code_fix_example LIKE web_logs.detail_tab;

LOAD DATA LOCAL INFILE 'P:/Data_Analysis/search_log_20130618_20130625.txt' 
	INTO TABLE search 
	FIELDS terminated by '\t' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;


LOAD DATA LOCAL INFILE 'P:/Data_Analysis/detailtab_log_20130618_20130625.txt' 
	INTO TABLE detail_tab 
	FIELDS terminated by '\t' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;


LOAD DATA LOCAL INFILE 'P:/Data_Analysis/codefix_log_20130618_20130625.txt' 
	INTO TABLE code_fix 
	FIELDS terminated by '\t' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;


/* Initial load */

LOAD DATA LOCAL INFILE 'P:/TempData_06042013/us_search_temp.txt' 
	INTO TABLE search 
	FIELDS terminated by '\t' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;


LOAD DATA LOCAL INFILE 'P:/TempData_06042013/us_dt_detailtab_fix_temp.txt' 
	INTO TABLE detail_tab 
	FIELDS terminated by '\t' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;


LOAD DATA LOCAL INFILE 'P:/TempData_06042013/us_dt_codefix_temp.txt' 
	INTO TABLE code_fix 
	FIELDS terminated by '\t' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'P:/Data_Analysis/Analysis_Results/web_prototype_analysis_08202013.csv'   INTO TABLE keyword_url   FIELDS terminated by ','   LINES TERMINATED BY '\n'  IGNORE 1 LINES
