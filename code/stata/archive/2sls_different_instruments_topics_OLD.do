**************************************************
* Load data and prepare variables
**************************************************
clear

cd /Users/philine/Dropbox/contagious_slant_replication/

 * Choose dataset
import delimited "data/regression_data/main_model_no_filtering_topics_regression_data.csv", encoding(ISO-8859-1)clear

rename source_mic source
rename circ_mic circ
rename n no_articles
gen fips_county=fips

* Define extension for files to be saved
local ext "topics"

* Threshold for number of articles
drop if no_articles < 1000

* Define clustering
local cluster_vars "fips_county id_news"

* Newspapers are uniquely identified by: source own_city_mic own_state_mic
egen id_news = group(source own_city_mic own_state_mic)
drop if mi(source)

rename words_avg article_length
* Available for language: vocab_size word_length_avg no_sentences word_count_total sent_length article_length no_articles
replace vocab_size = vocab_size/word_count_total
global language vocab_size word_length_avg sent_length article_length no_articles

collapse (mean) topic* word_count_total $language circ percent_fox fips county_pop weightedpos_cnn share_cnn rtgxx_county_cnn shr_county_cnn intab_county_cnn sow_county_cnn pos_cnn_county_repl weightedpos_fxnc share_fxnc rtgxx_county_fxnc shr_county_fxnc intab_county_fxnc sow_county_fxnc pos_fxnc_county_repl weightedpos_mnbc share_mnbc rtgxx_county_mnbc shr_county_mnbc sow_county_mnbc intab_county_mnbc pos_mnbc_county_repl weightedpos_nbc weightedpos_cbs weightedpos_abc weightedpos_fox share_nbc share_cbs share_abc share_fox share_fam weightedpos_fam share_aen weightedpos_aen share_amc weightedpos_amc share_apl weightedpos_apl share_bbca weightedpos_bbca share_bet weightedpos_bet share_bio weightedpos_bio share_brvo weightedpos_brvo share_toon weightedpos_toon share_cmt weightedpos_cmt share_cnbc weightedpos_cnbc share_cmdy weightedpos_cmdy share_tru weightedpos_tru share_disc weightedpos_disc share_dfh weightedpos_dfh share_dsny weightedpos_dsny share_diy weightedpos_diy share_ent weightedpos_ent share_espn weightedpos_espn share_espn2 weightedpos_espn2 share_escl weightedpos_escl share_enn weightedpos_enn share_food weightedpos_food share_gsn weightedpos_gsn share_golf weightedpos_golf share_hall weightedpos_hall share_hgtv weightedpos_hgtv share_hist weightedpos_hist share_h2 weightedpos_h2 share_lif weightedpos_lif share_lmn weightedpos_lmn share_ahc weightedpos_ahc share_mtv weightedpos_mtv share_mtv2 weightedpos_mtv2 share_ngsd weightedpos_ngsd share_nick weightedpos_nick share_outd weightedpos_outd share_oxyg weightedpos_oxyg share_syfy weightedpos_syfy share_sci weightedpos_sci share_soap weightedpos_soap share_spd weightedpos_spd share_spk weightedpos_spk share_tbsc weightedpos_tbsc share_tcm weightedpos_tcm share_tlc weightedpos_tlc share_tnt weightedpos_tnt share_tdsy weightedpos_tdsy share_trav weightedpos_trav share_tvl weightedpos_tvl share_twc weightedpos_twc share_usa weightedpos_usa share_vs weightedpos_vs share_vh1 weightedpos_vh1 share_we weightedpos_we pop_county_fxnc_no_mnbc pop_county_mnbc_no_fxnc pop_county_mnbc_and_fxnc share_fxnc_no_mnbc share_mnbc_no_fxnc share_mnbc_and_fxnc temp_share_cnn_25 share_cnn_25 temp_share_cnn_50 share_cnn_50 temp_share_cnn_75 share_cnn_75 temp_share_fxnc_25 share_fxnc_25 temp_share_fxnc_50 share_fxnc_50 temp_share_fxnc_75 share_fxnc_75 temp_share_mnbc_25 share_mnbc_25 temp_share_mnbc_50 share_mnbc_50 temp_share_mnbc_75 share_mnbc_75 pos_abc_fam_county_repl pos_ae_county_repl pos_amc_county_repl pos_animal_planet_county_repl pos_bbc_america_county_repl pos_bet_county_repl pos_bio_county_repl pos_bravo_county_repl pos_cartoon_network_county_repl pos_cmt_county_repl pos_cnbc_county_repl pos_comedy_central_county_repl pos_tru_county_repl pos_discovery_county_repl pos_dfh_county_repl pos_ic_county_repl pos_disney_county_repl pos_diy_county_repl pos_e_tv_county_repl pos_espn_county_repl pos_espn2_county_repl pos_espn_classic_county_repl pos_espn_news_county_repl pos_food_county_repl pos_fx_county_repl pos_gsn_county_repl pos_golf_county_repl pos_hallmark_county_repl pos_hgtv_county_repl pos_history_county_repl pos_h2_county_repl pos_lifetime_county_repl pos_lifetime_movie_county_repl pos_ahc_county_repl pos_mtv_county_repl pos_mtv2_county_repl pos_nat_geo_county_repl pos_nickelodeon_county_repl pos_outdoor_channel_county_repl pos_oxygen_county_repl pos_scifi_county_repl pos_science_county_repl pos_soapnet_county_repl pos_speed_county_repl pos_spike_county_repl pos_tbs_county_repl pos_tcm_county_repl pos_tlc_county_repl pos_tnt_county_repl pos_toon_disney_county_repl pos_travel_county_repl pos_tvland_county_repl pos_twc_county_repl pos_usa_county_repl pos_versus_county_repl pos_vh1_county_repl pos_we_county_repl fips_county, by(id_news county_mic state_mic)

