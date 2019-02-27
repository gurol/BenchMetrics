#' MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Experimenter Stage-3)
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
#' @title MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Experimenter Stage-3)
#' @date 25 February 2019
#' @version 1.0
#' @note version history 
#' 1.0, 25 February 2019, The first version  
#' @description Experiment the Stage-3 of the benchmark  

source('Benchmark3_MetaMetrics.R')

storeMetaMetricsBenchmarkingResultsInCSVFiles <- function()
{
  cat('Calculating Meta-metric 1: base measure correlations (UBMcorr)...')
  dfResult <- getUBMcorrs()
  write.table(roundDataFrame(dfResult, 2), file='../results/Stage3/1_UBMcorrs.csv',
              sep=',', dec='.', row.names=TRUE, col.names=NA, fileEncoding="UTF-8")
  cat(' [done]\n');
  
  cat('Calculating Meta-metric 2: prevalence uncorrelations (UPuncorr)...')
  dfResult <- getUPuncorrs()
  write.table(roundDataFrame(dfResult, 4), file='../results/Stage3/2_UPUncorrs.csv',
              sep=',', dec='.', row.names=FALSE, fileEncoding="UTF-8")
  cat(' [done]\n');
  
  cat('Calculating Meta-metric 3: distinctnessess (UDist)...')
  dfResult <- getUDists()
  write.table(roundDataFrame(dfResult, 3), file='../results/Stage3/3_UDists.csv',
              sep=',', dec='.', row.names=FALSE, fileEncoding="UTF-8")
  cat(' [done]\n');
  
  cat('Calculating Meta-metric 4: monoticness (UMono)...')
  dfResult <- getUMonos()
  write.table(roundDataFrame(dfResult, 3), file='../results/Stage3/4_UMonos.csv',
              sep=',', dec='.', row.names=TRUE, col.names=NA, fileEncoding="UTF-8")
  cat(' [done]\n');
  
  cat('Calculating Meta-metric 5: output smoothness (UOsmo)...')
  dfResult <- getUOsmos()
  write.table(roundDataFrame(dfResult, 3), file='../results/Stage3/5_UOsmos.csv',
              sep=',', dec='.', row.names=TRUE, col.names=NA, fileEncoding="UTF-8")
  cat(' [done]\n');
  
  cat('Calculating Meta-metric 6: consistencies (UCons) and Meta-metric 7: discriminancies (UDisc)...\n')
  dfResult <- getUConsesAndUDiscs(show_progress=TRUE)
  write.table(roundDataFrame(dfResult, 3), file='../results/Stage3/6_UConses_and_7_UDiscs.csv',
              sep=',', dec='.', row.names=FALSE, fileEncoding="UTF-8")
  cat('\n[done]\n');
  
  cat('All meta-metrics are calculated and the results are saved in Results folder/pane')
}

showAllMetaMetrics <- function()
{
  # getDescriptiveStatistics()
  
  cat('Meta-Metric 1: UBMcorr:\n')
  print(getUBMcorrs())
  
  cat('\nMeta-Metric 2: UPuncorr:\n')
  print(getUPuncorrs())
  
  cat('\nMeta-Metric 3: UDist:\n')
  print(getUDists())
  
  cat('\nMeta-Metric 4: UOsmo:\n')
  print(getUOsmos())
  
  cat('\nMeta-Metric 5: UMono:\n')
  print(getUMonos())
  
  cat('\nMeta-Metric 6 and 7: UCons and UDiscs:\n')
  getUConsesAndUDiscs()
}
