# Introduction
Dive into data job market! Focusing on data analyst roles in India, this projects explores the top paying jobs, in demand skills and where high demand meets high salary in data analytics.

SQL queries? Check them out here : [project_sql folder](/project_sql)

# Background
Driven by the quest to navigate the data analyst job market in India more effectively, this project was born from a desire to pin-point top-paid and in demand skills, streamlining others work to find the optimal jobs.

The [dataset](https://drive.google.com/drive/folders/1moeWYoUtUklJO6NJdWo9OV8zWjRn0rjN) used in this project was provided in a GDrive link by Luke Barousse. It consists of real-world job postings data collected through his [job data platform](https://datanerd.tech/). It includes job titles, salary estimates, locations, and associated skills, allowing for practical analysis of demand and salary trends in the data analyst job market in India.
## The questions I wanted to answer through my SQL queries were -
**(Note)** - This analysis is limited to job postings in India.
1. What are the top 10- highest paying jobs for my role?
2. What are the skills required for these top-paying roles?
3. What are the top-10 most in-demand skills for my role ?
4. What are the top-10 skills based on salary for my role?
5. What are the most optimal skills to learn?

# Tools I Used
For the analysis I used the following tools -  

- **SQL**: The backbone of my analysis, allowing me to query the database and take several insights.

- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.

- **Visual Studio Code**: My go-to for database management and executing SQL queries.

- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
 

# The Analysis
Each query for this project aimed at investigating different aspects of the data analyst job market in India.  
Here is how i approached each question :  
### 1. Top Paying Data Analyst Job
The query finds the top 10 highest paying Data Analyst job in India. It joins job postings with company data to get company name. Salary is also converted to INR in a seperate column. Then the Data is filtered for Data Analyst roles in India and sorted by highest salary.
```sql
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
```
Breakdown of the top data analyst job in India -   
- **Wide Salary Range:** Top 10 paying Data Analyst roles span from ₹53,78,400 to ₹98,97,750, indicating significant salary potential in the field in India.
- **Diverse Employers:** Companies like Deutsche Bank,Clarivate and Loop Health are some of the top paying companies, showing broad interest across industries.
- **Job title Variety:** There is high diversity in the job titles, from  Financial Data Analyst to Healthcare Research & Data Analyst, reflecting varied roles and specialisation within Data Analytics.


### 2. Skills required for top paying jobs
This query finds the skill required for top paying jobs in India. A CTE is created using the previous query to select the top paying jobs. This result is then joined with skill related tables to retrieve the associated skill. The final output shows the skills required for these high-paying roles.
```sql
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
   
   ```
   Breakdown of the skills required for top paying jobs -
- **SQL** is the leading at the top with the bold count of 7.
- **Excel**  follows closely with a bold count of 6
- **Python** is highly sought after with the bold cold of 5,other skills like **PyTorch**, **Sheets**, **PowerPoint**, **Power BI** etc shows varying degree of demand.
### 3. Most demanded skills for Data Analyst 
This query finds the most demanded skills for Data Analyst role in India. It joins job postings with skill related table to get the counts of skill and grouping the counts with appropiate skill name.

```sql 
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
```
## Top 5 Skills by Demand

| Rank | Skill     | Count |
|------|----------|-------|
| 1    | SQL      | 1016  |
| 2    | Excel    | 717   |
| 3    | Python   | 687   |
| 4    | Tableau  | 545   |
| 5    | Power BI | 402   |
### 4. Top paying skills for Data Analyst role  
This query finds out the top paying skills for Data Analyst role in India. It joins the job posting table with related skill table to get the skill names.It filters the data by job title and job location. It then groups the skill by average salary.

```sql
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
```
## Top 5 Skills by Average Salary

| Rank | Skill        | Average Salary |
|------|-------------|----------------|
| 1    | Visio       | 119250         |
| 2    | Confluence  | 119250         |
| 3    | Jira        | 119250         |
| 4    | Azure       | 118140         |
| 5    | Power BI    | 118140         |

Specialized skills, such as **Visio** and **Confluence**, are associated with the highest average salaries, indicating higher salary potential for niche specialization.
### 5. Analysing optimal skill
The query finds out the optimal skill(High salary and High demand) for Data Analyst in India.It joins the job posting with related skills tables and filters the data by job title and location. The table is grouped by skill name to show the skill count and average salary for each skill.
```sql
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
```
### Optimal Skills (Demand vs Salary)

| Rank | Skill       | Skill Count | Average Salary |
|------|------------|------------|----------------|
| 1    | SQL        | 9          | 85,397         |
| 2    | Excel      | 8          | 84,366         |
| 3    | Python     | 6          | 77,186         |
| 4    | Tableau    | 3          | 74,435         |
| 5    | Word       | 3          | 89,579         |
| 6    | R          | 3          | 76,667         |
| 7    | Flow       | 2          | 96,604         |
| 8    | MS Access  | 1          | 64,600         |
| 9    | Looker     | 1          | 64,600         |
| 10   | Power BI   | 1          | 118,140        |

- **SQL** and **Excel** shows the strongest balance of demand and salary, making them the most reliable core skills.
- Python has moderate demand but slightly lower average salary, indicating it is valuable but after used alongside other tools.
- Tools like PowerBi and Flow offer higher salaries but have very low demand suggesting they are specialized skills rather than entry-level priorities.
- Overall, foundational skills dominate the market, while high paying tools tend to be niche and less freqently required.
# What I learned
## What I Learned

- I learned how to join multiple tables(fact and dimension tables) and create CTEs  to extract meaningful insights from relational data.

- I improved my understanding of SQL aggregation functions such as COUNT() and AVG() to analyze demand and salary trends.

- I learned how data can be misleading if not interpreted carefully (e.g., low-count skills showing high average salary due to small sample size).

- I developed the ability to move from raw data to insights by identifying patterns like high demand vs high salary trade-offs.

- I understood the importance of defining metrics clearly (e.g., what “optimal skill” actually means in terms of demand and salary).

- I learned how to present findings in a structured way using tables and concise explanations.

# Conclusions
Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at ₹98,97,750.
2. **Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills:** SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries:** Specialized skills, such as visio and confluence, are associated with the highest average salaries, indicating a premium on niche expertise.

5. **Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.
