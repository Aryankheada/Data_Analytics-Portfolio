import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import os

# ==========================
# LOAD DATA (FIXED PATH)
# ==========================

folder_path = r"C:\aryan\practice sql\CT csv"

phase_df = pd.read_csv(
    os.path.join(folder_path, "clinical_trial_phase_performance.csv")
)

dropout_df = pd.read_csv(
    os.path.join(folder_path, "dropout_pattern_analysis.csv")
)

site_df = pd.read_csv(
    os.path.join(folder_path, "site_performance_analysis.csv")
)

# ==========================
# KPI CALCULATIONS
# ==========================

total_trials = phase_df["total_trials"].sum()
avg_enrollment = round(phase_df["avg_enrollment"].mean(), 1)
total_dropouts = dropout_df["dropout_patients"].sum()
avg_completion = round(site_df["completion_rate"].mean(), 1)

# ==========================
# DATA FOR CHARTS
# ==========================

top_sites = site_df.nlargest(5, "completion_rate")
low_sites = site_df.nsmallest(5, "completion_rate")

phase_completion = phase_df.groupby("phase")[
    "completed_patients"
].sum()

dropout_reason = dropout_df.groupby(
    "dropout_reason"
)["dropout_patients"].sum()

phase_dropout = dropout_df.groupby(
    "phase"
)["dropout_rate"].mean()

# ==========================
# DASHBOARD LAYOUT
# ==========================

fig = make_subplots(
    rows=4,
    cols=2,
    specs=[
        [{"type": "indicator"}, {"type": "indicator"}],
        [{"type": "bar"}, {"type": "bar"}],
        [{"type": "bar"}, {"type": "pie"}],
        [{"type": "bar"}, {"type": "indicator"}]
    ],
    subplot_titles=(
        "", "",
        "Top Performing Sites",
        "Lowest Performing Sites",
        "Completed Patients by Phase",
        "Dropout Reason Share",
        "Average Dropout Rate by Phase",
        ""
    ),
    vertical_spacing=0.12,
    horizontal_spacing=0.08
)

# ==========================
# KPI CARDS
# ==========================

fig.add_trace(
    go.Indicator(
        mode="number",
        value=total_trials,
        title={"text": "Total Trials"},
        number={"font": {"size": 42}}
    ),
    row=1, col=1
)

fig.add_trace(
    go.Indicator(
        mode="number",
        value=avg_enrollment,
        title={"text": "Avg Enrollment"},
        number={"font": {"size": 42}}
    ),
    row=1, col=2
)

fig.add_trace(
    go.Indicator(
        mode="number",
        value=total_dropouts,
        title={"text": "Total Dropouts"},
        number={"font": {"size": 42}}
    ),
    row=4, col=2
)

# ==========================
# CHARTS
# ==========================

# TOP SITES
fig.add_trace(
    go.Bar(
        x=top_sites["site_name"],
        y=top_sites["completion_rate"],
        marker_color="#2E86DE"
    ),
    row=2, col=1
)

# LOWEST SITES
fig.add_trace(
    go.Bar(
        x=low_sites["site_name"],
        y=low_sites["completion_rate"],
        marker_color="#E74C3C"
    ),
    row=2, col=2
)

# COMPLETED PATIENTS
fig.add_trace(
    go.Bar(
        x=phase_completion.index,
        y=phase_completion.values,
        marker_color="#27AE60"
    ),
    row=3, col=1
)

# DROPOUT REASONS PIE
fig.add_trace(
    go.Pie(
        labels=dropout_reason.index,
        values=dropout_reason.values,
        hole=0.6
    ),
    row=3, col=2
)

# DROPOUT RATE
fig.add_trace(
    go.Bar(
        x=phase_dropout.index,
        y=phase_dropout.values,
        marker_color="#F39C12"
    ),
    row=4, col=1
)

# COMPLETION KPI
fig.add_trace(
    go.Indicator(
        mode="number",
        value=avg_completion,
        title={"text": "Avg Completion Rate"},
        number={"suffix": "%",
                 "font": {"size": 42}}
    ),
    row=1, col=2
)

# ==========================
# STYLE
# ==========================

fig.update_layout(
    title={
        "text": "Clinical Trial Phase & Site Dashboard",
        "x": 0.5,
        "font": {"size": 26}
    },

    height=950,
    width=1450,

    paper_bgcolor="#F4F6F9",
    plot_bgcolor="white",

    font=dict(
        family="Arial",
        size=12
    ),

    showlegend=False,

    margin=dict(
        t=80,
        l=40,
        r=40,
        b=40
    )
)

fig.show()