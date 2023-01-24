In this project, housing data of city Nashville of USA is transformed in SQL server to make it more usable for analysis.

Link to Dataset: **[Github_Link](https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx)**

SQL File name: **[NashvilleHousingDataPortfolioProject.sql](https://github.com/ChristyTheAnalyst/PortfolioProjects/blob/main/Data_Cleaning_Using_SQL/NashvilleHousingDataPortfolioProject.sql)**

# Tasks Involved
- Standardizing **SaleDate** format
- Populate property address data
- Breaking out address into individual columns (Address, City, State)
- Change Y to **Yes** and N to **No** in "Sold as Vacant" field
- Remove Duplicates
- Delete unused columns

# SQL Server Functions Used
- CONVERT()
- ISNULL()
- SUBSTRING()
- CHARINDEX()
- LEN()
- PARSENAME()
- REPLACE()
- COUNT()
- ROW_NUMBER()

# Challenges
- Finding relation between the columns ParcelID and PropertyAddress to populate the address
- Using self **JOIN** to update the table
- Using **CTE**s (Common Table Expressions) and **Window functions** to remove duplicates
