-- Difference bwetween Age and Years_of_Service
SELECT Employee_Name, Position, Salary, Age, Years_of_Service, Age - Years_of_Service AS DIFF
FROM hr_analytics_dataset_adviti;
-- Years_of_service column have some discrepancy involves in that.

-- For finding out the first and last age for seeing how it can be distributed
SELECT DISTINCT Age, Count(*)
FROM hr_analytics_dataset_adviti
GROUP BY Age
ORDER BY Age;
-- 159 employees are of age 50 so there must be a problem with an Age column


-- Position Count
SELECT Position, COUNT(*)
FROM hr_analytics_dataset_adviti
GROUP BY Position;
-- 245 interns were hired which is huge

-- Intern position percentage of all employees
SELECT ROUND((SUM(CASE WHEN Position = 'Intern' THEN 1 ELSE 0 END)/COUNT(*))*100,2) AS PercIntern
FROM hr_analytics_dataset_adviti;
-- 32.67 % Interns of all employees can affect our analysis 

-- Hypothesis: Whether the Interns were hired or not
SELECT Employee_Name, Age, Count(*) AS TotalEmp
FROM hr_data
GROUP BY Employee_Name, Age
HAVING Count(*) > 1;
-- Conclusion: We can remove the interns data as nobody were hired.



-- Creating a subset of data set after cleaning and manipulating it
DROP TABLE IF EXISTS hr_data;
CREATE TABLE hr_data AS
SELECT
		Employee_ID,
        Employee_Name,
        Age,
        CASE 
			WHEN Age BETWEEN 20 AND 29 THEN '20-29'
            WHEN Age BETWEEN 30 AND 39 THEN '30-39'
            WHEN Age BETWEEN 40 AND 49 THEN '40-49'
			ELSE '50+'
        END AS Age_Group,
        Years_of_Service,
        CASE
			WHEN Years_of_Service <=2 THEN '0-2 Years'
			WHEN Years_of_Service <= 5 THEN '3-5 Years'
            WHEN Years_of_Service <= 10 THEN '6-10 Years'
            WHEN Years_of_Service <= 15 THEN '11-15 Years'
			ELSE '15+ Years'
        END AS Experience_Category,
        CASE
			WHEN Position IN ('Account Exec.', 'AccountExec.', 'AccountExecutive') THEN 'Account Executive'
            WHEN Position IN ('DataAnalyst', 'Analyst') THEN 'Data Analyst'
			ELSE Position
        END As Position,
        CASE
			WHEN Gender = 'Female' THEN 'F'
            WHEN Gender = 'Male' THEN 'M'
			ELSE Gender
        END As Gender, 
        Department,
        Salary,
        CASE
			WHEN Salary BETWEEN 0 AND 100000 THEN '0-1 Lac'
            WHEN Salary BETWEEN 100000 AND 1000000 THEN '1-10 Lacs'
            WHEN Salary BETWEEN 1000001 AND 2000000 THEN '10-20 Lacs'
            WHEN Salary BETWEEN 2000001 AND 3000000 THEN '20-30 Lacs'
            WHEN Salary BETWEEN 3000001 AND 4000000 THEN '30-40 Lacs'
            WHEN Salary BETWEEN 4000001 AND 5000000 THEN '40-50 Lacs'
            WHEN Salary BETWEEN 5000001 AND 6000000 THEN '50-60 Lacs'
            WHEN Salary BETWEEN 6000001 AND 7000000 THEN '60-70 Lacs'
            WHEN Salary BETWEEN 7000001 AND 8000000 THEN '70-80 Lacs'
            WHEN Salary BETWEEN 8000001 AND 9000000 THEN '80-90 Lacs'
            WHEN Salary >= 9000001 THEN '90 Lacs-1 Cr'
			ELSE 'Above 1 Cr'
        END As Income_Group,
        Performance_Rating,
        Work_Hours,
        Attrition,
        Promotion,
        Training_Hours,
        CASE 
			WHEN Training_Hours BETWEEN 0 AND 10 THEN '0-10 Hours'
            WHEN Training_Hours BETWEEN 11 AND 20 THEN '11-20 Hours'
            WHEN Training_Hours BETWEEN 21 AND 30 THEN '21-30 Hours'
            WHEN Training_Hours BETWEEN 31 AND 40 THEN '31-40 Hours'
			ELSE '40+ Hours'
		END AS Training_Hours_Category,
        Satisfaction_Score AS Employer_Satisfaction_Score,
        Education_Level,
        Employee_Engagement_Score,
        Absenteeism,
        CASE
			WHEN Absenteeism BETWEEN 0 AND 5 THEN '0-5 Days'
            WHEN Absenteeism BETWEEN 6 AND 10 THEN '6-10 Days'
            WHEN Absenteeism BETWEEN 11 AND 15 THEN '11-15 Days'
            ELSE '15+ Days'
		END AS Absenteeism_Category,
        Distance_from_Work,
        CASE
			WHEN Distance_from_Work < 10 THEN '0-10 kms'
            WHEN Distance_from_Work < 20 THEN '11-20 kms'
            WHEN Distance_from_Work < 30 THEN '20-30 kms'
            WHEN Distance_from_Work < 40 THEN '30-40 kms'
            ELSE '40+ kms'
		END AS Distance_from_Work_Category,
        JobSatisfaction_PeerRelationship,
        JobSatisfaction_WorkLifeBalance,
        JobSatisfaction_Compensation,
        JobSatisfaction_Management,
        JobSatisfaction_JobSecurity,
        (JobSatisfaction_PeerRelationship + 
		JobSatisfaction_WorkLifeBalance + 
		JobSatisfaction_Compensation +
		JobSatisfaction_Management +
		JobSatisfaction_JobSecurity)/5*100 AS Employee_JobSatisfaction_Score, 
        EmployeeBenefit_HealthInsurance,
        EmployeeBenefit_PaidLeave,
        EmployeeBenefit_RetirementPlan,
        EmployeeBenefit_GymMembership,
        EmployeeBenefit_ChildCare,
        (EmployeeBenefit_HealthInsurance +
        EmployeeBenefit_PaidLeave +
        EmployeeBenefit_RetirementPlan +
        EmployeeBenefit_GymMembership +
        EmployeeBenefit_ChildCare)/5*100 AS Employee_Benefit_Score
        FROM hr_analytics_dataset_adviti
        WHERE Position != 'Intern';


