from topics_transcript_model import *
import pandas as pd

df = pd.DataFrame()
df['topics_raw'] = topics
df['topic_number'] = range(0,128)
df['topic_label'] = ''

df.to_csv('../data/human_topic_labels/topics_to_label.csv', index=False)