global covs2000 pct_white_county pct_black_county pct_asian_county pct_other_county pct_hisp_county pct_male_county pct_female_county pct_age_0s_county pct_age_10s_county pct_age_20s_county pct_age_30s_county pct_age_40s_county pct_age_50s_county pct_age_60s_county pct_age_70s_county pct_age_80s_county pct_age_18up_county pct_urban_county pct_rural_county pct_nohs_county pct_hsgrad_county pct_somecollege_county pct_bach_county pct_postgrad_county pct_college_county inc_less_10k_county inc_10_15_county inc_15_20_county inc_20_25_county inc_25_30_county inc_30_35_county inc_35_40_county inc_40_45_county inc_45_50_county inc_50_60_county inc_60_75_county inc_75_100_county inc_100_125_county inc_125_150_county inc_150_200_county inc_200_plus_county landarea_county pop_dens_county
merge m:1 fips_county using "data/inputs/census/county_census2000", keepusing($covs2000) 
keep if _merge==3
merge m:1 fips_county using "data/inputs/census/county_census2010", keepusing(med_value_county) nogen
keep if _merge==3
merge m:1 fips_county using "data/inputs/census/county_income_gini2000", keepusing(mean_income gini) nogen
keep if _merge==3
merge m:1 fips_county using "data/inputs/census/county_occupation_sector2000", keepusing(management service sales farming construction production) nogen
keep if _merge==3
merge m:1 fips_county using "data/inputs/census/Pres_elec_1996_county", keepusing(share_rep1996) nogen
keep if _merge==3
merge m:1 fips_county using "data/inputs/census/Rep_pres_0016", nogen
keep if _merge==3

drop if rtgxx_county_fxnc==.
gen fips_state=int(fips_county/1000)
gen lpop_dens_county=log(pop_dens_county)
gen lmean_income=ln(mean_income)

global channel share_cnn share_fxnc share_mnbc
global covs_base county_pop share_rep1996 pct_white_county pct_black_county pct_asian_county pct_hisp_county pct_male_county pct_age_10s_county pct_age_20s_county pct_age_30s_county pct_age_40s_county pct_age_50s_county pct_age_60s_county pct_age_70s_county pct_age_80s_county pct_urban_county pct_hsgrad_county pct_somecollege_county pct_bach_county pct_postgrad_county landarea_county lpop_dens_county lmean_income gini management service sales farming construction 