SELECT * FROM hr_data;



--      ----------             SUMMARY               ----------------

-- How many employees left or not?
SELECT Attrition, Count(Employee_ID) AS Total_Attrition
FROM hr_data
GROUP BY Attrition;
-- 260 employees have left


-- Taking some Metrics
SELECT 
	COUNT(Employee_ID) AS Total_Employees,
    COUNT(CASE WHEN Attrition = 'Yes' THEN 1 ELSE NULL END) AS Attrition_Count,
    ROUND(COUNT(CASE WHEN Attrition = 'Yes' THEN 1 ELSE NULL END)/COUNT(Employee_ID)*100,2) AS Attrition_Rate,
    COUNT(CASE WHEN Attrition = 'No' THEN 1 ELSE NULL END) AS Total_Active_Employees
FROM hr_data;
-- 51.49% is the attrition rate


-- Segmented by Gender
SELECT
	Gender,
    COUNT(Employee_ID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_Yes %',
    ROUND(SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_No %',
    FORMAT(AVG(Salary),0) As AvgSalary,
    ROUND(AVG(Years_of_Service),2) AS Avg_YearsOfService,
    ROUND(AVG(Performance_Rating),2) AS AvgPerformanceRating,
    ROUND(AVG(Work_Hours),2) AS AvgWorkHours,
	SUM(CASE WHEN Promotion = 'Yes' THEN 1 ELSE 0 END) AS Got_promoted,
    SUM(CASE WHEN Promotion = 'No' THEN 1 ELSE 0 END) AS Not_promoted,
    ROUND(AVG(Training_Hours),2) AS AvgTrainingHours,
    ROUND(AVG(Employer_Satisfaction_Score),2) AS AvgEmployerSatisfactionScore,
    ROUND(AVG(Employee_Engagement_Score),2) AS AvgEmployeeEngagementScore,
    ROUND(AVG(Absenteeism)) AS AvgAbsenteeism,
    ROUND(AVG(Distance_from_Work),2) AS AvgDistanceFromWork,
    ROUND(AVG(Employee_JobSatisfaction_Score),2) AS AvgEmployeeJobSatisfactionScore,
    ROUND(AVG(Employee_Benefit_Score),2) AS AvgEmployeeBenefitScore
FROM hr_data
GROUP BY Gender;
-- The attrition rate is higher among males (53%) compared to females (49%).
-- Males reported higher absenteeism and greater average distance from work than females, which could contribute to their higher attrition rates. 
-- Promotion opportunities seem adequate, but other aspects of job satisfaction need to be addressed to reduce attrition.



-- Segmented by Age Groups
SELECT
	Age_Group,
    COUNT(Employee_ID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_Yes %',
    ROUND(SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_No %',
	FORMAT(AVG(Salary),0) As AvgSalary,
    ROUND(AVG(Years_of_Service),2) AS Avg_YearsOfService,
    ROUND(AVG(Performance_Rating),2) AS AvgPerformanceRating,
    ROUND(AVG(Work_Hours),2) AS AvgWorkHours,
	SUM(CASE WHEN Promotion = 'Yes' THEN 1 ELSE 0 END) AS Got_promoted,
    SUM(CASE WHEN Promotion = 'No' THEN 1 ELSE 0 END) AS Not_promoted,
    ROUND(AVG(Training_Hours),2) AS AvgTrainingHours,
    ROUND(AVG(Employer_Satisfaction_Score),2) AS AvgEmployerSatisfactionScore,
    ROUND(AVG(Employee_Engagement_Score),2) AS AvgEmployeeEngagementScore,
    ROUND(AVG(Absenteeism)) AS AvgAbsenteeism,
    ROUND(AVG(Distance_from_Work),2) AS AvgDistanceFromWork,
    ROUND(AVG(Employee_JobSatisfaction_Score),2) AS AvgEmployeeJobSatisfactionScore,
    ROUND(AVG(Employee_Benefit_Score),2) AS AvgEmployeeBenefitScore
FROM hr_data
GROUP BY Age_Group;
-- 50+ age group show the highest attrition rate (57%). (We can also ignore this insight as we found discrepancy in this age group)
-- The 20-29 age group also has a high attrition rate (50%), potentially due to lower engagement scores and a higher average distance from work, which could be affecting their work-life balance.



-- Summarize employee attrition rates by Department
SELECT
	Department,
    COUNT(Employee_ID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_Yes %',
    ROUND(SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_No %'
FROM hr_data
GROUP BY Department;
-- The highest attrition rate at 57% in the Sales department indicates significant challenges in retaining employees in this area.
-- Finance and IT departments exhibit the lowest attrition rates at 46%, indicating better employee retention or higher job satisfaction in these functions compared to others.



-- Segmented By Position
SELECT
	Position,
    COUNT(Employee_ID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_Yes %',
    ROUND(SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_No %', 
	FORMAT(AVG(Salary),0) As AvgSalary,
    ROUND(AVG(Performance_Rating)) AS AvgPerformanceRating
FROM hr_data
GROUP BY Position;
-- Both the CEO and COO positions have a 100% attrition rate as there is only one employee for each position and both left the company.
-- High attrition rates are observed among Software Engineers (83%) and Content Creators (70%). 



-- Salary x Promotion x Years_of_service
SELECT
	Income_group,
    COUNT(Employee_ID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_Yes %',
    ROUND(SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_No %',
    SUM(CASE WHEN Promotion = 'Yes' THEN 1 ELSE 0 END) AS Got_promoted,
    SUM(CASE WHEN Promotion = 'No' THEN 1 ELSE 0 END) AS Not_promoted,
    ROUND(SUM(CASE WHEN Promotion = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Got_promoted %',
    ROUND(SUM(CASE WHEN Promotion = 'No' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Not_promoted %', 
    ROUND(AVG(Years_of_Service),1) As AvgYearsOfService
FROM hr_data
GROUP BY Income_group;
-- Employees in the higher income group 90 Lacs-1 Cr has the highest attrition rate at 72%. 



-- Departmental performance ratings in relation to training hours and satisfaction score
SELECT 
	Department,
	ROUND(AVG(Performance_Rating),2) AS AvgPerformanceRating,
    ROUND(AVG(training_hours),2) AS AvgTrainingHours,
    ROUND(AVG(Employer_Satisfaction_Score),2) As AvgEmployeeSatisfactionScore,
    ROUND(AVG(Work_Hours)) AS AvgWorkHours
FROM hr_data
GROUP BY Department
ORDER BY AvgPerformanceRating;
-- Despite receiving the highest average training hours, the Operations department has the lowest average performance rating.


-- Segmented by Work Hours
SELECT
    CASE 
		WHEN Work_Hours BETWEEN 40 AND 45 THEN '40-45'
		WHEN Work_Hours BETWEEN 45 AND 50 THEN '45-50'
		WHEN Work_Hours BETWEEN 50 AND 55 THEN '50-55'
		ELSE '55+'
        END AS Work_Hours_Group,
    COUNT(*) AS NoOfEmployees,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_Yes %',
    ROUND(SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_No %',
    FORMAT(AVG(Salary),0) As AvgSalary,
    ROUND(AVG(Years_of_Service),1) As AvgYearsOfService,
    ROUND(AVG(training_hours),2) AS AvgTrainingHours,
    ROUND(AVG(Employer_Satisfaction_Score),2) As AvgEmployeeSatisfactionScore,
    ROUND(SUM(CASE WHEN Promotion = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Got_promoted %',
    ROUND(SUM(CASE WHEN Promotion = 'No' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Not_promoted %',
    ROUND(AVG(Distance_from_Work),2) AS AvgDistanceFromWork,
    ROUND(AVG(Employee_JobSatisfaction_Score),2) As AvgEmployeeJobSatisfactionScore,
    ROUND(AVG(Employee_Benefit_Score),2) AS AvgEmployeeBenefitScore
FROM hr_data
GROUP BY Work_Hours_Group;
-- Employees working the longest hours (50-55 hours) exhibit the highest attrition rate and the lowest satisfaction score. 


-- Segmented by Promotion
SELECT
	Promotion,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_Yes %',
    ROUND(SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_No %',
    ROUND(AVG(Employee_JobSatisfaction_Score),2) As AvgEmployeeJobSatisfactionScore,
    ROUND(AVG(Employee_Benefit_Score),2) AS AvgEmployeeBenefitScore
FROM hr_data
GROUP BY Promotion;
-- Over half of the employees (54%) who did not receive promotions left the company. 


-- Segmented by Education level
SELECT
	Education_Level,
    COUNT(Employee_ID) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Yes,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Attrition_No,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_Yes %',
    ROUND(SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Attrition_No %',
    SUM(CASE WHEN Promotion = 'Yes' THEN 1 ELSE 0 END) AS Promoted,
    SUM(CASE WHEN Promotion = 'No' THEN 1 ELSE 0 END) AS NoPromotion,
    FORMAT(AVG(Salary),0) AS AvgSalary
FROM hr_data
GROUP BY Education_Level;
-- The attrition rate for employees with a bachelor's degree is high at 55%. 
-- This could be due to a combination of factors such as pursuing higher studies or dissatisfaction with promotion opportunities.


-- Comparative Analysis of Metrics for Employees with and without Attrition
SELECT 
	Attrition,
    ROUND(AVG(Age)) AS AvgAge,
    FORMAT(AVG(Salary),0) As AvgSalary,
    ROUND(AVG(Performance_Rating)) AS AvgPerformanceRating,
    ROUND(AVG(Work_Hours)) AS AvgWorkHours,
    ROUND(AVG(Training_Hours)) AS AvgTrainingHours,
    ROUND(AVG(Employer_Satisfaction_Score)) AS AvgEmployerSatisfactionScore,
    ROUND(AVG(Employee_Engagement_Score)) AS AvgEmployeeEngagementScore,
    ROUND(AVG(Absenteeism)) AS AvgAbsenteeism,
    ROUND(AVG(Distance_from_Work)) AS AvgDistanceFromWork,
    ROUND(AVG(Employee_JobSatisfaction_Score)) AS AvgEmployeeJobSatisfactionScore,
    ROUND(AVG(Employee_Benefit_Score)) AS AvgEmployeeBenefitScore
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY Attrition

UNION ALL

SELECT 
	Attrition,
	ROUND(AVG(Age)) AS AvgAge,
    FORMAT(AVG(Salary),0) As AvgSalary,
    ROUND(AVG(Performance_Rating)) AS AvgPerformanceRating,
    ROUND(AVG(Work_Hours)) AS AvgWorkHours,
    ROUND(AVG(Training_Hours)) AS AvgTrainingHours,
    ROUND(AVG(Employer_Satisfaction_Score)) AS AvgEmployerSatisfactionScore,
    ROUND(AVG(Employee_Engagement_Score)) AS AvgEmployeeEngagementScore,
    ROUND(AVG(Absenteeism)) AS AvgAbsenteeism,
    ROUND(AVG(Distance_from_Work)) AS AvgDistanceFromWork,
    ROUND(AVG(Employee_JobSatisfaction_Score)) AS AvgEmployeeJobSatisfactionScore,
    ROUND(AVG(Employee_Benefit_Score)) AS AvgEmployeeBenefitScore
FROM hr_data
WHERE Attrition = 'No'
GROUP BY Attrition;
-- While the differences are subtle, lower job satisfaction scores, longer commute distances, and higher training hours may contribute to employee attrition. 



-- Training impact relative to Years of service and Promotions
SELECT 
	Training_Hours_Category, 
    ROUND(AVG(Years_of_Service),2) AS AvgYearsOfService,
    ROUND(SUM(CASE WHEN Promotion = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'Got_promoted %',
    ROUND(SUM(CASE WHEN Promotion = 'No' THEN 1 ELSE 0 END)/COUNT(*)*100) AS 'No_promotion %'
FROM hr_data
GROUP BY Training_Hours_Category;


-- Training impact on Performance Rating and Engagement Score
SELECT 
	Training_Hours_Category, 
    ROUND(AVG(Performance_Rating),2) AS AvgPerformanceRating,
    ROUND(AVG(Employee_Engagement_Score),2) AS AvgEmployeeEngagementScore
FROM hr_data
GROUP BY Training_Hours_Category
ORDER BY Training_Hours_Category DESC;