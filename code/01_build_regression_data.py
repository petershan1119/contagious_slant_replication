import os
import pandas as pd
import numpy as np

# Load contemporary Media Intelligence Center (MIC) data
mic = '../data/inputs/aam_media_intelligence_center/dist_by_county_newspaper_analyzer_2010-2013.xls'
mic = pd.read_excel(mic)
websites = pd.Series(mic['Web Site'].unique())
websites.to_excel('mic_websites_unique.xls', index=False)
mic = mic.groupby(['Member Name', 'County Name', 'State of County', 'City Published', 'State Published', 'Parent Company']).mean().reset_index()
mic.rename(columns={'Member Name': 'source_mic', 'County Name': 'county_mic', 'State of County': 'state_mic',
                    'City Published': 'own_city_mic', 'State Published': 'own_state_mic',
                    'Parent Company': 'own_parent_mic', 'Total Circulation': 'circ_mic'}, inplace=True)
mic = mic[['source_mic', 'county_mic', 'state_mic', 'own_city_mic', 'own_state_mic', 'own_parent_mic', 'circ_mic']]
for v in ['source_mic', 'county_mic', 'state_mic', 'own_city_mic', 'own_state_mic', 'own_parent_mic']:
    mic[v] = mic[v].str.lower()

# Load historical Media Intelligence Center (MIC) data
mic_hist = '../data/inputs/aam_media_intelligence_center/county_level_circulation_1995.xlsx'
mic_hist = pd.read_excel(mic_hist)
mic_hist.rename(columns={ 'Avg. Proj. Pd. Circ.*': 'circ_hist'}, inplace=True)
mic_hist.rename(columns={'Newspaper Name': 'source_mic', 'County Name': 'county_mic', 'County State': 'state_mic',
                    'City Published': 'own_city_mic', 'State Published': 'own_state_mic'}, inplace=True)
mic_hist.drop(columns=['Member Number'], inplace=True)
for v in ['source_mic', 'county_mic', 'state_mic', 'own_city_mic', 'own_state_mic']:
    mic_hist[v] = mic_hist[v].str.lower()

mic_hist = mic_hist.groupby(['source_mic', 'county_mic', 'state_mic', 'own_city_mic', 'own_state_mic']).mean().reset_index()

# Load the source list from Newslibrary
nb = '../data/inputs/newslibrary/complete_source_list.xlsx'
nb = pd.read_excel(nb)
nb.rename(columns={'source': 'source_nb'}, inplace=True)

# Load crosswalk between Newslibrary and the AAM-MIC
cw = '../data/inputs/newslibrary/mic_crosswalk_newslib_long.csv'
cw = pd.read_csv(cw)
# Drop some wrong matches
cw = cw[cw.source_mic != 'the denver post/the sunday denver post - sunday select']
cw = cw[cw.source_mic !=  'the modesto bee - vida en el valle']
cw = cw[cw.source_mic !=  'news herald']
cw = cw[~((cw.source_mic ==  'tribune review - the herald') & (cw.source_nb ==  'herald, the (sharon, pa)'))]
cw = cw[~((cw.source_mic ==  'the star - the butler bulletin') & (cw.source_nb ==  'star, the (auburn, in)'))]
cw['source_mic'] = np.where(cw['source_mic'] == 'tribune review - penn-trafford star', 'tribune review - penn trafford star', cw['source_mic'])
cw.drop_duplicates(inplace=True)
print(len(cw)) # 642

# Merge Newslibrary and crosswalk
m = nb.merge(cw, on='source_nb', how='outer', indicator=True)
print(m._merge.value_counts())
print(len(m) == len(nb))
m = m[m._merge == 'both']
m = m[['source_nb', 'source_mic', 'own_city_mic', 'own_state_mic']]
print(len(m), '\n')
# Merge MIC and Newslibrary
m = mic.merge(m, on=['source_mic', 'own_city_mic', 'own_state_mic'], how='outer' ,indicator=True)
print(m._merge.value_counts())
m = m[pd.notnull(m.source_nb)]
print(len(m.drop_duplicates(subset=['source_mic', 'own_city_mic', 'own_state_mic', 'source_nb', 'county_mic', 'state_mic'])) == len(m))
m = m[['source_mic', 'county_mic', 'state_mic', 'own_city_mic', 'own_state_mic', 'own_parent_mic', 'circ_mic', 'source_nb']]
# Add historical circulation xxc
print(len(m))
m = m.merge(mic_hist, on=['source_mic', 'county_mic', 'state_mic', 'own_city_mic', 'own_state_mic'], how='left')
print(len(m))

# Add state abbreviations
s_abbr = pd.read_csv('../data/inputs/aam_media_intelligence_center/states_abbr.csv')
m = m.merge(s_abbr, on='state_mic', how='left', indicator=True)
print(len(m))
m = m[m._merge != 'left_only']
print(len(m))
m.drop(columns=['_merge'], inplace=True)

# Merge county-level Nielsen
print('Load Nielsen:')
n = pd.read_stata('../data/inputs/nielsen/county_rating_2005_2008.dta')
print(len(n))
n = n[pd.notnull(n.rtgxx_county_fxnc)]
print(len(n))
n['stateabbrev'] = n['stateabbrev'].str.lower()
n.rename(columns={'stateabbrev': 'state_mic_abbr', 'county_string': 'county_mic'}, inplace=True)
n = n.groupby(['state_mic_abbr', 'county_mic']).mean()
m = m.merge(n, on=['state_mic_abbr', 'county_mic'], how='left', indicator=True)
print(m._merge.value_counts())
m.drop(columns=['_merge'], inplace=True)

