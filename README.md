# Pewlett-Hackard-Analysis


The resources given to me in the beginning of the module included six excel files. Within these files, included common columns that served as primary keys to reference from that allows PostgreSQL to Create, read, update and delete new and improved revealing tables. The Entity Relationship Diagram (ERD) below describes the relationship between each of the starting six files.

![EmployeeDB](https://github.com/Daniel-Schroeder15/Pewlett-Hackard-Analysis/blob/master/EmployeeDB.png)

## Challenge Technical Analysis
The “retirement_title_count.csv” includes the number of individuals retiring categorized by the most recent title of each employee. The table includes the total number for Assistant Engineer, Engineer, Manager, Senior Engineer, Senior Staff, Staff, and Technique Leader. The first table created contained duplicates, because some employees have switch titles over the years. The duplicates needed to be removed by partitioning the data in a table into smaller bits so we can view what is necessary.

-	501 – Assistant Engineer
-	4692 – Engineer
-	2 – Manager
-	15600 – Senior Engineer
-	14735 - Senior Staff
-	2827 – Staff
-	2013 – Technique Leader

Further Analysis for retiring employees would include the number of employees that are currently working for Pewlett Hackarad. Also, the sum of salaries for those currently employed and near to retirement. To get this “retirement_title_count” table, I used the original employees, titles, and salaries csv files. The connection between the three is displayed above in the ERD.


The “eligible_list.csv” includes the number of current employees available for the mentorship program. The table shows 1549 current employees that have a date of birth that falls between January 1, 1965 and December 31, 1965. The first table created contained duplicates, because some employees have switch titles over the years. The duplicates needed to be removed by partitioning the data in a table into smaller bits so we can view what is necessary.

Further Analysis for employees eligible for the mentorship program would include the number of employees for the following year. One could also offer the program to those in their current job title for two or more years. This would require an additional table that displays employees eligible for the following year and/or those who have been in their current title for two or more years.To get this “eligible_list” table, I used the original employees, dept_emp, and titles csv files. The connection between the three is displayed above in the ERD with the employee number.
