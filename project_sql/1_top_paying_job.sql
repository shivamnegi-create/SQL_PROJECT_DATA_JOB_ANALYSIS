/* 
1. What are the top10-paying jobs for my role(Data Analyst) in India?

 */
   SELECT 
         job_id,
         job_title,
         job_schedule_type,
         salary_year_avg,
         salary_year_avg * 83 AS salary_inr,
         company_dim.name AS company_name,
         job_posted_date
   FROM 
         job_postings_fact AS job_postings
   LEFT JOIN 
         company_dim ON job_postings.company_id = company_dim.company_id
   WHERE 
         job_title_short = 'Data Analyst' AND 
         job_location  = 'India'
   
   ORDER BY 
         salary_year_avg DESC NULLS LAST
   LIMIT 10;
   
   