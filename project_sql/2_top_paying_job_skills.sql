/* 2. What are the skills required for these top-paying roles for my location?

 */
   WITH top_paying_jobs AS(
   SELECT 
         job_id,
         job_title,
         company_dim.name AS company_name,
         salary_year_avg
        
   FROM 
         job_postings_fact AS job_postings
   LEFT JOIN 
         company_dim ON job_postings.company_id = company_dim.company_id
   WHERE 
         job_title_short = 'Data Analyst' AND 
         job_location = 'India'
   
   ORDER BY 
         salary_year_avg DESC NULLS LAST
         LIMIT 10
   )

   SELECT 
       top_paying_jobs.*,
      skills.skills
   FROM 
        top_paying_jobs
   INNER JOIN 
        skills_job_dim AS skills_to_jobs ON skills_to_jobs.job_id = top_paying_jobs.job_id
   INNER JOIN 
        skills_dim AS skills ON skills.skill_id = skills_to_jobs.skill_id
   ORDER BY salary_year_avg DESC