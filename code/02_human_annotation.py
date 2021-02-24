import os
import pandas as pd
import numpy as np
from sklearn.metrics import confusion_matrix

# Load and clean true labels
true_labels = pd.read_csv('data/human_validation/all_transcripts_1000_each_human_annotation_labeled.csv')
true_labels = true_labels.iloc[0:1000]
true_labels['label'] = np.where(true_labels['label'] == 'FNC', 1, true_labels['label'])
true_labels['label'] = np.where(true_labels['label'] == 'CNN', 0, true_labels['label'])
true_labels['label'] = np.where(true_labels['label'] == 'MSNBC', 0, true_labels['label'])

# Load and clean human annotations
# Freelancer 1
annotated1 = pd.read_excel('data/human_validation/results/all_transcripts_1000_each_human_annotation_cut_0_1000_freelancer1_jd.xlsx')
annotated1.rename(columns={'network': 'label'}, inplace=True)
annotated1['label'] = np.where(annotated1['label'] == 'FMC', 'FNC', annotated1['label'])
annotated1['label'] = np.where(annotated1['label'] == 'FOX', 'FNC', annotated1['label'])
annotated1['label'] = np.where(annotated1['label'] == 'FNC', 1, annotated1['label'])
annotated1['label'] = np.where(annotated1['label'] == 'CNN', 0, annotated1['label'])

# Freelancer 2
annotated2 = pd.read_excel('data/human_validation/results/all_transcripts_1000_each_human_annotation_cut_0_1000_freelancer2_ll.xlsx')
annotated2.rename(columns={'network': 'label'}, inplace=True)
annotated2['label'] = np.where(annotated2['label'] == 'FNC', 1, annotated2['label'])
annotated2['label'] = np.where(annotated2['label'] == 'CNN', 0, annotated2['label'])

# Freelancer 3
annotated3 = pd.read_excel('data/human_validation/results/all_transcripts_1000_each_human_annotation_cut_0_1000_freelancer3_cp.xlsx')
annotated3.rename(columns={'network': 'label'}, inplace=True)
annotated3['label'] = np.where(annotated3['label'] == 'cnn', 'CNN', annotated3['label'])
annotated3['label'] = np.where(annotated3['label'] == 'fnc', 'FNC', annotated3['label'])
annotated3['label'] = np.where(annotated3['label'] == 'FNC', 1, annotated3['label'])
annotated3['label'] = np.where(annotated3['label'] == 'CNN', 0, annotated3['label'])

# Evaluate freelancer 1
print('Accuracy:', round(len(annotated1[annotated1.label == true_labels.label])/1000,3))
print("(tn, fp, fn, tp)")
confusion_matrix(list(true_labels.label), list(annotated1.label)).ravel()

# Evaluate freelancer 2
print('Accuracy:', round(len(annotated2[annotated2.label == true_labels.label])/1000,3))
print("(tn, fp, fn, tp)")
confusion_matrix(list(true_labels.label), list(annotated2.label)).ravel()

# Evaluate freelancer 3
print('Accuracy:', round(len(annotated3[annotated3.label == true_labels.label])/1000,3))
print("(tn, fp, fn, tp)")
confusion_matrix(list(true_labels.label), list(annotated3.label)).ravel()

# How many times do the freelancers agree?
print('Agreement 1 and 2:', round(len(annotated1[annotated1.label == annotated2.label])/1000,3))
print('Agreement 2 and 3:', round(len(annotated3[annotated3.label == annotated2.label])/1000,3))
print('Agreement 1 and 3:', round(len(annotated1[annotated1.label == annotated3.label])/1000,3))
print('Agreement (all):', round(len(annotated1[(annotated1.label == annotated3.label) & (annotated1.label == annotated2.label)])/1000,3))
