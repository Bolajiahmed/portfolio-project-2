SELECT * FROM projectb.`nashville housing data`;
select*
from projectb.`nashville housing data`;

describe projectb.`nashville housing data`;

----standardise date;
select SaleDate, str_to_date(SaleDate,"%M%d,%Y") as SellingDate
from projectb.`nashville housing data`;

alter table projectb.`nashville housing data`
add sellingDate date;

update projectb.`nashville housing data`
set SellingDate = str_to_date(SaleDate,"%M%d,%Y");

select sellingDate
from projectb.`nashville housing data`;

--populating the property address; mine has no null
select ParcelID,propertyAddress
from projectb.`nashville housing data`
where propertyAddress is not null;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.propertAddress,b.propertyAddress)
from projectb.`nashville housing data` a
join projectb.`nashville housing data`b
on a. ParcelId = b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is not null;

update a
set propertyAddress= isnull(a.propertyAddress,b.propertyAddress)
from projectb.`nashville housing data` a
join projectb.`nashville housing data`b
on a. ParcelId = b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null;

--breaking address into individual column;
select substring_index(propertyAddress,",",1) as address
from projectb.`nashville housing data`;

select substring_index(propertyAddress,",",-1) as Address2
from projectb.`nashville housing data`;

alter table projectb.`nashville housing data`
add Address nvarchar(255);

alter table projectb.`nashville housing data`
add Address2 nvarchar(255);

update projectb.`nashville housing data`
set Address=substring_index(propertyAddress,",",1);

update projectb.`nashville housing data`
set Address2=substring_index(propertyAddress,",",-1);

select address, address2
from projectb.`nashville housing data`;

select ownerAddress
from projectb.`nashville housing data`;

select
substring_index(ownerAddress,",",1) as HomeAddress,
substring_index(substring_index(ownerAddress,",",2),",",-1) as HomeAddress2,
substring_index(ownerAddress,",",-1) as HomeAddress3
from projectb.`nashville housing data`;

alter table projectb.`nashville housing data`
add HomeAddress nvarchar(255);

alter table projectb.`nashville housing data`
add HomeAddress2 nvarchar(255);

alter table projectb.`nashville housing data`
add HomeAddress3 nvarchar(255);

update projectb.`nashville housing data`
set HomeAddress = substring_index(ownerAddress,",",1);
update projectb.`nashville housing data`
set HomeAddress2 = substring_index(substring_index(ownerAddress,",",2),",",-1);
update projectb.`nashville housing data`
set HomeAddress3 = substring_index(ownerAddress,",",-1);

select HomeAddress, HomeAddress2, HomeAddress3
from projectb.`nashville housing data`;

--changing y and n to yes and no;

select distinct(SoldAsVacant), count(SoldAsVacant)
from projectb.`nashville housing data`
group by 1
order by 2;

select SoldAsVacant,
case 
	when soldasvacant = "y" then "Yes"
    when soldasvacant = "N" then "No"
    else soldasvacant
end
from projectb.`nashville housing data`;

update projectb.`nashville housing data`
set soldasvacant=case 
	when soldasvacant = "y" then "Yes"
    when soldasvacant = "N" then "No"
    else soldasvacant
end;

select distinct(soldasvacant), count(soldasvacant)
from projectb.`nashville housing data`
group by 1
order by 2;

---removing duplicate;
with rowNum as (
select*,
	Row_Number() OVER ( 
    Partition by parcelid,PropertyAddress,SalePrice,legalReference
		order by uniqueid) row_num
from projectb.`nashville housing data`)

delete
from rowNum
where rowNum>1
order by PropertyAddress;


---delete unused column;
select*
from projectb.`nashville housing data`;

alter table projectb.`nashville housing data`
drop column ownerAddress;
alter table projectb.`nashville housing data`
drop column PropertyAddress;
alter table projectb.`nashville housing data`
drop column TaxDistrict;
alter table projectb.`nashville housing data`
drop column SaleDate;

 