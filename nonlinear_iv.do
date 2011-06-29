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

reg tv tv_cpm `ctrl' i.year i.dmacode [aw=smplwgt], cluster(dmacode)
predict tv_hat
reg ltv ltv_cpm `ctrl' i.year i.dmacode [aw=smplwgt], cluster(dmacode)
predict ltv_hat
reg l2tv l2tv_cpm `ctrl' i.year i.dmacode [aw=smplwgt], cluster(dmacode)
predict l2tv_hat
reg mag news_cpm `ctrl' i.year i.dmacode [aw=smplwgt], cluster(dmacode)
predict mag_hat
reg lmag lnews_cpm `ctrl' i.year i.dmacode [aw=smplwgt], cluster(dmacode)
predict lmag_hat
reg l2mag l2news_cpm `ctrl' i.year i.dmacode [aw=smplwgt], cluster(dmacode)
predict l2mag_hat

#delimit ;
nl (checkup1yr = {b0} + {b1}*(tv_hat+{d}*ltv_hat+{d^2}*l2tv_hat)+
{b2}*(mag_hat+{e}*lmag_hat+{e^2}*l2mag_hat) + 
{c1}*age + {c2}*Male + {c3}*His + {c4}*Black + {c5}*HSless + {c6}*HSgrad + {c7}*Somecol + 
{c8}*Colgrad + {c9}*work + {c10}*income1 + {c11}*income2 + {c12}*income3 + {c13}*income4 + {c14}*income5 + 
{c15}*income6 + {c16}*income7 + {c17}*income8 + {c18}*married + 
{c19}*heightin + {c20}*weightlb ), vce(cluster dmacode) initial(d 1 e 1);

gen drop =(age==.)|(Male==.)|(His==.)|(Black==.)|(HSless==.)|(HSgrad==.)|(Somecol==.)|(Colgrad==.)|(work==.)|(income1==.)|(income2==.)|(income3==.)|(income4==.)|(income5==.)|(income6==.)|(income7==.)|(income8==.)|(married==.)|(heightin==.)|(weightlb==.)
gen drop_var=(tv_hat==.)|(ltv_hat==.)|(l2tv_hat==.)|(mag_hat==.)|(lmag_hat==.)|(l2mag_hat==.)

gmm (crime - policepc*{b1} - legalwage*{b2} - {b3}),
instruments(arrestp convictp legalwage) nolog oneste