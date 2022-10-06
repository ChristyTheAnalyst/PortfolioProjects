
--Cleaning Nashville Housing Data using SQL queries

select *
from SQL_Portfoliio_Projects..NashvilleHousingData

--Standardizing SaleDate format

select SaleDate, CONVERT(Date, SaleDate)
from SQL_Portfoliio_Projects..NashvilleHousingData

update SQL_Portfoliio_Projects..NashvilleHousingData
set SaleDate = CONVERT(Date, SaleDate)

alter table SQL_Portfoliio_Projects..NashvilleHousingData
add SaleDateConverted Date

update SQL_Portfoliio_Projects..NashvilleHousingData
set SaleDateConverted = CONVERT(Date, SaleDate)

select SaleDateConverted, CONVERT(Date, SaleDate)
from SQL_Portfoliio_Projects..NashvilleHousingData

--Populate property address

select *
from SQL_Portfoliio_Projects..NashvilleHousingData
where PropertyAddress is null

select *
from SQL_Portfoliio_Projects..NashvilleHousingData
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from SQL_Portfoliio_Projects..NashvilleHousingData a
join SQL_Portfoliio_Projects..NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from SQL_Portfoliio_Projects..NashvilleHousingData a
join SQL_Portfoliio_Projects..NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from SQL_Portfoliio_Projects..NashvilleHousingData a
join SQL_Portfoliio_Projects..NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out address into individual columns (Address, City, State)

select PropertyAddress
from SQL_Portfoliio_Projects..NashvilleHousingData

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
		SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
from SQL_Portfoliio_Projects..NashvilleHousingData

alter table SQL_Portfoliio_Projects..NashvilleHousingData
--drop column PropertySplitAddress
add PropertySplitAddress nvarchar(255)

update SQL_Portfoliio_Projects..NashvilleHousingData
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table SQL_Portfoliio_Projects..NashvilleHousingData
add PropertySplitCity nvarchar(255)

update SQL_Portfoliio_Projects..NashvilleHousingData
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

select PropertySplitAddress, PropertySplitCity
from SQL_Portfoliio_Projects..NashvilleHousingData

select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
		PARSENAME(REPLACE(OwnerAddress,',','.'),2),
		PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from SQL_Portfoliio_Projects..NashvilleHousingData

alter table SQL_Portfoliio_Projects..NashvilleHousingData
add OwnerSplitAddress nvarchar(255)

update SQL_Portfoliio_Projects..NashvilleHousingData
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

alter table SQL_Portfoliio_Projects..NashvilleHousingData
add OwnerSplitCity nvarchar(255)

update SQL_Portfoliio_Projects..NashvilleHousingData
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

alter table SQL_Portfoliio_Projects..NashvilleHousingData
add OwnerSplitState nvarchar(255)

update SQL_Portfoliio_Projects..NashvilleHousingData
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select *
from SQL_Portfoliio_Projects..NashvilleHousingData

--Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from SQL_Portfoliio_Projects..NashvilleHousingData
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from SQL_Portfoliio_Projects..NashvilleHousingData

update SQL_Portfoliio_Projects..NashvilleHousingData
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant
						end

select distinct(SoldAsVacant), count(SoldAsVacant)
from SQL_Portfoliio_Projects..NashvilleHousingData
group by SoldAsVacant
order by 2

--Removing Duplicates

with RowNumCTE as (
select *, ROW_NUMBER() over (
		partition by ParcelID,
					 PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference
		order by UniqueID) row_num
from SQL_Portfoliio_Projects..NashvilleHousingData
--order by ParcelID
)
select *
from RowNumCTE
where row_num >1

with RowNumCTE as (
select *, ROW_NUMBER() over (
		partition by ParcelID,
					 PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference
		order by UniqueID) row_num
from SQL_Portfoliio_Projects..NashvilleHousingData
--order by ParcelID
)
delete
from RowNumCTE
where row_num >1

with RowNumCTE as (
select *, ROW_NUMBER() over (
		partition by ParcelID,
					 PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference
		order by UniqueID) row_num
from SQL_Portfoliio_Projects..NashvilleHousingData
)
select *
from RowNumCTE
where row_num >1

--Delete unused columns

select *
from SQL_Portfoliio_Projects..NashvilleHousingData

alter table SQL_Portfoliio_Projects..NashvilleHousingData
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table SQL_Portfoliio_Projects..NashvilleHousingData
drop column SaleDate

select *
from SQL_Portfoliio_Projects..NashvilleHousingData
