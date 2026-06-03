import pandas as pd
import matplotlib.pyplot as plt
import os


# ======================================
# Load CSV files
# ======================================

folder_path = r"C:\aryan\practice sql\CT csv"

csv_files = [
    file for file in os.listdir(folder_path)
    if file.endswith(".csv")
]

dataframes = {}

for file in csv_files:

    file_path = os.path.join(folder_path, file)

    df_name = file.replace(".csv", "")

    dataframes[df_name] = pd.read_csv(file_path)


# ======================================
# Required DataFrames
# ======================================

drug_df = dataframes["drug_safety_and_effectiveness"]

kpi_df = dataframes["clinical_trials_kpi"]

most_ae_df = dataframes["drug_with_most_ae"]

high_ae_df = dataframes["highest_adverse_event"]

import pandas as pd
from plotly.subplots import make_subplots
import plotly.graph_objects as go

# ==============================
# DATA
# ==============================

drug_df = dataframes["drug_safety_and_effectiveness"]
ae_df = dataframes["drug_with_most_ae"]
event_df = dataframes["highest_adverse_event"]

top_drugs = drug_df.sort_values(
    by="AE_rate",
    ascending=False
).head(5)

low_drugs = drug_df.sort_values(
    by="AE_rate"
).head(5)

top_completion = drug_df.sort_values(
    by="completion_rate",
    ascending=False
).head(5)

top_event = event_df.sort_values(
    by="AE_rate",
    ascending=False
).head(5)

# ==============================
# KPIs
# ==============================

total_trials = len(drug_df)
avg_ae = drug_df["AE_rate"].mean()
avg_completion = drug_df["completion_rate"].mean()
total_patients = drug_df["total_enrolled_patients"].sum()

# ==============================
# DASHBOARD
# ==============================

fig = make_subplots(
    rows=3,
    cols=2,
    subplot_titles=(
        "Top 5 Highest AE Rate",
        "Top 5 Lowest AE Rate",
        "Drugs With Most Adverse Events",
        "Highest Adverse Event Category",
        "Top Completion Rate",
        "AE Rate Distribution"
    ),
    specs=[
        [{}, {}],
        [{}, {}],
        [{}, {"type":"domain"}]
    ]
)

# ==================================
# CHART 1
# ==================================

fig.add_trace(
    go.Bar(
        x=top_drugs["drug_name"],
        y=top_drugs["AE_rate"],
        name="Highest AE"
    ),
    row=1,
    col=1
)

# ==================================
# CHART 2
# ==================================

fig.add_trace(
    go.Bar(
        x=low_drugs["drug_name"],
        y=low_drugs["AE_rate"],
        name="Lowest AE"
    ),
    row=1,
    col=2
)

# ==================================
# CHART 3
# ==================================

fig.add_trace(
    go.Bar(
        x=ae_df["drug_name"],
        y=ae_df["total_adverse_events"],
        name="Adverse Events"
    ),
    row=2,
    col=1
)

# ==================================
# CHART 4
# ==================================

fig.add_trace(
    go.Bar(
        x=top_event["indication"],
        y=top_event["AE_rate"],
        name="Event Category"
    ),
    row=2,
    col=2
)

# ==================================
# CHART 5
# ==================================

fig.add_trace(
    go.Bar(
        x=top_completion["drug_name"],
        y=top_completion["completion_rate"],
        name="Completion"
    ),
    row=3,
    col=1
)

# ==================================
# PIE CHART
# ==================================

fig.add_trace(
    go.Pie(
        labels=top_drugs["drug_name"],
        values=top_drugs["AE_rate"],
        hole=0.5
    ),
    row=3,
    col=2
)

# ==================================
# KPI CARDS
# ==================================

fig.add_annotation(
    text=f"<b>Total Trials</b><br>{total_trials}",
    x=0.08,
    y=1.18,
    showarrow=False,
    font=dict(size=16)
)

fig.add_annotation(
    text=f"<b>Avg AE Rate</b><br>{avg_ae:.2f}%",
    x=0.32,
    y=1.18,
    showarrow=False,
    font=dict(size=16)
)

fig.add_annotation(
    text=f"<b>Completion Rate</b><br>{avg_completion:.2f}%",
    x=0.58,
    y=1.18,
    showarrow=False,
    font=dict(size=16)
)

fig.add_annotation(
    text=f"<b>Total Patients</b><br>{total_patients}",
    x=0.85,
    y=1.18,
    showarrow=False,
    font=dict(size=16)
)

# ==================================
# LAYOUT
# ==================================

fig.update_layout(
    title="Clinical Trial Safety Dashboard",
    height=1000,
    width=1500,
    template="plotly_white"
)

fig.show()