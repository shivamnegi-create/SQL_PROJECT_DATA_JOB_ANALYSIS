-- 4.What are the top-10 skills based on salary for my role in India?

SELECT 
        skills.skills AS skill,
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
        average_salary DESC
LIMIT 10;