gen instr_fox_msnbc=pos_mnbc_county_repl-pos_fxnc_county_repl
gen cons_fox_msnbc=rtgxx_county_fxnc-rtgxx_county_mnbc
gen instr_fox_cnn=pos_fxnc_county_repl-pos_cnn_county_repl
gen cons_fox_cnn=rtgxx_county_fxnc-rtgxx_county_cnn
gen instr_fox_cnn_msnbc=pos_fxnc_county_repl-((pos_cnn_county_repl+pos_mnbc_county_repl)/2)
gen cons_fox_cnn_msnbc=rtgxx_county_fxnc-((rtgxx_county_cnn+rtgxx_county_mnbc)/2)

egen SD_rtgxx_county_fxnc = sd(rtgxx_county_fxnc)
egen SD_rtgxx_county_cnn = sd(rtgxx_county_cnn)
egen SD_rtgxx_county_mnbc = sd(rtgxx_county_mnbc)
egen SD_percent_fox = sd(percent_fox)
egen SD_cons_fox_msnbc = sd(cons_fox_msnbc)
egen SD_cons_fox_cnn = sd(cons_fox_cnn)
egen SD_instr_fox_msnbc = sd(instr_fox_msnbc)
egen SD_instr_fox_cnn = sd(instr_fox_cnn)
egen SD_instr_fox_cnn_msnbc = sd(instr_fox_cnn_msnbc)
egen SD_cons_fox_cnn_msnbc = sd(cons_fox_cnn_msnbc)
egen SD_pos_fxnc_county_repl = sd(pos_fxnc_county_repl)
egen SD_pos_cnn_county_repl = sd(pos_cnn_county_repl)

gen St_rtgxx_county_fxnc = rtgxx_county_fxnc/SD_rtgxx_county_fxnc
gen St_rtgxx_county_cnn = rtgxx_county_cnn/SD_rtgxx_county_cnn
gen St_rtgxx_county_mnbc = rtgxx_county_mnbc/SD_rtgxx_county_mnbc
gen St_percent_fox = percent_fox/SD_percent_fox
gen St_cons_fox_msnbc = cons_fox_msnbc/SD_cons_fox_msnbc
gen St_cons_fox_cnn = cons_fox_cnn/SD_cons_fox_cnn
gen St_instr_fox_msnbc = instr_fox_msnbc/SD_instr_fox_msnbc
gen St_instr_fox_cnn = instr_fox_cnn/SD_instr_fox_cnn
gen St_cons_fox_cnn_msnbc = cons_fox_cnn_msnbc/SD_cons_fox_cnn_msnbc
gen St_instr_fox_cnn_msnbc = instr_fox_cnn_msnbc/SD_instr_fox_cnn_msnbc
gen St_pos_fxnc_county_repl = pos_fxnc_county_repl/SD_pos_fxnc_county_repl
gen St_pos_cnn_county_repl = pos_cnn_county_repl/SD_pos_cnn_county_repl

bys fips_county: gen dup=_n

**************************************************
* Include topics as controls
**************************************************

global topics topic0 topic1 topic2 topic3 topic4 topic5 topic6 topic7 topic8 topic9 topic10 topic11 topic12 topic13 topic14 topic15 topic16 topic17 topic18 topic19 topic20 topic21 topic22 topic23 topic24 topic25 topic26 topic27 topic28 topic29 topic30 topic31 topic32 topic33 topic34 topic35 topic36 topic37 topic38 topic39 topic40 topic41 topic42 topic43 topic44 topic45 topic46 topic47 topic48 topic49 topic50 topic51 topic52 topic53 topic54 topic55 topic56 topic57 topic58 topic59 topic60 topic61 topic62 topic63 topic64 topic65 topic66 topic67 topic68 topic69 topic70 topic71 topic72 topic73 topic74 topic75 topic76 topic77 topic78 topic79 topic80 topic81 topic82 topic83 topic84 topic85 topic86 topic87 topic88 topic89 topic90 topic91 topic92 topic93 topic94 topic95 topic96 topic97 topic98 topic99 topic100 topic101 topic102 topic103 topic104 topic105 topic106 topic107 topic108 topic109 topic110 topic111 topic112 topic113 topic114 topic115 topic116 topic117 topic118 topic119 topic120 topic121 topic122 topic123 topic124 topic125 topic126 topic127

