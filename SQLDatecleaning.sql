/*
Cleaning data in SQL Queries
/*

select *
from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------

--standardize Date Format

select SaleDate, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing 
add saleDateConverted Date


Update NashvilleHousing
set saleDateConverted = CONVERT(Date, SaleDate)


select saleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing



---------------------------------------------------------------------------------------------------------

--Populate Property Address Data

select *
from PortfolioProject.dbo.NashvilleHousing
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
   on a.ParcelID = b.ParcelID
   AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
   on a.ParcelID = b.ParcelID
   AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


-----------------------------------------------------------------------------------------------------------


-- Breaking out Address into Individual Columns (Address, City, State)


select PropertyAddress
from Portfolioproject.dbo.NashvilleHousing 

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM Portfolioproject.dbo.NashvilleHousing 


ALTER TABLE NashvilleHousing 
add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)



ALTER TABLE NashvilleHousing 
add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


select *
FROM Portfolioproject.dbo.NashvilleHousing 





select OwnerAddress
FROM Portfolioproject.dbo.NashvilleHousing


select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Portfolioproject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing 
add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)



ALTER TABLE NashvilleHousing 
add OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)




ALTER TABLE NashvilleHousing 
add OwnerSplitstate Nvarchar(255)

Update NashvilleHousing
set OwnerSplitstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


select * 
FROM Portfolioproject.dbo.NashvilleHousing 


-----------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field


select Distinct(SoldAsVacant), Count(SoldAsVacant)
from Portfolioproject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
CASE when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
from Portfolioproject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END


---------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				     UniqueID
					 ) row_num
from Portfolioproject.dbo.NashvilleHousing
)
DELETE 
from RowNumCTE
WHERE row_num > 1
--order by PropertyAddress 



WITH RowNumCTE AS(
select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				     UniqueID
					 ) row_num
from Portfolioproject.dbo.NashvilleHousing
)
SELECT *
from RowNumCTE
WHERE row_num > 1
order by PropertyAddress 




-------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



select * 
FROM Portfolioproject.dbo.NashvilleHousing 

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 


ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate












