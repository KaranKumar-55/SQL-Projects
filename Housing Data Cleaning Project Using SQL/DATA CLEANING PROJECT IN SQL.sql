/*
Data Cleaning Using SQL Queries

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDate, CONVERT(DATE, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE, SaleDate)







ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date



UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate)

SELECT SaleDateConverted, CONVERT(DATE, SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing


----------------------------------------------------------------------------------------


-- Populate Property Address data

SELECT *--PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is Null
ORDER BY ParcelID



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


----------------------------------------------------------------------------------------

--Breaking out Address into individual Columns (Address, City , State)


SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',  PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',  PropertyAddress) + 1, LEN(PropertyAddress)) as City

FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(250)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(250)


UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',  PropertyAddress) -1)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',  PropertyAddress) + 1, LEN(PropertyAddress))





SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(250)


UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(250)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(250)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


----------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" Field



SELECT DISTINCT(SoldAsVacant) , COUNT(SoldAsVacant) 
FROM PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant=CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

		
----------------------------------------------------------------------------------------

--Remove Duplicates

With RowNumCTE AS (
SELECT * ,
ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY
		UniqueID
		) row_num

FROM PortfolioProject.dbo.NashvilleHousing
)

--DELETE
--FROM RowNumCTE
--Where row_num > 1

SELECT * 
FROM RowNumCTE
Where row_num > 1
Order by PropertyAddress



		
----------------------------------------------------------------------------------------

--Deleted unused Columns

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing




ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate




