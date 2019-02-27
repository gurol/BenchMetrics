#' MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Experimenter)
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
#' @title MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Experimenter)
#' @date 25 February 2019
#' @version 1.0
#' @note version history 
#' 1.0, 25 February 2019, The first version  
#' @description Information and some paremeters for the benchmarked 13 performance metrics

# Benchmarking: Stage-1
source('Experimenter_BenchmarkStage1.R')
# Benchmarking: Stage-2
source('Experimenter_BenchmarkStage2.R')
# Benchmarking: Stage-3
source('Experimenter_BenchmarkStage3.R')

benchmark <- function()
{
  cat('\nBenchmarking Stage-1: Extreme cases...\n')
  cat('***********************************************\n')
  storeExtremeCasesBenchmarkingResultsInCSVFiles()
  
  cat('\nBenchmarking Stage-2: Mathematical evaluation...\n')
  cat('***********************************************\n')
  plotAndStoreGraphs()
  
  cat('\nBenchmarking Stage-3: Meta-metrics...\n')
  cat('***********************************************\n')
  storeMetaMetricsBenchmarkingResultsInCSVFiles()
  
  cat('\n\nBenchmarking is finished. See the results.\n')
}