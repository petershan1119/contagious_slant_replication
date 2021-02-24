* Build dataset for alternative matching


cls
clear

* Set wd
cd "/Users/philine/Desktop/newslibrary_project/data/"

* Read in and clean string-based matches by Matteo
use "newspaper_county_link/newspaper_county.dta", clear
duplicates drop source county, force
keep state source county
replace source = lower(source)
drop if mi(source)
replace source = trim(source)
sort source
save "newspaper_county_matteo.dta", replace

* Read in original source list from Newslibrary and merge with Matteo's string-based results
import delimited "complete_source_list.csv", encoding(ISO-8859-1) clear
sort source
merge source using "newspaper_county_matteo.dta"
gen str_base_county_match = 0 if mi(county)
replace str_base_county_match = 1 if str_base_county_match == .
drop _merge
save "sources_counties.dta", replace

* Merge with Wikipedia search-based results
import excel "newspaper_county_link/web_search_190925.xls", sheet("Sheet1") firstrow clear
sort source
save "newspaper_county_link/web_search_190925.dta", replace
use "sources_counties.dta", clear
replace source = "conexión (san antonio, tx)" if source == "conexiÃ³n (san antonio, tx)"
sort source
merge source using "newspaper_county_link/web_search_190925.dta"
tab _merge
drop _merge
* replace county = county_web1 if (county == "") & (county_web1 != "")
replace source = "la cañada valley sun (la cañada flintridge, ca)" if source == "la caÃ±ada valley sun (la caÃ±ada flintridge, ca)"
* export excel using "unmatched_sources_191002.xls", firstrow(variables) replace
sort source
save "regression_data.dta", replace

* Import sources from US Newspaper Directory
import excel "to_match_with_us_np_directory_191012.xls", sheet("Sheet1") firstrow clear
foreach v in source source2 county comments {
replace `v' = lower(`v')
}
rename county county_string
replace county_string = strtrim(county_string)
rename state stateabbrev
replace stateabbrev = strtrim(stateabbrev)
rename source source_newslib
rename source2 source
gen slen = length(source)
drop if slen < 1
duplicates tag source, gen(dup)
keep if dup == 0
gen n = 4
expand n
drop n
bysort source: gen n = _n
sum n
gen year = 2004 + n
sum year
drop dup slen n
sort stateabbrev county_string year
save "np_directory.dta", replace
merge stateabbrev county_string year using "county_level_nielsen/county+rating2005-2008.dta", nokeep
tab county_string if _merge == 1
keep if _merge == 3
duplicates drop source_newslib, force
keep source_newslib county_string stateabbrev
rename source_newslib source
rename county_string county_npdir
rename stateabbrev state_npdir
label var county_npdir "county according to us newspaper library"
label var state_npdir "state according to us newspaper library"
gen npdir_county_match = 1
sort source
save "np_directory_to_merge.dta", replace

* Merge outlets from source list with NP directory results
use "regression_data.dta", clear
sort source
merge source using "np_directory_to_merge.dta"
tab _merge
replace npdir_county_match = 0 if mi(npdir_county_match)
drop _merge

* Check the coverage we got with web search 1 and NP directory
replace county = county_npdir if npdir_county_match == 1
replace state = state_npdir if mi(state) & npdir_county_match == 1
replace county = county_web1 if (county == "") & (county_web1 != "")
replace source = "la estrella de tucson (az)" if source == "la estrella de tucsÃ³n (az)"
replace source = "al dia (dallas, texas)" if source == "al dÃ­a (dallas, texas)"
replace source = "la canada flintridge weekly (ca)" if source == "la caÃ±ada flintridge weekly (ca)"
replace source = "conde nast traveler" if source == "condÃ© nast traveler"
save "regression_data.dta", replace

* Merge with web search 2 results
import excel "web_search_191017.xls", sheet("for_web_search_191013") firstrow clear
keep source county state
replace source = lower(source)
replace county = lower(county)
replace source = strtrim(source)
replace county = strtrim(county)
replace state = strtrim(state)
rename county county_web_search2
rename state state_web_search2
sort source
save "web_search2_191018.dta", replace

use "regression_data.dta", clear
sort source
merge source using "web_search2_191018.dta"
tab _merge
replace county = county_web_search2 if mi(county)
replace state = state_web_search2 if mi(state)
replace web_base_county_match = 1 if _merge == 3 & county_web_search2 != ""
drop _merge state_web_search2 county_web_search2

* Manual correction of errors
replace state = "SC" if source == "journal, the (williamston,  sc)"
replace state = "PR" if state == "PU"
replace county = "district of columbia" if state == "DC"
replace county = "loudoun" if source == "middleburg life (arlington, va)"
replace county = "arlington" if source == "northern virginia parent life (arlington, va)"
replace county = "arlington" if source == "usa today (arlington, va)"
replace county = "bolivar" if source == "bolivar commercial, the (cleveland, ms)"
replace county = "bolivar" if source == "delta statement, the: delta state university (cleveland, ms)"
replace county = "davidson" if source == "dispatch, the (lexington, nc)"

duplicates report source

duplicates drop source, force

save "alternative_matching.dta", replace
