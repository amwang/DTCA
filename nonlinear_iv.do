/***
nonlinear_iv.do

code for running nonlinear 2sls regressions for discounted dtc sums
***/

use BRFSS_full, clear
local ctrl age Male His Black HSless HSgrad Somecol Colgrad work income1 income2 income3 income4 income5 income6 income7 income8 married heightin weightlb
local d1 i.year
local d2 i.year i.dmacode
local wgt [aw=smplwgt]
local opt cluster(dmacode)
drop if checkup1yr==.

gen drop =(age==.)|(Male==.)|(His==.)|(Black==.)|(HSless==.)|(HSgrad==.)|(Somecol==.)|(Colgrad==.)|(work==.)|(income1==.)|(income2==.)|(income3==.)|(income4==.)|(income5==.)|(income6==.)|(income7==.)|(income8==.)|(married==.)|(heightin==.)|(weightlb==.)
gen drop_var=(tv_hat==.)|(ltv_hat==.)|(l2tv_hat==.)|(mag_hat==.)|(lmag_hat==.)|(l2mag_hat==.)

tabulate dmacode, gen(dma)
tabulate year, gen(yr)

#delimit ;
gmm (checkup1yr - {b0} - 
	{xb: age Male His Black HSless HSgrad Somecol Colgrad work income1 
		income2 income3 income4 income5 income6 income7 income8 married heightin weightlb dma* yr*} - 
	{b1}*(tv_hat+{d}*ltv_hat+{d}^2*l2tv_hat) -
	{b2}*(mag_hat+{e}*lmag_hat+{e}^2*l2mag_hat)) [aw=smplwgt], 
	instruments(age Male His Black HSless HSgrad Somecol Colgrad work 
		income1 income2 income3 income4 income5 income6 income7 income8 married heightin weightlb dma* yr* 
		tv_cpm ltv_cpm l2tv_cpm news_cpm lnews_cpm l2news_cpm) 
	onestep vce(cluster dmacode)