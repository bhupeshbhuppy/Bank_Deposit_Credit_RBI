*******
import delimited E:\Study\Sem4_Project\RBI\data.csv
replace bankgroup= "NATIONALISED BANKS" if  bankgroup == "SBI AND ITS ASSOCIATES"
keep if bankgroup == "NATIONALISED BANKS" || bankgroup == "PRIVATE SECTOR BANKS"
egen qdepositsum = sum(deposit), by( districtcode bankgroup fiscalquarter )
gen logqdepositsum = log( qdepositsum )
sort districtcode bankgroup fiscalquarter
by districtcode bankgroup : gen growth = logqdepositsum - logqdepositsum[_n-1]

**generating Growth Q a
egen growth_actual = sum( growth ), by( districtcode bankgroup fiscalquarter )


** tercile generation Q b
xtile tercile = growth_actual if bankgroup == "PRIVATE SECTOR BANKS" , nq(3)
egen tercile_actual = max( tercile ), by( districtcode fiscalquarter )
drop if fiscalquarter=="2008-09:Q4"
gen tercile_panic = 1 if tercile_actual == 1
replace tercile_panic = 0 if tercile_panic == .
label define panic 1 "panic outflows" 0 "no panic outflows"
label values tercile_panic panic
encode fiscalquarter , generate( fiscalquarter_)

** Mean Q c
tab bankgroup tercile_actual, summarize( growth_actual ) mean

** plots Q d
twoway (scatter growth_actual districtcode), by( bankgroup tercile_panic )

** heat map Qe part 3 for all banks
twoway contour districtcode growth_actual fiscalquarter_

***** Q g part 2
egen qcreditsum = sum(credit), by( districtcode bankgroup fiscalquarter )
gen logqcreditsum = log( qcreditsum )
sort districtcode bankgroup fiscalquarter
by districtcode bankgroup : gen growth_cr = logqcreditsum - logqcreditsum[_n-1]
egen growth_cr_actual = sum( growth_cr ), by( districtcode bankgroup fiscalquarter )
twoway (scatter growth_cr_actual districtcode), by( bankgroup tercile_panic )
