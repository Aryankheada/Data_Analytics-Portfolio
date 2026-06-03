# import pandas as pd
# import matplotlib.pyplot as plt
# import os
# folder_path = r"C:\aryan\practice sql\CT csv"
# csv_files = [file for file in os.listdir(folder_path) if file.endswith('.csv')]

# dataframes= {}

# for file in csv_files:
#        file_path = os.path.join(folder_path, file)
#        df_name = file.replace(".csv", '')
#        dataframes[df_name] = pd.read_csv(file_path)

# drug_df = dataframes['drug_safety_and_effectiveness']
# # top_drugs = drug_df.sort_values(
# #        by= "AE_rate", ascending=False
# # ).head(5)
# # plt.figure(figsize=(8,5))
# # plt.barh(
# #        top_drugs
# #        ["drug_name"], 
# #        top_drugs["AE_rate"]
# # )
# # plt.title('Top 5 Drugs with Highest AE Rate')
# # plt.xlabel("AE_rate")
# # plt.ylabel("Drug_name")
# # plt.xticks(rotation=45)
# # plt.grid()
# # plt.tight_layout
# # plt.show()



# # low_drugs = drug_df.sort_values(
# #        by= "AE_rate"
# # ).head(5)

# # plt.figure(figsize=(8,5))

# # plt.bar(
# #        low_drugs["drug_name"],
# #        low_drugs["AE_rate"]
# # )
# # plt.tight_layout()

# # plt.title("Top 5 Drugs with Lower AE Rate")
# # plt.xlabel("Drugs_name")
# # plt.ylabel("AE_rate")

# # plt.xticks(rotation= 45)
# # plt.grid()
# # plt.show()

# top_drugs = drug_df.sort_values(
#        by= "AE_rate", ascending=False
# ).head(5)
# plt.figure(figsize=(8,5))
# plt.pie( 
#        top_drugs["AE_rate"],
#        labels= top_drugs
#        ["drug_name"],
#        autopct="%1.1f%%"
# )
# plt.title('AE Rate share of Top 5 Drugs')
# plt.show()

import pandas as pd
import os

# change working directory
os.chdir(r"C:\aryan\practice sql\CT csv")

# load csv
phase_df = pd.read_csv("clinical_trial_phase_performance.csv")
dropout_df = pd.read_csv("dropout_pattern_analysis.csv")

# check columns
print(phase_df.columns.tolist())
print(dropout_df.columns.tolist())