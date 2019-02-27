#' MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Stage 3)
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
#' @keywords binary classification, machine learning, performance metrics, meta-metrics  
#' @title MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Stage 3)
#' @date 25 February 2019
#' @version 1.1
#' @note version history
#' 1.1, 25 February 2019, UOsmo is added
#' 1.0, 15 May 2018, The first version
#' 0.1, December 2017, Draft version
#' @description R scripts for calculating/analyzing 7 new meta-metrics (i.e.
#' metrics about (performance) metrics).  

# Libraries
# `e1071` for skewnes and kurtosis  
library(e1071)

source('TasKarMath.R')
source('utils.R')
source('BenchmarkedMetrics.R')
# TasKar.R should be sourced for getMetricValue function

#                        1          2           3        4
names.meta_metrics <- c('UBMcorr', 'UPuncorr', 'UDist', 'UOsmo',
                        #                        5        6        7
                        'UMono', 'UCons', 'UDisc')

# Meta-Metric 1: UBMcorr
getBaseMeasureCorrelations<-function(metric_space, method='spearman', round=2)
{
  corr_TP <- round(
    cor(TP, metric_space, method=method, use='na.or.complete'), round)
  corr_FP <- round(
    cor(FP, metric_space, method=method, use='na.or.complete'), round)
  corr_FN <- round(
    cor(FN, metric_space, method=method, use='na.or.complete'), round)
  corr_TN <- round(
    cor(TN, metric_space, method=method, use='na.or.complete'), round)
  
  corrs <- c(corr_TP, corr_TN, corr_FP, corr_FN)
  names(corrs) <- c('TP', 'TN', 'FP', 'FN')
  
  return (corrs)
}

# Meta-Metric 1: UBMcorr for multiple metrics
getUBMcorrs <- function(
  metric_spaces=dataFrameByNames(benchmark.metrics.names))
{
  UBMcorrs <- NULL
  for (i in 1:ncol(metric_spaces)) {
    UBMcorrs <- cbind(UBMcorrs, getBaseMeasureCorrelations(metric_spaces[[i]]))
  }
  
  colnames(UBMcorrs) <- names(metric_spaces)
  
  # Sorting metrics
  UBMcorrs <- as.data.frame(t(UBMcorrs))
  UBMcorrs$UBMcorr <- normalize(
    (UBMcorrs$TP - UBMcorrs$FP - UBMcorrs$FN + UBMcorrs$TN)/4,
    xmin=-1, xmax=1)
  UBMcorrs <- UBMcorrs[with(UBMcorrs, order(-UBMcorr, -TP, -TN)), ]
  
  return (as.data.frame(t(UBMcorrs)))
}

# Meta-Metric 2: UPuncorr
getPrevalenceUncorrelations<-function(metric_space, method='spearman', round=2)
{
  uncorr_PREV <- 1 -
    abs(round(
      cor(PREV, metric_space, method=method, use='na.or.complete'),
      round))
  
  uncorr <- c(uncorr_PREV)
  names(uncorr) <- c('PREV')
  
  return (uncorr)
}

# Meta-Metric 2: UPuncorr for multiple metrics
getUPuncorrs <- function(
  metric_spaces=dataFrameByNames(benchmark.metrics.names))
{
  UPuncorrs <- NULL
  for (i in 1:ncol(metric_spaces)) {
    UPuncorrs <- cbind(UPuncorrs,
                       getPrevalenceUncorrelations(metric_spaces[[i]]))
  }
  
  colnames(UPuncorrs) <- names(metric_spaces)
  
  UPuncorrs <- as.data.frame(t(UPuncorrs))
  UPuncorrs$UPuncorr <- UPuncorrs$PREV
  UPuncorrs <- UPuncorrs[with(UPuncorrs, order(-UPuncorr)), ]
  
  return (as.data.frame(t(UPuncorrs)))
}

# Meta-Metric 3: UDist
getDistinctness<-function(metric_space, round=4)
{
  mcount <- length(metric_space)
  munique_metric <- unique(metric_space[!is.nan(metric_space)])
  distinctness <- round(length(munique_metric)/mcount, round)
  
  names(distinctness) <- c('UDist')
  
  return (distinctness)
}

