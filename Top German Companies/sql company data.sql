select *
from `top german companies`;

SELECT*,
ROW_NUMBER() OVER(
PARTITION BY Company, Period, Revenue,`Net Income`, Liabilities, Assets, Equity, ROA, ROE, `Debt to Equity`, `Percentage debt to equity` )
from `top german companies`;

SELECT DISTINCT `company` 
FROM `top german companies`;

SELECT DISTINCT (trim(`company`)) as 'German company'
FROM `top german companies`;

SELECT company, trim(`company`)
FROM `top german companies`;

UPDATE `top german companies`
SET company = trim(`company`);

select *
from `top german companies`;

SELECT `Period`,
str_to_date(`Period`, '%m/%d/%Y')
FROM `top german companies`;

UPDATE `top german companies`
SET `Period` = str_to_date(`Period`, '%m/%d/%Y');

select *
from `top german companies`;

ALTER TABLE `top german companies`
ADD COLUMN currency VARCHAR (5),
ADD COLUMN company_reveue DECIMAL(15,2);


UPDATE `top german companies`
SET currency = TRIM(SUBSTRING_INDEX(Revenue, ' ', 1)),
    company_revenue = CAST(REPLACE(REPLACE(Revenue, '€', ''), ',', '') AS DECIMAL(15,2));



ALTER TABLE `top german companies`
ADD COLUMN company_Net_Income DECIMAL(15,2), 
ADD COLUMN company_Liabilities DECIMAL(15,2),
ADD COLUMN company_Assets DECIMAL(15,2),
ADD COLUMN company_Equity DECIMAL(15,2)
;

select *
from `top german companies`;

UPDATE `top german companies`
SET company_Equity = CAST(REPLACE(REPLACE(Equity, '€', ''), ',', '') AS DECIMAL(15,2)),
    company_Net_Income = CAST(REPLACE(REPLACE(`Net Income`, '€', ''), ',', '') AS DECIMAL(15,2)),
    company_Liabilities = CAST(REPLACE(REPLACE(Liabilities, '€', ''), ',', '') AS DECIMAL(15,2)),
    company_Assets = CAST(REPLACE(REPLACE(Assets, '€', ''), ',', '') AS DECIMAL(15,2));

select *
from `top german companies`;

ALTER TABLE `top german companies`
DROP COLUMN `Revenue`,
DROP COLUMN `Net Income`,
DROP COLUMN `Liabilities`,
DROP COLUMN `Assets`,
DROP COLUMN `Equity`;

select *
from `top german companies`;

ALTER TABLE `top german companies`
MODIFY COLUMN `ROA` decimal(5,2);

describe `top german companies`;

ALTER TABLE `top german companies`
MODIFY COLUMN `ROE`decimal(5,2),
MODIFY COLUMN `Debt to Equity` decimal(5,2),
MODIFY COLUMN `Percentage debt to equity` decimal(5,2);

select *
from `top german companies`;

SELECT *
from `top german companies`
WHERE `company` LIKE 'Volks%'
order by `period`;

SELECT 
    COUNT(*) - COUNT(Company) AS missing_companies,
    COUNT(*) - COUNT(Period) AS missing_period,
    COUNT(*) - COUNT(ROA) AS missing_roa,
    COUNT(*) - COUNT(ROE) AS missing_roe,
    COUNT(*) - COUNT(`Debt to equity`) AS missing_debt_to_equity,
    COUNT(*) - COUNT(`Percentage debt to equity`) AS missing_percentage_debt_to_equity,
    COUNT(*) - COUNT(Currency) AS missing_currency,
    COUNT(*) - COUNT(Company_Revenue) AS missing_revenue,
    COUNT(*) - COUNT(Company_Net_Income) AS missing_net_income,
    COUNT(*) - COUNT(Company_Liabilities) AS missing_liabilities,
    COUNT(*) - COUNT(Company_Assets) AS missing_assets,
    COUNT(*) - COUNT(Company_Equity) AS missing_equity
FROM `top german companies`;

SELECT * 
FROM `top german companies`
WHERE ROA > (SELECT AVG(ROA) + 3 * STDDEV(ROA) FROM `top german companies`)
   OR ROA < (SELECT AVG(ROA) - 3 * STDDEV(ROA) FROM `top german companies`);

SELECT *
FROM `top german companies`
WHERE `company_revenue` > (SELECT AVG(company_revenue) + 3 * stddev(company_revenue) from `top german companies`)
   OR `company_revenue` < (SELECT AVG(company_revenue) - 3 * stddev(company_revenue)from `top german companies`);

