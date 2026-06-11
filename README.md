# 🚖 Uber Request Data — End-to-End EDA & Business Insights

![Python](https://img.shields.io/badge/Python-3.12-blue?style=flat-square&logo=python)
![Pandas](https://img.shields.io/badge/Pandas-2.0-darkblue?style=flat-square&logo=pandas)
![Matplotlib](https://img.shields.io/badge/Matplotlib-3.8-orange?style=flat-square)
![Seaborn](https://img.shields.io/badge/Seaborn-0.13-teal?style=flat-square)
![Excel](https://img.shields.io/badge/Dashboard-Google%20Sheets-green?style=flat-square&logo=googlesheets)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat-square)

> **A full exploratory data analysis pipeline on Uber's ride request dataset — from raw data to business recommendations — covering data cleaning, statistical analysis, visualisation, SQL querying, and an interactive dashboard.**

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Dataset](#-dataset)
- [Key Business Findings](#-key-business-findings)
- [Project Structure](#-project-structure)
- [Pipeline Walkthrough](#-pipeline-walkthrough)
- [Visualisations](#-visualisations)
- [Dashboard](#-dashboard)
- [SQL Analysis](#-sql-analysis)
- [Tech Stack](#-tech-stack)
- [How to Run](#-how-to-run)
- [Business Recommendations](#-business-recommendations)
- [Author](#-author)

---

## 🎯 Project Overview

This project performs a **complete EDA pipeline** on Uber's ride request dataset, identifying a significant **supply-demand mismatch** that causes more than half of all ride requests to go unfulfilled. The analysis covers:

- ✅ Data quality assessment and cleaning
- ✅ Missing value, outlier, duplicate and garbage value treatment
- ✅ Statistical distribution analysis
- ✅ Correlation and multicollinearity checks
- ✅ Feature engineering (time slots, hour, duration)
- ✅ Normalisation (Min-Max and Z-score)
- ✅ Business insight extraction
- ✅ Interactive Google Sheets dashboard
- ✅ SQL querying
- ✅ Professional PDF business report

---

## 📊 Dataset

| Property | Detail |
|---|---|
| **Source** | Uber Request Data (Kaggle) |
| **Period** | July 11–15, 2016 |
| **Records** | 6,745 ride requests |
| **Locations** | City & Airport |
| **Raw Columns** | 6 |
| **Engineered Columns** | 5 (hour, date, day_of_week, duration_min, time_slot) |
| **Active Drivers** | 300 |

### Raw Columns

| Column | Type | Description |
|---|---|---|
| `Request id` | int | Unique identifier per request |
| `Pickup point` | str | City or Airport |
| `Driver id` | float | Driver assigned (null if no car) |
| `Status` | str | Trip Completed / Cancelled / No Cars Available |
| `Request timestamp` | str | Mixed format — datetime of request |
| `Drop timestamp` | str | Datetime of drop (null if incomplete) |

---

## 🔍 Key Business Findings

```
Total Requests      →   6,745
Completion Rate     →   42%   ✅
No Cars Rate        →   39%   ⚠️
Cancellation Rate   →   19%   ❌
Avg Trip Duration   →   52 min
Active Drivers      →   300
```

### Supply Gap by Time Slot

| Time Slot | Total | Completed | Unserved | Unserved % | Severity |
|---|---|---|---|---|---|
| Late Night (0–4) | 578 | 214 | 364 | 63.0% | 🟡 Moderate |
| Morning (5–9) | 2,103 | 854 | 1,249 | 59.4% | 🔴 Critical |
| Afternoon (10–16) | 1,224 | 722 | 502 | 41.0% | 🔴 Critical |
| Evening (17–20) | 1,893 | 642 | 1,251 | 66.1% | 🔴 Critical |
| Night (21–23) | 947 | 399 | 548 | 57.9% | 🔴 Critical |

### Daily Performance

| Date | Total | Completed | Completion % | vs Baseline | Performance |
|---|---|---|---|---|---|
| Jul 11 | 1,367 | 601 | 44.0% | +2.0% | 🟢 Above Average |
| Jul 12 | 1,307 | 562 | 43.0% | +1.0% | 🟢 Above Average |
| Jul 13 | 1,337 | 577 | 43.2% | +1.2% | 🟢 Above Average |
| Jul 14 | 1,353 | 530 | 39.2% | -2.8% | 🔴 Below Average |
| Jul 15 | 1,381 | 561 | 40.6% | -1.4% | 🔴 Below Average |

---

## 📁 Project Structure

```
uber-eda/
│
├── 📂 data/
│   ├── Uber_Request_Data.csv            # Raw dataset
│   └── Uber_Request_Data_Cleaned.csv    # Cleaned & engineered dataset
│
├── 📂 notebooks/
│   └── prepeda.ipynb                    # Full EDA notebook
│
├── 📂 scripts/
│   ├── uber_data_cleaning.py            # Step 1 — Data cleaning
│   ├── uber_eda_charts.py               # Step 2 — Histograms & boxplots
│   ├── uber_full_analysis.py            # Step 3 — Scatter, correlation, treatments
│   └── uber_duplicate_garbage_normalization.py  # Step 4 — Final treatments
│
├── 📂 outputs/
│   ├── uber_eda_charts.png              # Distribution charts
│   ├── uber_full_analysis.png           # Full analysis charts
│   ├── uber_duplicate_garbage_normalization.png
│   ├── uber_supply_gap_table.csv        # Supply gap pivot
│   ├── uber_daily_scorecard.csv         # Daily performance scorecard
│   └── Uber_Business_Insights_Report.pdf  # Final PDF report
│
├── 📂 dashboard/
│   └── uber_dashboard.xlsx              # Google Sheets dashboard
│
├── 📂 sql/
│   └── uber_query.sql                   # SQL analysis queries
│
└── README.md
```

---

## 🔧 Pipeline Walkthrough

### Step 1 — Data Cleaning
```python
# Fix mixed timestamp formats
df['Request timestamp'] = pd.to_datetime(
    df['Request timestamp'], format='mixed', dayfirst=True
)

# Fix Driver id float → nullable integer
df['Driver id'] = df['Driver id'].astype('Int64')
```

**Issues found and fixed:**

| Issue | Action |
|---|---|
| Mixed timestamp formats (2 formats) | Unified with `format='mixed'` |
| Driver id stored as float | Cast to `Int64` nullable integer |
| 2,650 nulls in Driver id | ✅ Keep — structurally valid (No Cars Available) |
| 3,914 nulls in Drop timestamp | ✅ Keep — structurally valid (incomplete trips) |
| Duplicate rows | ✅ None found |
| Garbage values | ✅ None found |

---

### Step 2 — Feature Engineering
```python
df['hour']         = df['Request timestamp'].dt.hour
df['date']         = df['Request timestamp'].dt.date
df['day_of_week']  = df['Request timestamp'].dt.day_name()
df['duration_min'] = ((df['Drop timestamp'] - df['Request timestamp'])
                      .dt.total_seconds() / 60).round(1)

bins   = [0, 5, 10, 17, 21, 24]
labels = ['Late Night', 'Morning', 'Afternoon', 'Evening', 'Night']
df['time_slot'] = pd.cut(df['hour'], bins=bins, labels=labels, right=False)
```

---

### Step 3 — Outlier Treatment

| Method | Result | Decision |
|---|---|---|
| IQR (1.5x fence) | 0 outliers (fence: 6.5–98.5 min) | ✅ No treatment |
| Z-score > 3 | 0 outliers | ✅ No treatment |
| Z-score > 2 | 30 rows (1.1%) | ✅ Keep — valid edge cases |

---

### Step 4 — Correlation & Multicollinearity

| Pair | Correlation | Finding |
|---|---|---|
| Hour ↔ Time Slot | r = 0.97 | ⚠️ Multicollinear — use only one |
| Hour ↔ Duration | r = -0.02 | ✅ Independent |
| Pickup ↔ Hour | r = 0.38 | ✅ Mild — expected |

---

### Step 5 — Normalisation

```python
from sklearn.preprocessing import MinMaxScaler, StandardScaler

# Min-Max (0–1) → for KNN, Neural Networks
mm_scaled = MinMaxScaler().fit_transform(df[['hour', 'duration_min']])

# Z-score → for Linear Regression, PCA
std_scaled = StandardScaler().fit_transform(df[['hour', 'duration_min']])
```

---

## 📈 Visualisations

The project produces **4 multi-chart figures**:

| Figure | Charts Included |
|---|---|
| `uber_eda_charts.png` | Hourly stacked bar, Duration histogram, Status bar, Duration boxplot |
| `uber_full_analysis.png` | 3 scatter plots, Correlation heatmap, Missing value analysis, Outlier treatment |
| `uber_duplicate_garbage_normalization.png` | Duplicate check, Garbage value check, Before/after normalisation, Stats table |
| Dashboard | 10 charts across Pivot 1–10 |

---

## 📊 Dashboard

Built in **Google Sheets** with 10 charts across a structured 4-row layout:

```
┌──────────────────────────────────────────────────────────────────┐
│  6,745  │  42%  │  19%  │  39%  │  52 min  │  300 drivers        │
│  Req    │ Comp  │ Canc  │ NoCar │  Avg Dur │  Active             │
├──────────────┬─────────────────────┬────────────────────────────┤
│ Chart 1      │ Chart 2             │ Chart 3                    │
│ Hourly Stack │ Status Donut        │ City vs Airport Column     │
├──────────────┴──────────┬──────────┴────────────────────────────┤
│ Chart 4 Time Slot       │ Chart 5 Line — City vs Airport/Hour   │
├─────────────────────────┴──────────┬───────────────────────────┤
│ Chart 6 Daily Trend                │ Chart 7 Duration Bar       │
├───────────┬────────────────────────┴───────────────────────────┤
│ Chart 8   │ Chart 9 Completion Rate  │ Chart 10 Cancellations   │
│ 100% Stack│ Line by Hour            │ by Slot Column            │
└───────────┴─────────────────────────┴──────────────────────────┘
```

---

## 🗄️ SQL Analysis

```sql
-- Status distribution
SELECT Status, COUNT(*) AS total
FROM uber_requests
GROUP BY Status;

-- Hourly demand
SELECT hour, COUNT(*) AS requests
FROM uber_requests
GROUP BY hour
ORDER BY hour;

-- Average trip duration (completed only)
SELECT AVG(duration_min) AS avg_duration
FROM uber_requests
WHERE Status = 'Trip Completed';

-- Supply gap by time slot
SELECT time_slot,
       COUNT(*) AS total_requests,
       SUM(CASE WHEN Status = 'Trip Completed' THEN 1 ELSE 0 END) AS completed,
       SUM(CASE WHEN Status != 'Trip Completed' THEN 1 ELSE 0 END) AS unserved,
       ROUND(SUM(CASE WHEN Status != 'Trip Completed' THEN 1 ELSE 0 END) * 100.0
             / COUNT(*), 1) AS unserved_pct
FROM uber_requests
GROUP BY time_slot
ORDER BY unserved_pct DESC;
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| **Python 3.12** | Core analysis language |
| **Pandas** | Data manipulation & cleaning |
| **Matplotlib** | Chart generation |
| **Seaborn** | Statistical visualisation |
| **Scipy** | Z-score outlier detection |
| **Scikit-learn** | Min-Max & Z-score normalisation |
| **ReportLab** | PDF report generation |
| **Google Sheets** | Interactive dashboard |
| **MySQL** | SQL-based querying |
| **Jupyter Notebook** | EDA workflow |

---

## ▶️ How to Run

```bash
# 1. Clone the repo
git clone https://github.com/yourusername/uber-eda.git
cd uber-eda

# 2. Install dependencies
pip install pandas matplotlib seaborn scipy scikit-learn reportlab

# 3. Run cleaning script
python scripts/uber_data_cleaning.py

# 4. Run EDA charts
python scripts/uber_eda_charts.py

# 5. Run full analysis
python scripts/uber_full_analysis.py

# 6. Generate PDF report
python scripts/uber_report.py
```

Or open `notebooks/prepeda.ipynb` in Jupyter to run the full pipeline interactively.

---

## 💡 Business Recommendations

Based on the analysis, four targeted interventions are recommended:

**R1 — Airport Evening Surge Pricing**
Deploy surge pricing at the Airport between 17:00–21:00 to attract drivers ahead of peak flight arrival hours. The Evening slot has a 66% unserved rate — the worst of any window.

**R2 — Anti-Cancellation Policy (City Morning)**
Introduce monitoring and penalties for City cancellations during 05:00–10:00. With 843 cancellations in this single window, this is the highest-impact single intervention available.

**R3 — Night Shift Driver Programme**
Introduce a dedicated night-shift driver pool with premium night rates to address the 57.9% unserved rate in the Night slot caused entirely by no-car availability.

**R4 — Proactive Driver Positioning**
Use predictive nudges to pre-position drivers near the Airport before 17:00 and in the City before 05:00, turning a reactive supply response into a proactive one.

---

## 👤 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [yourlinkedin](https://linkedin.com/in/yourlinkedin)

---

<p align="center">
  <i>Built as part of an end-to-end data analysis project — from raw CSV to business insights.</i>
</p>