# Add info on whether newspaper-county obs is the headquarter
o = pd.read_csv('../data/inputs/aam_media_intelligence_center/mic_owners_counties.csv')
print(len(m))
m = m.merge(o, on=['source_mic', 'own_city_mic', 'own_state_mic'], how='left', indicator=True)
print(len(m))
print(m._merge.value_counts())
m.drop(columns=['_merge'], inplace=True)

# Prepare language stats
lang = pd.read_csv('../data/natural_language_processing/language_stats_by_newspaper.csv')
lang.rename(columns={'office_clean': 'source_nb'}, inplace=True)
artlen = pd.read_csv('../data/natural_language_processing/wordcount_by_newspaper.csv')
artlen.rename(columns={'office_clean': 'source_nb'}, inplace=True)
lang = lang.merge(artlen, on=['source_nb'], how='left', indicator=True)

# Add LGR predictions and language stats (with filtering)
lgr = pd.read_excel('../data/natural_language_processing/main_model_with_filtering.xls')
lgr.rename(columns={'office_clean': 'source_nb'}, inplace=True)
print(len(m))
analysis1 = m.merge(lgr[['source_nb', 'n', 'percent_fox']], on=['source_nb'], how='left', indicator=True)
print(len(analysis1))
analysis1.drop(columns=['_merge'], inplace=True)
analysis1 = analysis1.merge(lang[['source_nb', 'vocab_size', 'word_length_avg', 'no_sentences', 'word_count_total', 'sent_length', 'words_avg']], on=['source_nb'], how='left', indicator=True)
print(len(analysis1))
analysis1.drop(columns=['_merge'], inplace=True)
analysis1.to_excel('../data/regression_data/main_model_with_filtering_regression_data.xls', index=False)

# Add LGR predictions and language stats (without filtering)
lgr = pd.read_excel('../data/natural_language_processing/main_model_no_filtering.xls')
lgr.rename(columns={'office_clean': 'source_nb'}, inplace=True)
print(len(m))
analysis2 = m.merge(lgr[['source_nb', 'n', 'percent_fox']], on=['source_nb'], how='left', indicator=True)
print(len(analysis2))
analysis2.drop(columns=['_merge'], inplace=True)
analysis2 = analysis2.merge(lang[['source_nb', 'vocab_size', 'word_length_avg', 'no_sentences', 'word_count_total', 'sent_length', 'words_avg']], on=['source_nb'], how='left', indicator=True)
print(len(analysis2))
analysis2.drop(columns=['_merge'], inplace=True)
analysis2.to_excel('../data/regression_data/main_model_no_filtering_regression_data.xls', index=False)

# Add Placebo predictions (no filtering)
lgr = pd.read_csv('../data/natural_language_processing/main_model_placebo.csv')
lgr.rename(columns={'office_clean': 'source_nb', 'n': 'no_articles_placebo', 'percent_fox': 'percent_fox_95_96'}, inplace=True)
lgr = lgr[['source_nb', 'percent_fox_95_96', 'no_articles_placebo']]
print(len(analysis2))
analysis3 = analysis2.merge(lgr, on=['source_nb'], how='left', indicator=True)
print(len(analysis3))
analysis3.drop(columns=['_merge'], inplace=True)
analysis3.to_excel('../data/regression_data/main_model_no_filtering_placebo_regression_data.xls', index=False)

# Add LGR without AP articles (no filtering)
lgr = pd.read_csv('../data/natural_language_processing/main_model_non_ap.csv')
lgr.rename(columns={'office_clean': 'source_nb', 'n': 'no_articles_non_ap', 'percent_fox': 'percent_fox_non_ap'}, inplace=True)
lgr = lgr[['source_nb', 'percent_fox_non_ap', 'no_articles_non_ap']]
print(len(analysis2))
analysis4 = analysis2.merge(lgr, on=['source_nb'], how='left', indicator=True)
print(len(analysis4))
analysis4.drop(columns=['_merge'], inplace=True)
analysis4.to_excel('../data/regression_data/main_model_no_filtering_non_ap_regression_data.xls', index=False)

# Add topic shares from LDA (no filtering)
topics = pd.read_csv('../data/natural_language_processing/lda_shares_by_outlet.csv')
topics.rename(columns={'office_clean': 'source_nb'}, inplace=True)
# topics.drop(columns=['n'], inplace=True)
print(len(analysis2))
analysis5 = analysis2.merge(topics, on=['source_nb'], how='left', indicator=True)
print(len(analysis5))
analysis5.drop(columns=['_merge'], inplace=True)
analysis5.to_csv('../data/regression_data/main_model_no_filtering_topics_regression_data.csv', index=False)

# Alternative matching
n = n.reset_index()
n.rename(columns={'state_mic_abbr': 'state', 'county_mic': 'county'}, inplace=True)
a = pd.read_stata('../data/name_based_matching/alternative_matching.dta')
a['state'] = a['state'].str.lower()
a = a.merge(n, on=['state', 'county'], how='left', indicator=True)
a.drop(columns=['_merge'], inplace=True)
lgr = pd.read_excel('../data/natural_language_processing/main_model_no_filtering.xls')
lgr.rename(columns={'office_clean': 'source_nb'}, inplace=True)
a.rename(columns={'source': 'source_nb'}, inplace=True)
a = a.merge(lgr[['source_nb', 'n', 'percent_fox']], on=['source_nb'], how='left', indicator=True)
print(len(a))
a.drop(columns=['_merge'], inplace=True)
a = a.merge(lang[['source_nb', 'vocab_size', 'word_length_avg', 'no_sentences', 'word_count_total', 'sent_length', 'words_avg']], on=['source_nb'], how='left', indicator=True)
print(len(a))
a.drop(columns=['_merge'], inplace=True)
a.to_excel('../data/regression_data/alternative_matching_no_filtering_regression_data.xls', index=False)
