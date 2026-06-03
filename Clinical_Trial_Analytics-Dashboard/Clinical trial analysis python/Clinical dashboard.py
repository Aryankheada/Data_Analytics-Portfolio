import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

# =====================================
# LOAD CSV FILES (FIXED PATHS)
# =====================================

drug_df = pd.read_csv(
    r"C:\aryan\practice sql\CT csv\drug_safety_and_effectiveness.csv"
)

ae_df = pd.read_csv(
    r"C:\aryan\practice sql\CT csv\drug_with_most_ae.csv"
)

event_df = pd.read_csv(
    r"C:\aryan\practice sql\CT csv\highest_adverse_event.csv"
)

# =====================================
# KPI CALCULATIONS
# =====================================

total_trials = drug_df["total_trials"].sum()

avg_ae = round(
    drug_df["AE_rate"].mean(), 2
)

avg_completion = round(
    drug_df["completion_rate"].mean(), 2
)

total_patients = (
    drug_df["total_enrolled_patients"]
    .sum()
)

# =====================================
# DATA FOR CHARTS
# =====================================

highest_ae = (
    drug_df.sort_values(
        by="AE_rate",
        ascending=False
    )
    .head(5)
)

lowest_ae = (
    drug_df.sort_values(
        by="AE_rate",
        ascending=True
    )
    .head(5)
)

top_completion = (
    drug_df.sort_values(
        by="completion_rate",
        ascending=False
    )
    .head(5)
)

most_ae = (
    ae_df.sort_values(
        by="total_adverse_events",
        ascending=False
    )
    .head(5)
)

high_risk = (
    event_df.sort_values(
        by="AE_rate",
        ascending=False
    )
    .head(5)
)

# =====================================
# CREATE DASHBOARD LAYOUT
# =====================================

fig = make_subplots(
    rows=4,
    cols=4,

    row_heights=[
        0.15,
        0.30,
        0.30,
        0.25
    ],

    specs=[
        [
            {"type": "indicator"},
            {"type": "indicator"},
            {"type": "indicator"},
            {"type": "indicator"}
        ],

        [
            {"colspan": 2},
            None,
            {"colspan": 2},
            None
        ],

        [
            {"colspan": 2},
            None,
            {"colspan": 2},
            None
        ],

        [
            {"colspan": 2},
            None,
            {"type": "domain"},
            {"type": "domain"}
        ]
    ],

    subplot_titles=(
        "",
        "",
        "",
        "",
        "Highest AE Rate",
        "Lowest AE Rate",
        "Most Adverse Events",
        "High Risk Categories",
        "Top Completion Rate",
        "AE Distribution"
    ),

    vertical_spacing=0.10,
    horizontal_spacing=0.08
)

# =====================================
# KPI CARDS
# =====================================

fig.add_trace(
    go.Indicator(
        mode="number",
        value=total_trials,
        title={"text": "<b>Total Trials</b>"},
        number={"font": {"size": 42}}
    ),
    row=1,
    col=1
)

fig.add_trace(
    go.Indicator(
        mode="number",
        value=avg_ae,
        title={"text": "<b>Avg AE Rate</b>"},
        number={
            "suffix": "%",
            "font": {"size": 42}
        }
    ),
    row=1,
    col=2
)

fig.add_trace(
    go.Indicator(
        mode="number",
        value=avg_completion,
        title={"text": "<b>Completion Rate</b>"},
        number={
            "suffix": "%",
            "font": {"size": 42}
        }
    ),
    row=1,
    col=3
)

fig.add_trace(
    go.Indicator(
        mode="number",
        value=total_patients,
        title={"text": "<b>Total Patients</b>"},
        number={"font": {"size": 42}}
    ),
    row=1,
    col=4
)

# =====================================
# HIGHEST AE RATE
# =====================================

fig.add_trace(
    go.Bar(
        x=highest_ae["drug_name"],
        y=highest_ae["AE_rate"],
        marker_color="#2563EB"
    ),
    row=2,
    col=1
)

# =====================================
# LOWEST AE RATE
# =====================================

fig.add_trace(
    go.Bar(
        x=lowest_ae["drug_name"],
        y=lowest_ae["AE_rate"],
        marker_color="#EF4444"
    ),
    row=2,
    col=3
)

# =====================================
# MOST ADVERSE EVENTS
# =====================================

fig.add_trace(
    go.Bar(
        x=most_ae["drug_name"],
        y=most_ae["total_adverse_events"],
        marker_color="#22C55E"
    ),
    row=3,
    col=1
)

# =====================================
# HIGH RISK CATEGORY
# =====================================

fig.add_trace(
    go.Bar(
        x=high_risk["indication"],
        y=high_risk["AE_rate"],
        marker_color="#8B5CF6"
    ),
    row=3,
    col=3
)

# =====================================
# TOP COMPLETION RATE
# =====================================

fig.add_trace(
    go.Bar(
        x=top_completion["drug_name"],
        y=top_completion["completion_rate"],
        marker_color="#F59E0B"
    ),
    row=4,
    col=1
)

# =====================================
# DONUT CHART
# =====================================

fig.add_trace(
    go.Pie(
        labels=highest_ae["drug_name"],
        values=highest_ae["AE_rate"],
        hole=0.55
    ),
    row=4,
    col=3
)

# =====================================
# DESIGN
# =====================================

fig.update_layout(
    title={
        "text":
        "Clinical Trial Safety Dashboard",
        "x": 0.5,
        "font": {
            "size": 28
        }
    },

    template="plotly_white",

    height=950,
    width=1650,

    showlegend=False,

    margin=dict(
        l=50,
        r=50,
        t=100,
        b=40
    ),

    font=dict(
        family="Arial",
        size=13
    )
)

# =====================================
# SHOW DASHBOARD
# =====================================
fig.write_html(
    "Clinical_Trial_Safety_Dashboard.html"
)

fig.write_image(
    "Clinical_Trial_Safety_Dashboard.png"
)

fig.show()
