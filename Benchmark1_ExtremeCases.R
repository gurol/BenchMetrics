#' MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Stage 1)
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
#' @title MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Stage 1)
#' @date 25 February 2019
#' @version 1.1
#' @note version history
#' 1.1, 25 February 2019, 
#' 1.0, 15 May 2018, The first version
#' 0.1, December 2017, Draft version
#' @description R scripts for evaluating performance metrics in 13 extreme cases

source('BenchmarkedMetrics.R')
source('utils.R')
# TasKar.R should be sourced for getMetricValue function

#' ### initConfusionMatrixExtreme
#' Initialize confusion matrix (i.e. base measures) by calculating extreme
#' combination of base measure values (TP, FP, FN, TN) summing up the sample
#' size  
#' **Extreme cases**:  
#'  
#' Perfect True              Near Perfect True         All Equal
#' ------------------------- ------------------------- -------------------------
#' **TP**: 2000 **FP**:    0 **TP**: 1999 **FP**:    1 **TP**: 1000 **FP**: 1000
#' **FN**:    0 **TN**: 2000 **FN**:    1 **TN**: 1999 **FN**: 1000 **TN**: 1000
#'
#' Near Perfect False        Perfect False
#' ------------------------- -------------------------
#' **TP**: 1999 **FP**:    1 **TP**: 2000 **FP**:    0
#' **FN**:    1 **TN**: 1999 **FN**:    0 **TN**: 2000
#'
#' Near Perfect TP           Near Perfect TN
#' ------------------------- -------------------------
#' **TP**: 3997 **FP**:    1 **TP**:    1 **FP**:    1
#' **FN**:    1 **TN**:    1 **FN**:    1 **TN**: 3997
#'
#' Inverse Near Perfect TP   Inverse Near Perfect TN
#' ------------------------- -------------------------
#' **TP**:    1 **FP**: 1333 **TP**: 1333 **FP**: 1333
#' **FN**: 1333 **TN**: 1333 **FN**: 1333 **TN**:    1
#'
#' Zero N                    Zero ON
#' ------------------------- -------------------------
#' **TP**: 3999 **FP**:    0 **TP**: 3999 **FP**:    1
#' **FN**:    1 **TN**:    0 **FN**:    0 **TN**:    0
#'
#' Zero OP                   Zero P
#' ------------------------- -----------------------
#' **TP**:    0 **FP**:    0 **TP**:    0 **FP**:    1
#' **FN**:    1 **TN**: 3999 **FN**:    0 **TN**: 3999
#'
#'
#' **Parameters:**  
#' *sample_size*: Sample size  
#' **Return:**  
#' extreme base measures (TP, FP, FN, TN)  
#' **Example:** `extreme_base_measures <- initConfusionMatrixExtreme()`  
initConfusionMatrixExtreme <- function(sample_size=10000)
{
  extreme <- data.frame(
    TP=c(sample_size-1, sample_size-1, sample_size-3,
         (sample_size-1)/3, sample_size/2, sample_size/2-1,
         sample_size/4,
         1, 0, 1,
         1, 0, 0),
    FP=c(0, 1, 1,
         (sample_size-1)/3, 0, 1,
         sample_size/4,
         sample_size/2-1, sample_size/2, (sample_size-1)/3,
         1, 0, 1),
    FN=c(1, 0, 1,
         (sample_size-1)/3, 0, 1,
         sample_size/4,
         sample_size/2-1, sample_size/2, (sample_size-1)/3,
         1, 1, 0),
    TN=c(0, 0, 1,
         1, sample_size/2, sample_size/2-1,
         sample_size/4,
         1, 0, (sample_size-1)/3,
         sample_size-3, sample_size-1, sample_size-1),
    Direction=c('Progressive', 'Progressive', 'Progressive',
                'Regressive', 'Progressive', 'Progressive',
                'Contradicting',
                'Regressive', 'Regressive', 'Regressive',
                'Progressive', 'Progressive', 'Progressive'),
    Condition1stLevel=c('Zero N', 'Zero ON', '',
                        '', 'Zero FC', '',
                        '',
                        '', 'Zero TC', '',
                        '', 'Zero OP', 'Zero P'),
    InterpretedPerformance=c(
      'Almost Perfect P', 'Almost Perfect P', 'Almost Perfect P',
      'Confused in P, Worst in N', 'Perfect', 'Almost Perfect',
      'Confused',
      'Almost Worst', 'Worst', 'Confused in N, Worst in P',
      'Almost Perfect N', 'Almost Perfect N', 'Almost Perfect N'),
    ClassRatio=c('Positive', 'Almost Positive', 'Almost Positive',
                 'Moderately Positive', 'Balanced', 'Balanced',
                 'Balanced',
                 'Balanced', 'Balanced', 'Moderately Negative',
                 'Almost Negative', 'Almost Negative', 'Negative'),
    AnticipatedValue=c('~ 0.5', '~ 0.5', '> 0.5',
                       '~ 0.25', '1', '~ 1',
                       '0.5',
                       '~ 0', '0', '~ 0.25',
                       '> 0.5', '~ 0.5', '~ 0.5')
  )
  
  # summary <- paste(extreme$InterpretedPerformance,
  #                  'on', extreme$ClassRatio,
  #                  'with', extreme$Condition1stLevel,
  #                  paste0('(', extreme$AnticipatedValue, ')')
  #                  )
  row.names(extreme) <- paste0(extreme$TP, ',', extreme$FP,
                               ',', extreme$FN, ',', extreme$TN,
                               ' (', extreme$AnticipatedValue, ')')
  
  return (extreme)
}

# extreme_base_measures should be initialized
getExtremeValues <- function(metric_name)
{
  # Extreme base measure values
  extreme_metric_values <- numeric(0)
  for (i in 1:length(extreme_base_measures[, 1])) {
    extreme_metric_values[i] <- getMetricValue(metric_name,
                                               extreme_base_measures[, 1][i],
                                               extreme_base_measures[, 2][i],
                                               extreme_base_measures[, 3][i],
                                               extreme_base_measures[, 4][i])
  }
  
  return (extreme_metric_values)
}

getExtremeValuesForAll <- function(names.metrics=benchmark.metrics.names)
{
  names.cases <- paste('Case', seq(from=1, to=nrow(extreme_base_measures)))
  exreme_values <- emptyDataFrame(names.cases)
  
  for (name.metric in benchmark.metrics.names) {
    extreme_value <- as.data.frame(t(getExtremeValues(name.metric)))
    names(extreme_value) <- names.cases
    # exreme_values[, nrow(exreme_values) + 1] <- extreme_value
    exreme_values <- rbind(exreme_values, extreme_value)
    rownames(exreme_values)[nrow(exreme_values)] <- name.metric
  }
  
  return (t(exreme_values))
}
