#' MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Experimenter Stage-1)
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
#' @title MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Experimenter Stage-1)
#' @date 25 February 2019
#' @version 1.0
#' @note version history 
#' 1.0, 25 February 2019, The first version  
#' @description Experiment the Stage-1 of the benchmark

source('Benchmark1_ExtremeCases.R')

storeExtremeCasesBenchmarkingResultsInCSVFiles <- function()
{
  cat('Initializing extreme cases...');
  extreme_base_measures <<- initConfusionMatrixExtreme()
  cat(' [done]\n')
  
  cat('Calculating metric values for the extreme cases...')
  dfResult <- getExtremeValuesForAll()
  write.table(roundDataFrame(dfResult, 4), file='../results/Stage1/ExtremeCases.csv',
              sep=',', dec='.', row.names=TRUE, col.names=NA, fileEncoding="UTF-8")
  cat(' [done]\n');
}
