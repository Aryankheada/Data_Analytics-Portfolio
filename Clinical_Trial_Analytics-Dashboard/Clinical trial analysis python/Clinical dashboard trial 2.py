import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

# ==========================
# LOAD DATA
# ==========================

phase_df = pd.read_csv("clinical_trial_phase_performance.csv")
dropout_df = pd.read_csv("dropout_pattern_analysis.csv")
site_df = pd.read_csv("site_performance_analysis.csv")

# ==========================
# KPI CALCULATIONS
# ==========================

total_trials = phase_df["total_trials"].sum()
avg_enrollment = round(phase_df["avg_enrollment"].mean(), 1)
total_dropouts = dropout_df["dropout_patients"].sum()
avg_completion = round(site_df["completion_rate"].mean(), 1)

# ==========================
# TOP / LOW SITES
# ==========================

top_sites = site_df.nlargest(5, "completion_rate")
low_sites = site_df.nsmallest(5, "completion_rate")

# ==========================
# DASHBOARD LAYOUT
# ==========================

fig = make_subplots(
    rows=4,
    cols=2,
    subplot_titles=(
        "Trials by Phase",
        "Average Enrollment",
        "Dropout by Reason",
        "Top Performing Sites",
        "Lowest Performing Sites",
        "Completion Rate Distribution",
        "",
        ""
    ),
    specs=[
        [{"type": "bar"}, {"type": "bar"}],
        [{"type": "bar"}, {"type": "bar"}],
        [{"type": "bar"}, {"type": "histogram"}],
        [{"type": "domain"}, {"type": "domain"}]
    ],
    vertical_spacing=0.12
)

# ==========================
# CHART 1 - Trials by Phase
# ==========================

fig.add_trace(
    go.Bar(
        x=phase_df["phase"],
        y=phase_df["total_trials"],
        marker_color="#4F46E5"
    ),
    row=1, col=1
)

# ==========================
# CHART 2 - Avg Enrollment
# ==========================

fig.add_trace(
    go.Bar(
        x=phase_df["phase"],
        y=phase_df["avg_enrollment"],
        marker_color="#10B981"
    ),
    row=1, col=2
)

# ==========================
# CHART 3 - Dropout Reason
# ==========================

dropout_group = dropout_df.groupby(
    "dropout_reason"
)["dropout_patients"].sum()

fig.add_trace(
    go.Bar(
        x=dropout_group.index,
        y=dropout_group.values,
        marker_color="#EF4444"
    ),
    row=2, col=1
)

# ==========================
# CHART 4 - Top Sites
# ==========================

fig.add_trace(
    go.Bar(
        x=top_sites["site_name"],
        y=top_sites["completion_rate"],
        marker_color="#3B82F6"
    ),
    row=2, col=2
)

# ==========================
# CHART 5 - Lowest Sites
# ==========================

fig.add_trace(
    go.Bar(
        x=low_sites["site_name"],
        y=low_sites["completion_rate"],
        marker_color="#F59E0B"
    ),
    row=3, col=1
)

# ==========================
# CHART 6 - Completion Dist
# ==========================

fig.add_trace(
    go.Histogram(
        x=site_df["completion_rate"],
        marker_color="#8B5CF6"
    ),
    row=3, col=2
)

# ==========================
# KPI CARDS
# ==========================

fig.add_annotation(
    text=f"<b>Total Trials</b><br>{total_trials}",
    x=0.05, y=1.15,
    xref="paper", yref="paper",
    showarrow=False,
    font=dict(size=20)
)

fig.add_annotation(
    text=f"<b>Avg Enrollment</b><br>{avg_enrollment}",
    x=0.30, y=1.15,
    xref="paper", yref="paper",
    showarrow=False,
    font=dict(size=20)
)

fig.add_annotation(
    text=f"<b>Total Dropouts</b><br>{total_dropouts}",
    x=0.60, y=1.15,
    xref="paper", yref="paper",
    showarrow=False,
    font=dict(size=20)
)

fig.add_annotation(
    text=f"<b>Avg Completion</b><br>{avg_completion}%",
    x=0.90, y=1.15,
    xref="paper", yref="paper",
    showarrow=False,
    font=dict(size=20)
)

# ==========================
# FINAL DESIGN
# ==========================

fig.update_layout(
    title={
        "text": "Clinical Operations Dashboard",
        "x": 0.5,
        "font": {"size": 28}
    },

    height=1000,
    width=1500,

    template="plotly_white",

    showlegend=False,

    margin=dict(
        t=150,
        l=40,
        r=40,
        b=40
    )
)

fig.show()