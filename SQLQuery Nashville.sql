--cleaning data in sql queries

select *
from NashvilleHousing


---standardize data format

select SaleDateConverted,CONVERT(date,saledate) as SaleDateOnly
from NashvilleHousing

update NashvilleHousing
set SaleDate=CONVERT(date,saledate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

update NashvilleHousing
set SaleDateConverted=CONVERT(date,saledate)

---populate Property Address date

select PropertyAddress
from NashvilleHousing
where PropertyAddress is null

select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select *
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out address int columns (address,city,states)

select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

---Using substrings to remove delimiter and creater a character index

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as address

from NashvilleHousing


--Creating a new table to join for the address

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as address

from NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

update NashvilleHousing
set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255)

update NashvilleHousing
set PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select*
from NashvilleHousing

--Splitting the owner address using another method instead of substring

select owneraddress
from NashvilleHousing

select
PARSENAME(Replace(owneraddress,',','.'),3) as address
, PARSENAME(Replace(owneraddress,',','.'),2) as city
, PARSENAME(Replace(owneraddress,',','.'),1) as state
from NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress=PARSENAME(Replace(owneraddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

update NashvilleHousing
set OwnerSplitCity=PARSENAME(Replace(owneraddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255)

update NashvilleHousing
set OwnerSplitState=PARSENAME(Replace(owneraddress,',','.'),1)


select*
from NashvilleHousing

--change Y and N to Yes and No in Sold as vacant using a Csse statement


select DISTINCT(soldasvacant), count(soldasvacant)
from NashvilleHousing
group by soldasvacant
order by 2

select soldasvacant
, case when SoldAsVacant='y' then 'Yes'
		when soldasvacant='N' then 'No'
		else soldasvacant
		End
from NashvilleHousing


update NashvilleHousing
set soldasvacant=case when SoldAsVacant='y' then 'Yes'
		when soldasvacant='N' then 'No'
		else soldasvacant
		End
--Test run

select DISTINCT(soldasvacant), count(soldasvacant)
from NashvilleHousing
group by soldasvacant
order by 2




--Removing duplicates by writing a CTE and create a partition of the data


WITH RowNumCTE as(
select *,
ROW_NUMBER () OVER (
partition by parcelid, propertyaddress, saleprice, saledate, legalreference order by uniqueID) row_num
from NashvilleHousing)
---order by parcelid
---where row_num >1

select *
from RowNumCTE
where row_num >1
order by PropertyAddress

--To delete dublicates

WITH RowNumCTE as(
select *,
ROW_NUMBER () OVER (
partition by parcelid, propertyaddress, saleprice, saledate, legalreference order by uniqueID) row_num
from NashvilleHousing)
---order by parcelid
---where row_num >1

delete
from RowNumCTE
where row_num >1
--order by PropertyAddress

--To test--Confirmed duplicates deleted

WITH RowNumCTE as(
select *,
ROW_NUMBER () OVER (
partition by parcelid, propertyaddress, saleprice, saledate, legalreference order by uniqueID) row_num
from NashvilleHousing)
---order by parcelid
---where row_num >1

select *
from RowNumCTE
where row_num >1
order by PropertyAddress

select *
from NashvilleHousing

--Delete unused columns

select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN owneraddress,taxdistrict, propertyaddress

ALTER TABLE NashvilleHousing
DROP COLUMN saledate