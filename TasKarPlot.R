#' MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Plot)
#' Copyright (C) 2017-2019 Gürol Canbek  
#' This file is licensed under
#' 
#'   GNU Affero General Public License v3.0, GNU AGPLv3 
#' 
#' This program is free software: you can redistribute it and/or modify
#' it under the terms of the GNU Affero General Public License as published
#' by the Free Software Foundation, either version 3 of the License, or
#' (at your option) any later version.
#'
#' This program is distributed in the hope that it will be useful,
#' but WITHOUT ANY WARRANTY; without even the implied warranty of
#' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#' GNU Affero General Public License for more details.
#'
#' You should have received a copy of the GNU Affero General Public License
#' along with this program.  If not, see <https://www.gnu.org/licenses/>.
#' 
#' See the license file in <https://github.com/gurol/metametrics>
#'
#' @author Gürol Canbek, <gurol44@gmail.com>
#' @references <http://gurol.canbek.com>
#' @keywords binary classification, performance metrics, meta-metrics, time test  
#' @title MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Plot)
#' @date 15 May 2018
#' @version 1.0
#' @note version history
#' 1.0, 15 May 2018, The first version
#' 0.1, December 2017, Draft version
#' @description Plot utilities

#' ## Libraries
library(PerformanceAnalytics)
library(e1071)

source('TasKarColors.R')
source('utils.R')

#' ## Globals for functions

#' ### plotMetricHist
#' Plot histogram diagram for a metric with fitted normal distribution, density
#' and qqplot (quantile-quantile plot)  
#' **Parameters:**  
#' *metric*: Performance metric  
#' *metric_name*: Name of the metric (default NULL)  
#' *breaks*: Breaking methods (default: 'FD', Freedman-Diaconis, see hist for other options)  
#' *extras*: Extras embedded to the plot
#' 'add.normal': display a fitted normal distibution line over the mean
#' 'add.qqplot': display a small qqplot in the upper corner of the histogram plot
#' 'add.density': display the density plot
#' **Return:**  
#' none  
#' **Details:**  
#' Infinite values are discarded in the metric  
#' **Example:** `plotMetricHist(ACC)`
plotMetricHist <- function(metric, metric_name=NULL, breaks='FD',
                           extras=c('add.normal', 'add.qqplot'),
                           summary_stats_lines=c('mean', 'median', 'mode'),
                           color_metric='lightgray', color_note='darkgray',
                           color_element='darkgray',
                           color_set.others=c('#00008F', '#005AFF', '#23FFDC',
                                              '#ECFF13', '#FF4A00', '#800000'),
                           round_digit=2)
{
  if (is.null(metric_name))
    metric_name <- deparse(substitute(metric))
  
  xlab <- metric_name
  if (any(is.infinite(metric))) {
    metric <- metric[!is.infinite(metric)]
    xlab <- paste(metric_name, '(+/-Inf removed)')
  }
  
  lines <- numeric()
  
  mean_metric <- Inf
  median_metric <- Inf
  mode_metric <- Inf
  
  if ('mean' %in% summary_stats_lines) {
    mean_metric <- mean(metric, na.rm=TRUE)
    lines <- c(lines, mean_metric)
  }
  if ('median' %in% summary_stats_lines) {
    median_metric <- median(metric, na.rm=TRUE)
    lines <- c(lines, median_metric)
  }
  if ('mode' %in% summary_stats_lines) {
    unique_metric <- unique(round(metric[!is.nan(metric)], 2))
    mode_metric <- unique_metric[which.max(
      tabulate(match(metric[!is.nan(metric)], unique_metric)))]
    lines <- c(lines, mode_metric)
  }
  
  # Avoid overlapping vertical lines for the same metrics
  stat_counts <- length(lines)
  
  if (stat_counts > 2) {
    if (mean_metric == median_metric && median_metric == mode_metric) {
      summary_stats_lines <- c('mean=median=mode')
      lines <- c(mean_metric)
    }
    else if (mean_metric == median_metric) {
      summary_stats_lines <- c('mean=median', 'mode')
      lines <- c(mean_metric, mode_metric)
    }
    else if (mean_metric == mode_metric) {
      summary_stats_lines <- c('mean=mode', 'median')
      lines <- c(mean_metric, median_metric)
    }
    else if (median_metric == mode_metric) {
      summary_stats_lines <- c('mean', 'median=mode')
      lines <- c(mean_metric, median_metric)
    }
  }
  else if (stat_counts > 1) {
    if (mean_metric == median_metric) {
      summary_stats_lines <- c('mean=median')
      lines <- c(mean_metric)
    }
    else if (mean_metric == mode_metric) {
      summary_stats_lines <- c('mean=mode')
      lines <- c(mean_metric)
    }
    else if (median_metric == mode_metric) {
      summary_stats_lines <- c('median=mode')
      lines <- c(median_metric)
    }
  }
  else {
    # Single stats
  }
  
  xlabel <- paste0(xlab, ' (',
                   paste(paste(summary_stats_lines, round(lines, round_digit),
                               sep='='),
                         collapse=', '),
                   ')')
  
  chart.Histogram(metric,
                  methods=extras,
                  breaks=breaks,
                  xlab=xlabel,
                  note.lines=lines,
                  note.labels=summary_stats_lines,
                  note.color=color_note,
                  element.color=color_element,
                  probability=FALSE,
                  colorset = c(color_metric, color_set.others))
}

# Not optimum, ok for small number of subgraphs (i.e. < 10)
bestRowColumnLayout <- function(subgraph_count, max_col=3)
{
  if (subgraph_count <= max_col) {
    return (c(1, subgraph_count))
  }
  
  root_dim <- sqrt(subgraph_count)
  if (root_dim %% 1 == 0 & root_dim <= max_col) {
    return (c(root_dim, root_dim))
  }
  
  return (c((subgraph_count %/% max_col) +
              ifelse(subgraph_count %% max_col > 0, 1, 0),
            max_col))
}
