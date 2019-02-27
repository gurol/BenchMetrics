## A reproducible research compedium of
# Meta-metrics: a new method for benchmarking binary-classification performance metrics

[![Last-changedate](https://img.shields.io/badge/last%20change-2019--02--26-brightgreen.svg)](https://github.com/gurol/metametrics) [![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)  [![ORCiD](https://img.shields.io/badge/ORCiD-0000--0002--9337--097X-green.svg)](https://orcid.org/0000-0002-9337-097X)

> [Gürol Canbek](http:gurol.canbek.com/Publications), Tugba Taskaya Temizel, and Seref Sagiroglu. (2019). Meta-Metrics: A New Method for Benchmarking Binary-Classification Performance Metrics. ***Knowledge-Based Systems***, Submitted

This repository provides ready-to-run open-source R scripts, example metric-spaces (i.e. universal base measure permutations for different sample sizes), and materials (e.g. tabular data and graphics) for benchmarking the robustness of thirteen well-known (classification performance) metrics via the seven new meta-metrics proposed in our article above.

The well-known metrics are True Positive Rate (*TPR*), True Negative Rate (*TNR*), Positive Predictive Value (*PPV*), Negative Predictive Value (*NPV*), Accuracy (*ACC*), Informedness (*INFORM*), Markedness (*MARK*), Balanced Accuracy (*BACC*), G (*G*), Normalized Mutual Information (*nMI*), F1 (*F1*), Cohen’s Kappa (*CK*), and Mathews Correlation Coefficient (*MCC*).

The proposed novel **metric-space** concept, seven **meta-metrics (metrics about metrics)** and three-staged benchmarking method are defined and described in the article.

__**Note**__: Please, cite our article if you would like to use and/or adapt the code, datasets, methodology, and other materials provided and [let us know](mailto:gurol44@gmail.com?subject=Meta-metrics). Thank you for your interest.

## Quick Start
Run the following commands in terminal and R in the directory having the scripts files provided in this repository.

Create the directories storing benchmark results in terminal or command line.

```
mkdir results
cd results
mkdir Stage1
mkdir Stage2
mkdir Stage3
```

Run the benchmark in R.

```R
# Load any metric-space with given sample size.
# Visit http://dx.doi.org/10.17632/64r4jr8c88.1 to download metric-spaces for larger sample sizes.
load('MetricSpaces_Sn_10.RData)
# Source the main experimenter script.
source('Experimenter.R')
# Start the benchmark
benchmark()
# 
```

### File Contents

```
/ [root]
├── code
│   ├── Benchmark1_ExtremeCases.R : Stage-1 (extreme cases) benchmarking
│   ├── Benchmark2_MathEvaluation.R : Stage-2 (mathematical evaluation) benchmarking
│   ├── Benchmark3_MetaMetrics.R : Stage-3 (meta-metrics) benchmarking
│   ├── BenchmarkedMetrics.R : Information about the benchmarked 13 metrics
│   ├── Experimenter.R : Experiment three-staged benchmarking for 13 metrics with given Sn
│   ├── Experimenter_BenchmarkStage1.R : Experiment Stage-1 benchmarking
│   ├── Experimenter_BenchmarkStage2.R : Experiment Stage-2 benchmarking
│   ├── Experimenter_BenchmarkStage3.R : Experiment Stage-1 benchmarking
│   ├── LICENSE : License file for the codes provided
│   ├── MetaMetricTimeTest.R : A test for revealing the calculation time of the meta-metrics
│   ├── README.md : This introduction file
│   ├── TasKarColors.R : Color information for the benchmarked metrics
│   ├── TasKarMath.R : Common R utilities for mathematical calculations
│   ├── TasKarPlot.R : Plotting R utilities
│   ├── main.R : Main experimentation starter R script
│   ├── run.sh : Shell script (internal)
│   └── utils.R : Common R utilities
│
├── data
│   ├── LICENSE : License file for the datasets provided
│   └── MetricSpaces_Sn_[10, 25, 50].RData : Metric-Spaces data for 13 metrics for different sample sizes (Sn).
│                                            Warning: Calculation takes too much time for Sn=50
└── results
    ├── Stage1
    │   └── ExtremeCases.csv : The ouputs of 13 benchmarked metrics in 13 extreme cases.
    │
    ├── Stage2
    │   ├── Fig1_MetricSpaceDistribution.png : Density plots for metric-space distribution (also appeared in the article)
    │   └── Fig1_MetricSpaceSmoothness.png : Metric-space output smoothness plots (also appeared in the article)
    │
    └── Stage3
        ├──  1_UBMcorrs.csv : Base measure correlations meta-metrics
        ├──  2_UPuncorrs.csv : Prevalence uncorrelations meta-metrics
        ├──  3_UDists.csv : Distinctness meta-metrics
        ├──  4_UMonos.csv : Monotonicness meta-metrics
        ├──  5_UOsmos.csv : Output smoothness meta-metrics
        └──  6_UConses_and_7_UDiscs.csv : Consistencies and discriminancies meta-metrics
```