# Meta-Metric 3: UDist for multiple metrics
getUDists <- function(metric_spaces=dataFrameByNames(benchmark.metrics.names),
                      order_metrics=FALSE)
{
  for (i in 1:ncol(metric_spaces)) {
    if (i == 1) {
      UDists <- cbind(getDistinctness(metric_spaces[[i]]))
    }
    else {
      UDists <- cbind(UDists, getDistinctness(metric_spaces[[i]]))
    }
  }
  
  colnames(UDists) <- names(metric_spaces)
  
  if (order_metrics) {
    UDists <- as.data.frame(t(UDists))
    # Order with preserving row and column names
    UDists <- UDists[order(UDists$UDist, decreasing=TRUE), ,drop=FALSE]
    
    UDists <- as.data.frame(t(UDists))
  }
  
  UDists <- cbind(UDists, Sn=mean(Sn), Permutation=length(Sn))
  
  return (UDists)
}

# Meta-Metric 4: UOsmo
getOutputSmoothness <- function (metric_space, round=2)
{
  metric_space.no_na <- metric_space[!is.nan(metric_space)]
  metric_space.sorted <- sort(metric_space.no_na)
  # The smaller the smoother
  # The coefficient of variation for one lagged self-difference
  smoothness <- round(sd(diff(metric_space.sorted))/
                        abs(mean(diff(metric_space.sorted))),
                      round)
  
  names(smoothness) <- c('UOsmo')
  
  return (smoothness)
}

# Meta-Metric 4: UOsmo for multiple metrics
getUOsmos <- function(metric_space=dataFrameByNames(benchmark.metrics.names),
                      order_metrics=FALSE)
{
  for (i in 1:ncol(metric_space)) {
    if (i == 1) {
      UOsmos <- cbind(getOutputSmoothness(metric_space[[i]]))
    }
    else {
      UOsmos <- cbind(UOsmos, getOutputSmoothness(metric_space[[i]]))
    }
  }
  
  colnames(UOsmos) <- names(metric_space)
  
  if (order_metrics) {
    UOsmos <- as.data.frame(t(UOsmos))
    # Order with preserving row and column names
    UOsmos <- UOsmos[order(UOsmos$UOsmos, decreasing=TRUE), ,drop=FALSE]
    
    UOsmos <- as.data.frame(t(UOsmos))
  }

  return (UOsmos)
}

# Meta-Metric 5: UMono
getMonotonicness <- function(metric_space, name.metric=NULL, verbose=FALSE)
{
  if (is.null(name.metric))
    name.metric <- deparse(substitute(metric_space))

  mcount <- length(metric_space)
  count_violations <- c(0, 0, 0, 0)
  names(count_violations) <- c('TP', 'TN', 'FP', 'FN')
  for (i in 1:mcount) {
    metric_value <- metric_space[i]
    TP_value <- TP[i]
    FP_value <- FP[i]
    FN_value <- FN[i]
    TN_value <- TN[i]
    if (is.nan(metric_value) == FALSE) {
      # Monotonically increasing for TP?
      v <- getMetricValue(name.metric, TP_value+1, FP_value, FN_value, TN_value)
      if (is.nan(v) == FALSE && v < metric_value) {
        count_violations['TP'] <- count_violations['TP'] + 1
        if (verbose)
          cat(paste0(
            'Violation: TP:', TP_value, ', FP:', FP_value,
            ', FN:', FN_value, ', TN:', TN_value,
            ' -> ', name.metric, ':', metric_value,
            '. TP+1:', TP_value+1, ' -> ', name.metric, ':', v, '\n'))
      }
      # Monotonically increasing for TN?
      v <- getMetricValue(name.metric, TP_value, FP_value, FN_value, TN_value+1)
      if (is.nan(v) == FALSE && v < metric_value) {
        count_violations['TN'] <- count_violations['TN'] + 1
        if (verbose)
          cat(paste0(
            'Violation: TP:', TP_value, ', FP:', FP_value,
            ', FN:', FN_value, ', TN:', TN_value,
            ' -> ', name.metric, ':', metric_value,
            '. TN+1:', TN_value+1, ' -> ', name.metric, ':', v, '\n'))
      }
      # Monotonically increasing for FP decrease?
      if (FP_value > 0) {
        v <- getMetricValue(name.metric, TP_value, FP_value-1, FN_value, TN_value)
        if (is.nan(v) == FALSE && v < metric_value) {
          count_violations['FP'] <- count_violations['FP'] + 1
          if (verbose)
            cat(paste0(
              'Violation: TP:', TP_value, ', FP:', FP_value,
              ', FN:', FN_value, ', TN:', TN_value,
              ' -> ', name.metric, ':', metric_value,
              '. FP-1:', FP_value-1, ' -> ', name.metric, ':', v, '\n'))
        }
      }
      # Monotonically increasing for FN decrease?
      if (FN_value > 0) {
        v <- getMetricValue(name.metric, TP_value, FP_value, FN_value-1, TN_value)
        if (is.nan(v) == FALSE && v < metric_value) {
          count_violations['FN'] <- count_violations['FN'] + 1
          if (verbose)
            cat(paste0(
              'Violation: TP:', TP_value, ', FP:', FP_value,
              ', FN:', FN_value, ', TN:', TN_value,
              ' -> ', name.metric, ':', metric_value,
              '. FN-1:', FN_value-1, ' -> ', name.metric, ':', v, '\n'))
        }
      }
    }
  }
  
  monothonic_rate <- 1.0 - (count_violations / mcount)
  
  return (monothonic_rate)
}

