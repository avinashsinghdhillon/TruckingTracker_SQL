-- create a CTE to get the IFTA miles
with fuelDetail as
(
select
	LoadNumber,
	FuelingState,
	sum(FuelVolume) as 'Volume',
	sum(FuelCost) as 'Cost'
from
	FuelDetails
group by
	LoadNumber,
	FuelingState
),
--select * from fuelDetail order by LoadNumber, FuelingState
MilesDetails as
(
select
	LoadNumber,
	State,
	MilesForState
from
	MileageDetails
),
--select * from MilesDetails
res as
(
select
	m.LoadNumber,
	m.State,
	m.MilesForState,
	f.Volume,
	f.cost
from
	MilesDetails m
	left outer join fuelDetail f on m.LoadNumber = f.LoadNumber and m.State = f.FuelingState
)--select * from res
select
	r.[State],
	SUM(milesForState) as 'Miles',
	SUM(Volume) as 'Gallons',
	rate
from
	res r
	join IFTATaxRates i on r.State = i.state
where
	LoadNumber in ('1089', '1090', '1092', '1093')
group by
	r.[State],
	rate
order by 
	r.[State]
	
