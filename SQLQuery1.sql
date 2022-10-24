--calling table
use nashvilleHousing

select * 
from housing


--standardize date format

select SaleDate, newSaleDate 
from housing

alter table housing
add newSaleDate date

update housing
set newSaleDate = convert(date,SaleDate) 

--populate the property address field

select  a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from housing a
join housing b 
on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where b.PropertyAddress is null

update b
set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from housing a
join housing b 
on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where b.PropertyAddress is null

-- breaking address into different coulumns

select *
from housing

--property address

select 
PARSENAME(REPLACE(PropertyAddress,',','.'),2),
PARSENAME(REPLACE(PropertyAddress,',','.'),1)
from housing

alter table housing
add property_address_street nvarchar(250),
	property_address_city nvarchar(250)

update housing
set property_address_street = PARSENAME(REPLACE(PropertyAddress,',','.'),2),
	property_address_city = PARSENAME(REPLACE(PropertyAddress,',','.'),1)


	--owner address

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3) street,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) city,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) states
from housing

alter table housing
add owner_street nvarchar(250),
	owner_city nvarchar(250),
	owner_State nvarchar(250)

update housing
set owner_street = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	owner_city = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	owner_state = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


	-- validate the SoldAsVacant column

select SoldAsVacant,COUNT(SoldAsVacant)
from housing
group by SoldAsVacant
order by SoldAsVacant

select SoldAsVacant,
case when SoldAsVacant ='Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from housing

update housing
set SoldAsVacant = 
	case when SoldAsVacant ='Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end


--REMOVE UNUSED COLUMNS

SELECT *
from housing

alter table housing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate