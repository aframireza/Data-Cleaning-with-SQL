/*
CLEANING DATA WITH SQL QUERIES
*/


SELECT *
FROM NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize date format by selecting the SaleDateConverted column and converting the SaleDate column to DATE datatype.
SELECT SaleDateConverted
	,CONVERT(DATE,SaleDate)
FROM NashvilleHousing

-- Update the SaleDate column in the NashvilleHousing table with the new date format.
UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate)

-- If the update doesn't work properly, add a new column called SaleDateConverted with DATE datatype to the NashvilleHousing table
ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

-- Update the SaleDateConverted column with the converted values from the SaleDate column in the NashvilleHousing table.
UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
SELECT *
FROM NashvilleHousing
--Where PropertyAddress is null
ORDER BY ParcelID

-- This SQL query selects ParcelID and PropertyAddress columns from two instances of the NashvilleHousing table (aliased as 'a' and 'b'). 
-- It then uses a JOIN operation to combine rows where the ParcelID matches but the UniqueID values are different.
-- The ISNULL function compares the PropertyAddress from 'a' and 'b' tables, selecting the non-null value.
-- Finally, it filters the results to include only rows where the PropertyAddress in table 'a' is NULL.
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
	JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- Update the PropertyAddress column in table 'a' with the non-null value from either table 'a' or 'b' where PropertyAddress in table 'a' is NULL.
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

-- This SQL query selects a substring of the PropertyAddress column before the first comma (',') as 'Address', 
-- and another substring of the PropertyAddress column starting from after the first comma as 'Address'.
SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address
	,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) AS Address
FROM NashvilleHousing

-- Add a new column called PropertySplitAddress with NVARCHAR(255) datatype to the NashvilleHousing table.
ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

-- Update the PropertySplitAddress column with the substring of PropertyAddress before the first comma (',').
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

-- Add a new column called PropertySplitCity with NVARCHAR(255) datatype to the NashvilleHousing table.
ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

-- Update the PropertySplitCity column with the substring of PropertyAddress starting from after the first comma (',').
UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


SELECT *
FROM NashvilleHousing


SELECT OwnerAddress
FROM NashvilleHousing

-- This SQL query selects three parts of the OwnerAddress column after replacing commas with dots ('.') and then parsing each part using PARSENAME function.
-- The third part represents the address, the second part represents the city, and the first part represents the state.
SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
	,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
	,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM NashvilleHousing


-- Add a new column called OwnerSplitAddress with NVARCHAR(255) datatype to the NashvilleHousing table.
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

-- Update the OwnerSplitAddress column with the third part of the parsed OwnerAddress after replacing commas with dots ('.').
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

-- Add a new column called OwnerSplitCity with NVARCHAR(255) datatype to the NashvilleHousing table.
ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

-- Update the OwnerSplitCity column with the second part of the parsed OwnerAddress after replacing commas with dots ('.').
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

-- Add a new column called OwnerSplitState with NVARCHAR(255) datatype to the NashvilleHousing table.
ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

-- Update the OwnerSplitState column with the first part of the parsed OwnerAddress after replacing commas with dots ('.').
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


SELECT *
FROM NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- This SQL query selects distinct values of the SoldAsVacant column and counts the occurrences of each distinct value.
-- The results are grouped by SoldAsVacant and ordered by the count of occurrences in ascending order.
SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- This SQL query selects the SoldAsVacant column from the NashvilleHousing table and uses a CASE statement to replace 'Y' with 'Yes', 'N' with 'No', and keeps other values unchanged.
SELECT SoldAsVacant
	,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	END
FROM NashvilleHousing

-- Update the SoldAsVacant column in the NashvilleHousing table, replacing 'Y' with 'Yes', 'N' with 'No', and keeping other values unchanged using a CASE statement.
UPDATE NashvilleHousing
SET SoldAsVacant 
	=CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END



	   
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
-- This SQL query uses a Common Table Expression (CTE) named RowNumCTE to assign row numbers to each row based on certain criteria using the ROW_NUMBER() function.
-- The PARTITION BY clause defines the groups of rows, and the ORDER BY clause specifies the order of rows within each group.
-- It then selects all columns from the RowNumCTE where the row number is greater than 1, indicating duplicate rows.
-- The final result is ordered by the PropertyAddress column.
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM NashvilleHousing
--order by ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress



SELECT *
FROM NashvilleHousing


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM NashvilleHousing

-- This SQL statement alters the NashvilleHousing table to drop the columns OwnerAddress, TaxDistrict, PropertyAddress, and SaleDate.
ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

