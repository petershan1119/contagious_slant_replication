* Compare counties between both matching approaches

**************************************************
* Load data and prepare variables
**************************************************
clear
cd /Users/philine/Dropbox/contagious_slant/

use "data/alternative_matching_counties_to_compare.dta"
keep source county state
rename county county_alternative
rename state state_alternative
rename source source_nb
sort source_nb
save "data/alternative_matching_counties_to_compare_using.dta", replace

clear
import excel "/Users/philine/Desktop/newslibrary_project/data/main_model_no_filtering_regression_data.xls", sheet("Sheet1") firstrow

rename source_mic source
rename circ_mic circ
rename n no_articles
gen fips_county=fips

sort source_nb
merge source_nb using "data/alternative_matching_counties_to_compare_using.dta"

keep if county_mic == own_county_mic
