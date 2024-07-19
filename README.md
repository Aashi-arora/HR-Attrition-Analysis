# HR Data Analysis: Uncovering Attrition Causes and Training Improvements

## Introduction

This project aims to provide a comprehensive understanding of employee turnover and the impact of training initiatives based on HR data. The analysis focuses on determining the reasons behind employee retention rates and evaluating the effectiveness of employee training programs.

## Objectives

1. To determine the reason behind the employee retention rate by analyzing the given dataset.
2. To evaluate and classify the effectiveness of employee training programs to refine their performance and development.

## Data Cleaning and Preparation

The initial dataset contained various missing values and discrepancies. The data cleaning involved the following steps:
1. Categorized `Age` and `Years_of_Service` into more precise groups.
2. Standardized `Position` and `Gender` columns.
3. Categorized `Salary`, `Training_hours`, `Absenteeism`, and `Distance_from_Work` into meaningful groups.
4. Derived `Employee_JobSatisfaction_Score` and `EmployeeBenefitScore` from job satisfaction factors and employee benefits.
5. Filtered out interns from the analysis.

## Analysis and Insights

### Employee Attrition Insights

1. **Segmented by Gender**
   - Males have a higher attrition rate (53%) compared to females (49%).
   - Despite higher salaries and promotion rates, males have lower job satisfaction scores and higher absenteeism.

2. **Segmented by Age Groups**
   - Highest attrition rate among the 50+ age group (57%).
   - High attrition in the 20-29 age group due to lower engagement scores and higher average distance from work.

3. **Segmented by Department**
   - The sales department has the highest attrition rate (57%).
   - Finance and IT departments exhibit better employee retention.

4. **Segmented by Position**
   - High attrition rates among Software Engineers (83%) and Content Creators (70%).
   - Lower attrition rates for Data Scientists and Data Analysts.


### Training Program Optimization

1. **Training Impact on Promotions**
   - Employees with 40+ hours of training have the highest promotion rate (55%).
   - 21-30 hours of training needs improvement in content and delivery methods.

2. **Training Impact on Performance and Engagement**
   - Balanced outcomes with 21-30 hours of training.
   - 40+ hours of training improves performance but may reduce engagement.

## Recommendations

1. **Review Promotion Policies**: Ensure fairness and transparency in promotions.
2. **Conduct Confidential Surveys**: Identify department-specific issues.
3. **Implement Structured Salary Reviews**: Reward loyalty and performance.
4. **Improve Departmental Performance**: Targeted training and resources for Sales, Marketing, and Operations.
5. **Foster a Positive Work Environment**: Promote work-life balance and recognize achievements.
6. **Gather Qualitative Feedback**: Use exit surveys to understand attrition reasons.