SELECT 
    Company, 
    AVG(ROA) AS avg_roa,
    AVG(ROE) AS avg_roe,
    AVG(Company_Revenue) AS avg_revenue,
    AVG(Company_Net_Income) AS avg_net_income,
    AVG(Company_Liabilities) AS avg_liabilities,
    AVG(Company_Assets) AS avg_assets,
    AVG(Company_Equity) AS avg_equity
FROM `top german companies`
GROUP BY Company;

select *
from `top german companies`;

SELECT 
    Period, 
    AVG(ROA) AS avg_roa,
    AVG(ROE) AS avg_roe
FROM `top german companies`
where Company = 'volks%'
GROUP BY Period
ORDER BY Period;


WITH Quarterly_revenue AS (
    SELECT 
        Company,
        EXTRACT(YEAR FROM period) AS Year,
        CASE
            WHEN EXTRACT(MONTH FROM period) IN (1, 2, 3) THEN 'Q1'
            WHEN EXTRACT(MONTH FROM period) IN (4, 5, 6) THEN 'Q2'
            WHEN EXTRACT(MONTH FROM period) IN (7, 8, 9) THEN 'Q3'
            WHEN EXTRACT(MONTH FROM period) IN (10, 11, 12) THEN 'Q4'
        END AS Quarter,
        company_revenue
    FROM `top german companies`
)
SELECT
    Company,
    Year,
    (SELECT Quarter FROM Quarterly_revenue Qr
        WHERE Qr.Company = Qr1.Company
          AND Qr.Year = Qr1.Year
        ORDER BY Qr.company_revenue DESC LIMIT 1) AS Highest_Quarter,
    (SELECT Quarter FROM Quarterly_revenue Qr
        WHERE Qr.Company = Qr1.Company
          AND Qr.Year = Qr1.Year
        ORDER BY Qr.company_revenue ASC LIMIT 1) AS Lowest_Quarter
FROM Quarterly_revenue Qr1
GROUP BY Company, Year
ORDER BY Company, Year;

WITH Quarterly_revenue AS (
    SELECT 
        Company,
        EXTRACT(YEAR FROM period) AS Year,
        CASE
            WHEN EXTRACT(MONTH FROM period) IN (1, 2, 3) THEN 'Q1'
            WHEN EXTRACT(MONTH FROM period) IN (4, 5, 6) THEN 'Q2'
            WHEN EXTRACT(MONTH FROM period) IN (7, 8, 9) THEN 'Q3'
            WHEN EXTRACT(MONTH FROM period) IN (10, 11, 12) THEN 'Q4'
        END AS Quarter,
        company_revenue
    FROM `top german companies`
)
SELECT
    Company,
    Year,
    Quarter,
    company_revenue
FROM Quarterly_revenue
ORDER BY Year, Quarter,company_revenue DESC;

SELECT 
    Company,
    SUM(Company_revenue) AS total_revenue
FROM `top german companies`
GROUP BY Company
ORDER BY total_revenue DESC
LIMIT 5;

SELECT Company, 
       SUM(ROA)AS Total_ROA
FROM `top german companies`
GROUP BY Company
ORDER BY Total_ROA
LIMIT 5;

ALTER TABLE `top german companies`
DROP COLUMN `Percentage debt to equity`;

select *
FROM `top german companies`;

SELECT Company, MAX(ROE) as MAX_ROE
FROM `top german companies`
group by Company
order by Company ;

SELECT Company, MAX(`Debt to Equity`) as MAX_debt_to_equity
FROM `top german companies`
group by Company
order by Company ;

SELECT Company, AVG(ROA) AS avg_ROA, AVG(ROE) AS avg_ROE, MAX(`Debt to Equity`) AS max_Debt_to_Equity
FROM `top german companies`
WHERE ROA > 5 AND ROE > 10 AND `Debt to Equity` < 4
GROUP BY Company;

 SELECT Company,
       SUM(company_Net_Income) AS Net_Income_Sum,
       SUM(company_revenue) AS Revenue_Sum
FROM `top german companies`
group by Company
order by Net_Income_Sum DESC, Revenue_Sum DESC
LIMIT 5;
       
 SELECT Company,
       SUM(company_Net_Income) AS Net_Income_Sum,
       SUM(company_revenue) AS Revenue_Sum
FROM `top german companies`
group by Company
order by Revenue_Sum DESC, Net_Income_Sum DESC
LIMIT 5;














































