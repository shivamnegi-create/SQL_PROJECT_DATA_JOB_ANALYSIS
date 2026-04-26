/* 3. What are the top-10 most in-demand skills for my role in India?

  */
SELECT 
     skills.skills,
    COUNT(skills.skill_id) AS skill_count
FROM 
 job_postings_fact
INNER JOIN skills_job_dim AS skills_to_jobs ON skills_to_jobs.job_id = job_postings_fact.job_id
INNER JOIN skills_dim AS skills ON skills.skill_id = skills_to_jobs.skill_id
WHERE job_title_short = 'Data Analyst' AND
    job_location = 'India'

GROUP BY skills.skills
ORDER BY skill_count DESC
LIMIT 10;