# Meta-Metric 5: UMono for multiple metrics
getUMonos <- function(names.metric_spaces=benchmark.metrics.names)
{
  UMonos <- NULL
  for (name.metric_space in names.metric_spaces) {
    UMonos <- cbind(UMonos, getMonotonicness(get(name.metric_space),
                                             name.metric_space))
  }

  colnames(UMonos) <- names.metric_spaces

  UMonos <- as.data.frame(t(UMonos))
  UMonos$UMono <- (UMonos$TP + UMonos$TN + UMonos$FP + UMonos$FN)/4
  UMonos <- UMonos[with(UMonos, order(-UMono)), ]

  return (as.data.frame(t(UMonos)))
}

# Meta-Metric 6 and 7: UCons and UDiscs
getUniversalConsistencyAndDiscriminancy <- function(
  metric_space_1, metric_space_2,
  name.metric_space_1=NULL, name.metric_space_2=NULL)
{
  size <- length(metric_space_1)
  stopifnot(size == length(metric_space_2))
  inconsistent_cases <- 0
  metric_1_discriminant_cases <- 0
  metric_2_discriminant_cases <- 0
  cases <- 0

  for (i in 1:size) {
    metric_1_value <- metric_space_1[i]
    metric_2_value <- metric_space_2[i]
    if ((i+1) > size)
      next
    for (j in (i+1):size) {
      metric_1_other <- metric_space_1[j]
      metric_2_other <- metric_space_2[j]
      nan_metrics <- any(is.nan(c(metric_1_value, metric_1_other,
                                  metric_2_value, metric_2_other)))
      if (nan_metrics)
        # Exclude any NaNs
        next
      
      cases <- cases + 1
      
      if (metric_1_value > metric_1_other &&
          metric_2_value < metric_2_other) {
        # It could be metric_2_value =< metric_2_other
        # But, metric_1_value > metric_1_other and
        #      metric_2_value == metric_2_other is also consistent
        inconsistent_cases <- inconsistent_cases + 1
      }
      else if (metric_1_value < metric_1_other &&
               metric_2_value > metric_2_other) {
        inconsistent_cases <- inconsistent_cases + 1
      }
      # else
      #   consistent_cases = cases - inconsistent_cases
      #   consistent_cases <- consistent_cases + 1
      
      if (metric_1_value != metric_1_other &&
          metric_2_value == metric_2_other) {
        metric_1_discriminant_cases <- metric_1_discriminant_cases + 1
      }
      else if (metric_2_value != metric_2_other &&
               metric_1_value == metric_1_other) {
        metric_2_discriminant_cases <- metric_2_discriminant_cases + 1
      }

    }
  }
  
  if (is.null(name.metric_space_1))
    name.metric_space_1 <- deparse(substitute(metric_space_1))
  if (is.null(name.metric_space_2))
   name.metric_space_2 <- deparse(substitute(metric_space_2))
  
  return (data.frame(
    metrics=paste(name.metric_space_1, 'vs.', name.metric_space_2),
    consistency=(1 - inconsistent_cases/cases),
    discriminancy_metric_1=metric_1_discriminant_cases/cases,
    discriminancy_metric_2=metric_2_discriminant_cases/cases,
    stringsAsFactors=FALSE))
}

# Meta-Metric 6 and 7: UCons and UDiscs for multiple metrics
getUConsesAndUDiscs <- function(
  metric_spaces=dataFrameByNames(benchmark.metrics.names), show_progress=TRUE)
{
  metric_count <- ncol(metric_spaces)
  names.metrics <- colnames(metric_spaces)
  UConsesAndUDiscs <- NULL
  for (i in 1:metric_count) {
    if (i+1 > metric_count)
      break
    for (j in (i+1):metric_count) {
      UConsAndUDisc <- getUniversalConsistencyAndDiscriminancy(
        metric_spaces[[i]], metric_spaces[[j]],
        names.metrics[i], names.metrics[j])
      if (show_progress)
        cat(paste(UConsAndUDisc[1, 1], '[done]\n'))
      UConsesAndUDiscs <- rbind(UConsesAndUDiscs, UConsAndUDisc)
    }
  }
  
  return (UConsesAndUDiscs)
}
