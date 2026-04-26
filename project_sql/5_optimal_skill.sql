--5. What are the most optimal skills to learn?
--  • Optimal: High Demand AND High Paying.

SELECT 
        skills.skills AS skill,
        count(skills.skill_id) AS skill_count,
        avg(salary_year_avg) AS average_salary
FROM
        job_postings_fact

INNER JOIN skills_job_dim AS skills_to_jobs ON skills_to_jobs.job_id = job_postings_fact.job_id
INNER JOIN skills_dim AS skills ON skills.skill_id = skills_to_jobs.skill_id
WHERE 
        job_title_short = 'Data Analyst' AND 
        salary_year_avg IS NOT NULL AND
        job_location = 'India'
GROUP BY skills.skills

ORDER BY 
        skill_count DESC
        
LIMIT 10;
