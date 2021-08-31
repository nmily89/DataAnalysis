------------Cleaning Data---------------

--Standarlize Columns Name
sp_rename 'WeeklyEarning.REF_DATE', 'YEAR'
sp_rename 'WeeklyEarning.VALUE', 'WEEKLY_EARNING'
sp_rename 'WeeklyEarning.STATUS', 'DATA_QUALITY'
sp_rename 'WeeklyEarning.DGUID', 'GEO_ID'
sp_rename 'WeeklyEarning.North American Industry Classification System (NAICS)', 'INDUSTRY'
sp_rename 'WeeklyEarning.Type of employees', 'EMPLOYEE_TYPE'

--Breaking out Industry into Industry Name and Industry Code
Select INDUSTRY from PortfolioProject..WeeklyEarning

Alter Table PortfolioProject..WeeklyEarning
Add INDUSTRY_CODE Nvarchar(255),
	INDUSTRY_NAME Nvarchar(255);

Select INDUSTRY, 
SUBSTRING(INDUSTRY,1, CHARINDEX('[',INDUSTRY) - 1),
REPLACE(SUBSTRING(INDUSTRY,CHARINDEX('[',INDUSTRY)+1, LEN(INDUSTRY)),']','')
from PortfolioProject..WeeklyEarning

Update PortfolioProject..WeeklyEarning
Set INDUSTRY_NAME = SUBSTRING(INDUSTRY,1, CHARINDEX('[',INDUSTRY) - 1),
	INDUSTRY_CODE = REPLACE(
		SUBSTRING(INDUSTRY,CHARINDEX('[',INDUSTRY)+1, LEN(INDUSTRY)),']',''
	);


-- Change Including Overtime to Included, and Excluding Overtime to Exclued 

Select Distinct(Overtime),
CASE When Overtime = 'Including overtime' Then 'Included'
	 When Overtime = 'Excluding overtime' Then 'Excluded'
	 Else Overtime
	 End
from PortfolioProject..WeeklyEarning

Update PortfolioProject..WeeklyEarning
Set Overtime = 
CASE When Overtime = 'Including overtime' Then 'Included'
	 When Overtime = 'Excluding overtime' Then 'Excluded'
	 Else Overtime
	 End;


--Delete unused columns
Alter Table PortfolioProject..WeeklyEarning
Drop Column UOM, UOM_ID, SCALAR_ID, VECTOR, SYMBOL, DECIMALS, INDUSTRY

