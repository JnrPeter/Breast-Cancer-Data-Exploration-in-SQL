-- Taking a look at the Dataset
SELECT 
    *
FROM
    cancer

-- What is the distribution of the races affected by cancer?
SELECT 
    race, COUNT(*)
FROM
    cancer
GROUP BY 1

-- What is the distribution of the marital status of breast cancer patients?

SELECT 
    marital_status, COUNT(*) as number_
FROM
    cancer
GROUP BY 1


-- What is the patient age distribution?

SELECT 
    CASE
        WHEN AGE > 60 THEN 'above 60'
        WHEN AGE >= 50 AND AGE <= 60 THEN '50 - 60 years'
        WHEN AGE >= 40 AND AGE <= 49 THEN '40s'
        WHEN AGE >= 30 AND AGE <= 39 THEN '30s'
        ELSE 'none'
    END AS age_groups,
    COUNT(*) AS number_of_patients
FROM
    cancer
GROUP BY 1   


-- What is the number of patients who have more than two years to survive?

SELECT 
    CASE
        WHEN Survival_Months > 24 THEN 'OVER 2 Years'
        ELSE 'UNDER 2 YEARS'
        END AS years,
    COUNT(*) as number_patients
FROM
    CANCER
GROUP BY 1
ORDER BY 2 desc
    
         
-- Which race has more patients with over 2 years of survival 

with t1 as (SELECT race, survival_months,
         CASE 
        WHEN Survival_Months > 24 THEN 'OVER 2 Years'
        ELSE 'UNDER 2 YEARS'
        END AS survival_years
        FROM
       CANCER)
       
SELECT 
    race,
    survival_years,
    COUNT(survival_years) AS number_of_patients
FROM
    t1
WHERE
    survival_years = 'OVER 2 Years'
GROUP BY 1 , 2
ORDER BY 2


-- What is the average tumor size amongst the cancer patients

SELECT 
    AVG(Tumor_Size) AS avg_tumor_size
FROM
    cancer

-- What is the number of patients with above average tumor size?

SELECT 
    CASE
        WHEN Tumor_Size > 30.4737 THEN 'Above_Average'
        ELSE 'Below_Average'
    END AS tumor_sizes,
    COUNT(*) AS number_patients
FROM
    CANCER
GROUP BY 1
ORDER BY 2 DESC

-- What is the Percentage of patients with below or above average tumor sizes?

With t1 as (SELECT 
    CASE
        WHEN Tumor_Size > 30.4737 THEN 'Above_Average'
        ELSE 'Below_Average'
    END AS tumor_sizes,
    COUNT(*) AS number_patients
FROM
    CANCER
GROUP BY 1
)

SELECT 
    tumor_sizes,
    (number_patients) * 100 / (SELECT 
            COUNT(*)
        FROM
            cancer) AS Size_Percentage
FROM
    t1
GROUP BY 1

-- Find the estrogen status distribution for the various extent of tumors(T_Stage)

With t1 as  (SELECT T_Stage, 
              CASE WHEN Estrogen_Status  = 'Positive' 
              THEN 1 ELSE 0 END AS Positive, 
              CASE WHEN Estrogen_Status  = 'Positive' 
              THEN 0 ELSE 1 END AS Negative
              FROM cancer)

SELECT 
    t_stage,
    SUM(Positive) AS Positive,
    SUM(Negative) AS Negative
FROM
    t1
GROUP BY 1


-- Which age group has the highest number of patients with positive estrogen status?
With t1 as  (SELECT 
              CASE
        WHEN AGE > 60 THEN 'above 60'
        WHEN AGE >= 50 AND AGE <= 60 THEN '50 - 60 years'
        WHEN AGE >= 40 AND AGE <= 49 THEN '40s'
        WHEN AGE >= 30 AND AGE <= 39 THEN '30s'
        ELSE 'none'
    END AS age_groups,
              CASE WHEN Estrogen_Status  = 'Positive' 
              THEN 1 ELSE 0 END AS Positive, 
              CASE WHEN Estrogen_Status  = 'Positive' 
              THEN 0 ELSE 1 END AS Negative
              FROM cancer)

SELECT age_groups,sum(Positive) as Positive
FROM t1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

-- How many patients with above average sized tumors tested positive for both hormone receptors(Estrogen and Progesterone)? 
With t1 as 
          (SELECT 
           CASE WHEN Tumor_Size > 30.4737 THEN 'Above_Average'
           ELSE 'Below_Average'
           END AS tumor_sizes,
           CASE WHEN Estrogen_Status  = 'Positive' AND Progesterone_Status = 'Positive'
           THEN 1 ELSE 0 END AS Positive,
           CASE WHEN Estrogen_Status  = 'Positive' AND Progesterone_Status = 'Positive'
           THEN 0 ELSE 1 END AS Negative
           FROM CANCER)

SELECT 
    tumor_sizes,
    SUM(Positive) AS Positive_Estrogen_and_Progestorone
FROM
    t1
GROUP BY 1
ORDER BY 2 DESC


-- What is the number of patients who tested positive for both hormone receptors(Estrogen and Progesterone) for each Grade of tumor? 
With t1 as 
          (SELECT 
           grade,
           CASE WHEN Estrogen_Status  = 'Positive' AND Progesterone_Status = 'Positive'
           THEN 1 ELSE 0 END AS Positive,
           CASE WHEN Estrogen_Status  = 'Positive' AND Progesterone_Status = 'Positive'
           THEN 0 ELSE 1 END AS Negative
           FROM CANCER)

SELECT 
    grade,
    SUM(Positive) AS Positive_Estrogen_and_Progestorone
FROM
    t1
GROUP BY 1
ORDER BY 2 DESC


-- How many patients are alive or dead?

SELECT 
    status, COUNT(*) AS num
FROM
    cancer
GROUP BY 1

-- How many patients are alive or dead for each grade of tumor?
With t1 as 
          (SELECT 
           grade,
           CASE WHEN Status  = 'Alive' 
           THEN 1 ELSE 0 END AS Alive,
           CASE WHEN Status  = 'Alive' 
           THEN 0 ELSE 1 END AS Dead
           FROM CANCER)
           
   SELECT 
    grade, SUM(Alive) AS number_alive, SUM(Dead) AS number_dead
FROM
    T1
GROUP BY 1