* Which obs to include?
capture confirm variable in_main
if !_rc {
drop in_main
}
eststo clear
global controls $covs_base $channel $language 
ivreghdfe St_percent_fox (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars')
estadd scalar ftest=e(widstat)
eststo
rename _est_est1 in_main

* Run regressions for different instruments
eststo clear
global controls $covs_base $topics
ivreghdfe St_percent_fox (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
global controls $covs_base $channel $topics
ivreghdfe St_percent_fox (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
global controls $covs_base $channel $language $topics
ivreghdfe St_percent_fox (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
esttab, stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.1 ** 0.05 *** 0.01) keep(St_cons_fox_cnn_msnbc) cells(b(star fmt (%9.3f)) se(par))
esttab using "results/main_`ext'_instr1.tex", replace keep(St_cons_fox_cnn_msnbc) label order() collabels(, none) ml(,none) cells(b(star fmt (%9.3f)) se(par)) stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.10 ** 0.05 *** 0.01) 


**************************************************
* Investigate topics
**************************************************

* Which obs to include?
capture confirm variable in_main
if !_rc {
drop in_main
}
eststo clear
global controls $covs_base $channel $language 
ivreghdfe St_percent_fox (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars')
estadd scalar ftest=e(widstat)
eststo
rename _est_est1 in_main

/* Run regressions for different language statistics
foreach outcome in vocab_size word_length_avg sent_length article_length {
egen SD_`outcome' = sd(`outcome')
gen St_`outcome' = `outcome'/SD_`outcome'
}*/


eststo clear
global controls $covs_base $channel

ivreghdfe topic0 (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls no_articles [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
esttab, stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.1 ** 0.05 *** 0.01) keep(St_*) cells(b(star fmt (%9.3f)) se(par))
regsave using "results/topics/topics.dta", pval replace

foreach outcome in topic1 topic2 topic3 topic4 topic5 topic6 topic7 topic8 topic9 topic10 topic11 topic12 topic13 topic14 topic15 topic16 topic17 topic18 topic19 topic20 topic21 topic22 topic23 topic24 topic25 topic26 topic27 topic28 topic29 topic30 topic31 topic32 topic33 topic34 topic35 topic36 topic37 topic38 topic39 topic40 topic41 topic42 topic43 topic44 topic45 topic46 topic47 topic48 topic49 topic50 topic51 topic52 topic53 topic54 topic55 topic56 topic57 topic58 topic59 topic60 topic61 topic62 topic63 topic64 topic65 topic66 topic67 topic68 topic69 topic70 topic71 topic72 topic73 topic74 topic75 topic76 topic77 topic78 topic79 topic80 topic81 topic82 topic83 topic84 topic85 topic86 topic87 topic88 topic89 topic90 topic91 topic92 topic93 topic94 topic95 topic96 topic97 topic98 topic99 topic100 topic101 topic102 topic103 topic104 topic105 topic106 topic107 topic108 topic109 topic110 topic111 topic112 topic113 topic114 topic115 topic116 topic117 topic118 topic119 topic120 topic121 topic122 topic123 topic124 topic125 topic126 topic127 {
ivreghdfe `outcome' (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls no_articles [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
esttab, stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.1 ** 0.05 *** 0.01) keep(St_*) cells(b(star fmt (%9.3f)) se(par))
regsave using "results/topics/topics.dta", pval append
}


/*esttab using "results/main_topics.tex", replace keep(St_*) label order() collabels(, none) ml(,none) cells(b(star fmt (%9.3f)) se(par)) stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.10 ** 0.05 *** 0.01)
*/












coefplot results_topic0 results_topic1 results_topic10 results_topic100 results_topic101 results_topic102 results_topic103 results_topic104 results_topic105 results_topic106 results_topic107 results_topic108 results_topic109 ///
results_topic11 results_topic110 results_topic111 results_topic112 results_topic113 results_topic114 results_topic115 results_topic116 results_topic117 results_topic118 results_topic119 results_topic12 results_topic120 results_topic121 /// 
results_topic122 results_topic123 results_topic124 results_topic125 results_topic126 results_topic127 results_topic13 results_topic14 results_topic15 results_topic16 results_topic17 results_topic18 results_topic19 results_topic2 results_topic20 ///
results_topic21 results_topic22 results_topic23 results_topic24 results_topic25 results_topic26 results_topic27 results_topic28 results_topic29 results_topic3 results_topic30 results_topic31 results_topic32 results_topic33 results_topic34 results_topic35 ///
results_topic36 results_topic37 results_topic38 results_topic39 results_topic4 results_topic40 results_topic41 results_topic42 results_topic43 results_topic44 results_topic45 results_topic46 results_topic47 results_topic48 results_topic49 results_topic5 ///
results_topic50 results_topic51 results_topic52 results_topic53 results_topic54 results_topic55 results_topic56 results_topic57 results_topic58 results_topic59 results_topic6 results_topic60 results_topic61 results_topic62 results_topic63 results_topic64 ///
results_topic65 results_topic66 results_topic67 results_topic68 results_topic69 results_topic7 results_topic70 results_topic71 results_topic72 results_topic73 results_topic74 results_topic75 results_topic76 results_topic77 results_topic78 results_topic79 ///
results_topic8 results_topic80 results_topic81 results_topic82 results_topic83 results_topic84 results_topic85 results_topic86 results_topic87 results_topic88 results_topic89 results_topic9 results_topic90 results_topic91 results_topic92 results_topic93 ///
results_topic94 results_topic95 results_topic96 results_topic97 results_topic98 results_topic99, drop(_cons) yline(0, lcolor(black)) graphregion(color(white)) ///
legend(off) pstyle(p1) vertical xlabel(,labsize(small)) yla(, tlength(0)) xla(, tlength(0))




coefplot results_0 results_1 results_10 results_100 results_101 results_102 results_103 results_104 results_105 results_106 results_107 results_108 results_109 ///
results_11 results_110 results_111 results_112 results_113 results_114 results_115 results_116 results_117 results_118 results_119 results_12 results_120 results_121 /// 
results_122 results_123 results_124 results_125 results_126 results_127 results_13 results_14 results_15 results_16 results_17 results_18 results_19 results_2 results_20 ///
results_21 results_22 results_23 results_24 results_25 results_26 results_27 results_28 results_29 results_3 results_30 results_31 results_32 results_33 results_34 results_35 ///
results_36 results_37 results_38 results_39 results_4 results_40 results_41 results_42 results_43 results_44 results_45 results_46 results_47 results_48 results_49 results_5 ///
results_50 results_51 results_52 results_53 results_54 results_55 results_56 results_57 results_58 results_59 results_6 results_60 results_61 results_62 results_63 results_64 ///
results_65 results_66 results_67 results_68 results_69 results_7 results_70 results_71 results_72 results_73 results_74 results_75 results_76 results_77 results_78 results_79 ///
results_8 results_80 results_81 results_82 results_83 results_84 results_85 results_86 results_87 results_88 results_89 results_9 results_90 results_91 results_92 results_93 ///
results_94 results_95 results_96 results_97 results_98 results_99, drop(_cons) yline(0, lcolor(black)) graphregion(color(white)) ///
legend(off) pstyle(p1) vertical xlabel(,labsize(small)) yla(, tlength(0)) xla(, tlength(0))





coefplot topic0 topic1 topic10 topic100 topic101 topic102 topic103 topic104 topic105 topic106 topic107 topic108 topic109 ///
topic11 topic110 topic111 topic112 topic113 topic114 topic115 topic116 topic117 topic118 topic119 topic12 topic120 topic121 /// 
topic122 topic123 topic124 topic125 topic126 topic127 topic13 topic14 topic15 topic16 topic17 topic18 topic19 topic2 topic20 ///
topic21 topic22 topic23 topic24 topic25 topic26 topic27 topic28 topic29 topic3 topic30 topic31 topic32 topic33 topic34 topic35 ///
topic36 topic37 topic38 topic39 topic4 topic40 topic41 topic42 topic43 topic44 topic45 topic46 topic47 topic48 topic49 topic5 ///
topic50 topic51 topic52 topic53 topic54 topic55 topic56 topic57 topic58 topic59 topic6 topic60 topic61 topic62 topic63 topic64 ///
topic65 topic66 topic67 topic68 topic69 topic7 topic70 topic71 topic72 topic73 topic74 topic75 topic76 topic77 topic78 topic79 ///
topic8 topic80 topic81 topic82 topic83 topic84 topic85 topic86 topic87 topic88 topic89 topic9 topic90 topic91 topic92 topic93 ///
topic94 topic95 topic96 topic97 topic98 topic99, drop(_cons) yline(0, lcolor(black)) graphregion(color(white)) ///
legend(off) pstyle(p1) vertical xlabel(,labsize(small)) yla(, tlength(0)) xla(, tlength(0))



**************************************************
* Main table with reduced form and 2SLS
**************************************************

* Which obs to include?
capture confirm variable in_main
if !_rc {
drop in_main
}
eststo clear
global controls $covs_base $channel $language 
ivreghdfe St_percent_fox (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars')
estadd scalar ftest=e(widstat)
eststo
rename _est_est1 in_main

* Run regressions for different instruments
eststo clear
global controls $covs_base
ivreghdfe St_percent_fox (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
global controls $covs_base $channel
ivreghdfe St_percent_fox (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
global controls $covs_base $channel $language 
ivreghdfe St_percent_fox (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
esttab, stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.1 ** 0.05 *** 0.01) keep(St_cons_fox_cnn_msnbc) cells(b(star fmt (%9.3f)) se(par))
esttab using "results/main_`ext'_instr1.tex", replace keep(St_cons_fox_cnn_msnbc) label order() collabels(, none) ml(,none) cells(b(star fmt (%9.3f)) se(par)) stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.10 ** 0.05 *** 0.01) 


eststo clear
global controls $covs_base
ivreghdfe St_percent_fox (St_cons_fox_cnn=St_instr_fox_cnn) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
global controls $covs_base $channel
ivreghdfe St_percent_fox (St_cons_fox_cnn=St_instr_fox_cnn) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
global controls $covs_base $channel $language 
ivreghdfe St_percent_fox (St_cons_fox_cnn=St_instr_fox_cnn) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
esttab, stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.1 ** 0.05 *** 0.01) keep(St_cons_fox_cnn) cells(b(star fmt (%9.3f)) se(par))
esttab using "results/main_`ext'_instr2.tex", replace keep(St_cons_fox_cnn) label order() collabels(, none) ml(,none) cells(b(star fmt (%9.3f)) se(par)) stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.10 ** 0.05 *** 0.01) 


eststo clear
global controls $covs_base
ivreghdfe St_percent_fox (St_cons_fox_msnbc=St_instr_fox_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
global controls $covs_base $channel
ivreghdfe St_percent_fox (St_cons_fox_msnbc=St_instr_fox_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
global controls $covs_base $channel $language 
ivreghdfe St_percent_fox (St_cons_fox_msnbc=St_instr_fox_msnbc) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
esttab, stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.1 ** 0.05 *** 0.01) keep(St_cons_fox_msnbc) cells(b(star fmt (%9.3f)) se(par))
esttab using "results/main_`ext'_instr3.tex", replace keep(St_cons_fox_msnbc) label order() collabels(, none) ml(,none) cells(b(star fmt (%9.3f)) se(par)) stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.10 ** 0.05 *** 0.01) 


eststo clear
global controls $covs_base
ivreghdfe St_percent_fox (St_rtgxx_county_fxnc=St_pos_fxnc_county_repl) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
global controls $covs_base $channel
ivreghdfe St_percent_fox (St_rtgxx_county_fxnc=St_pos_fxnc_county_repl) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
global controls $covs_base $channel $language 
ivreghdfe St_percent_fox (St_rtgxx_county_fxnc=St_pos_fxnc_county_repl) $controls [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
esttab, stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.1 ** 0.05 *** 0.01) keep(St_rtgxx_county_fxnc) cells(b(star fmt (%9.3f)) se(par))
esttab using "results/main_`ext'_instr4.tex", replace keep(St_rtgxx_county_fxnc) label order() collabels(, none) ml(,none) cells(b(star fmt (%9.3f)) se(par)) stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.10 ** 0.05 *** 0.01) 


**************************************************
* Graphs for first stage and reduced form
**************************************************

eststo clear
global controls $covs_base $channel $language 

/*
* First stage*/
binscatter St_cons_fox_cnn_msnbc St_instr_fox_cnn_msnbc [aweight=circ], xscale(r(-2 2)) xlabel(-2(1)2) yscale(r(.2 1)) ylabel(0.2(0.2)1) lcolor(green) controls($controls) absorb(fips_state) xtitle(Position FNC-0.5(CNN+MSNBC)) ytitle(Viewership FNC-0.5(CNN+MSNBC)) savegraph("figures/FS_`ext'_instr1.png") nquantiles(16) replace
binscatter St_cons_fox_cnn_msnbc St_instr_fox_cnn_msnbc [aweight=circ], xscale(r(-2 2)) xlabel(-2(1)2) yscale(r(.2 1)) ylabel(0.2(0.2)1) lcolor(green) absorb(fips_state) xtitle(Position FNC-0.5(CNN+MSNBC)) ytitle(Viewership FNC-0.5(CNN+MSNBC)) savegraph("figures/FS_`ext'_instr1_no_controls.png") nquantiles(16) replace

set scheme s1color
grstyle init
grstyle set plain, horizontal grid
grstyle set color Set1
grstyle symbol p circle_hollow
grstyle color line dimgray
* Reduced form
binscatter St_percent_fox St_instr_fox_cnn_msnbc [aweight=circ], xscale(r(-2 2)) xlabel(-2(1)2) yscale(r(15.55 15.8)) ylabel(15.55(0.05)15.8) controls($controls) absorb(fips_state) xtitle(Position FNC-0.5(CNN+MSNBC)) ytitle(Similarity to FNC) lcolor(green) savegraph("figures/RF_`ext'_instr1.png") nquantiles(16) replace
binscatter St_percent_fox St_instr_fox_cnn_msnbc [aweight=circ], xscale(r(-2 2)) xlabel(-2(1)2) yscale(r(15.55 15.8)) ylabel(15.55(0.05)15.8) absorb(fips_state) lcolor(green) xtitle(Position FNC-0.5(CNN+MSNBC)) ytitle(Similarity to FNC) savegraph("figures/RF_`ext'_instr1_no_controls.png") nquantiles(16) replace

* binscatter St_percent_fox St_pos_fxnc_county_repl [aweight=circ], controls($controls) absorb(fips_state) xtitle(Position FNC) ytitle(Similarity to FNC) savegraph("figures/RF_`ext'_instr4.png") nquantiles(16) replace


**************************************************
* Language statistics
**************************************************

* Run regressions for different language statistics
foreach outcome in vocab_size word_length_avg sent_length article_length {
egen SD_`outcome' = sd(`outcome')
gen St_`outcome' = `outcome'/SD_`outcome'
}

eststo clear
global controls $covs_base $channel
foreach outcome in vocab_size word_length_avg sent_length article_length {
* reghdfe St_`outcome' St_pos_fxnc_county_repl $controls pos_cnn_county_repl pos_mnbc_county_repl no_articles [aweight=circ], absorb(fips_state) vce(cluster `cluster_vars'), if in_main
ivreghdfe St_`outcome' (St_cons_fox_cnn_msnbc=St_instr_fox_cnn_msnbc) $controls no_articles [aweight=circ], absorb(fips_state) partial($controls) cluster(`cluster_vars'), if in_main
estadd scalar ftest=e(widstat)
eststo
esttab, stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.1 ** 0.05 *** 0.01) keep(St_*) cells(b(star fmt (%9.3f)) se(par))
}
esttab using "results/main_language.tex", replace keep(St_*) label order() collabels(, none) ml(,none) cells(b(star fmt (%9.3f)) se(par)) stats(ftest r2 N, fmt(%9.3f %9.3f %9.0g) labels("F-test" "R$^2$" "N observations")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*
**************************************************
* Figures for text
**************************************************

gen n = 1
egen count_by_id_news = sum(n), by(id_news)
duplicates drop id_news, force
sum count_by_id_news, detail
sum count_by_id_news
