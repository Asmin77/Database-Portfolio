
-------------------------------------------------------------------------------------
--Standardize Date format



select SaleDateconverted , convert(date,saledate) from NashvielleHousing


alter table nashviellehousing
add SaleDateConverted Date;

 update NashvielleHousing
 set saledateconverted=convert(date, saledate)


 -----------------------------------------------------------------------------------------------------



--breaking out address into individual columns(address, city, state)

select Propertyaddress from NashvielleHousing

select
substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)as Address
,substring(PropertyAddress,charindex(',',PropertyAddress)+1, len(propertyaddress))as Address
from NashvielleHousing

alter table nashviellehousing
add PropertySplitAddress Nvarchar(250)

update nashviellehousing
set propertysplitaddress=substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)

alter table nashviellehousing
add PropertySplitCity Nvarchar(255)

update NashvielleHousing
set propertysplitcity=substring(PropertyAddress,charindex(',',PropertyAddress)+1, len(propertyaddress))

select 
parsename(REPLACE(owneraddress, ',' , '.' ),3)
,parsename(REPLACE(owneraddress, ',' , '.' ),2)
,parsename(REPLACE(owneraddress, ',' , '.' ),1)
from NashvielleHousing

alter table nashviellehousing
add OwnersplitAddress Nvarchar(250)
update NashvielleHousing
set Ownersplitaddress=parsename(REPLACE(owneraddress, ',' , '.' ),3)

alter table nashviellehousing
add  OwnersplitCity Nvarchar(250)
update NashvielleHousing
set Ownersplitcity=parsename(REPLACE(owneraddress, ',' , '.' ),2)

alter table nashviellehousing
add  OwnersplitState Nvarchar(250)
update NashvielleHousing
set Ownersplitstate=parsename(REPLACE(owneraddress, ',' , '.' ),1)


------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in 'Sold as Vacant' field

select distinct(soldasvacant), count(soldasvacant)
from NashvielleHousing
group by soldasvacant
order by 2

select soldasvacant
,case when soldasvacant='y' then 'Yes'
	  when soldasvacant ='n' then 'No'
	  else soldasvacant
	  end
from NashvielleHousing

update NashvielleHousing
set soldasvacant=case when soldasvacant='y' then 'Yes'
	  when soldasvacant ='n' then 'No'
	  else soldasvacant
	  end

-----------------------------------------------------------------------------------

--Remove Duplicates

with RowNumCTE AS(
select *,
	row_number() over(
	partition by parcelid,
				 propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 order by
					uniqueid
					) row_num
from NashvielleHousing
--order by ParcelID
)
select *from rownumcte
where row_num>1
order by ParcelID

------------------------------------------------------------------------------


--Delete Unused Columns

select *from NashvielleHousing

alter table nashviellehousing
drop column owneraddress, taxdistrict, propertyaddress

alter table nashviellehousing
drop column saledate