#' MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Time Test)
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
#' @title MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Time Test)
#' @date 25 February 2019
#' @version 1.0
#' @note version history
#' 1.0, 25 February 2019, The first version  
#' @description R scripts for testing time elapsed during calculation of 7 new
#' meta-metrics per different sample size (Sn)  

source('Benchmark3_MetaMetrics.R')

# Tested sample sizes
test.Sns <- c(10, 25, 50, 75, 100, 125, 150, 175, 200, 225, 250)

timeTest <- function(sn=10, name.meta_metric, file_prefix='MetricSpaces_Sn_')
{
  load(paste0(file_prefix, sn, '.RData'), .GlobalEnv)
  start.time <- Sys.time()
  print(start.time)
  
  switch (name.meta_metric,
          UBMcorr = print(getBaseMeasureCorrelations(MCC)),
          UPuncorr = print(getPrevalenceUncorrelations(MCC)),
          UDist = print(getDistinctness(MCC)),
          UOsmo = print(getOutputSmoothness(MCC)),
          UMono = print(getMonotonicness(MCC)),
          UCons = print(getUConsesAndUDiscs(df=data.frame(CK, MCC))),
          UDisc = 1,
          stopifnot(FALSE)
  )
  
  end.time <- Sys.time()
  print(end.time)
  # elapsed.time <- end.time-start.time
  cat(paste('For Sn=', sn, 'with', length(MCC), 'combinations\n', sep='\t'))
  elapsed.time <- difftime(end.time, start.time, units='mins')
  print(elapsed.time)
}

timeTestAllSns <- function(name.meta_metric, file_prefix='MetricSpaces_Sn_')
{
  cat(paste0('\n\nTesting', name.meta_metric, '...\n'))
  for (sn in test.Sns) {
    # if (sn <= 25)
    timeTest(sn, name.meta_metric, file_prefix)
  }
}

timeTestAll <- function(file_prefix='MetricSpaces_Sn_')
{
  for (name.meta_metric in names.meta_metrics) {
    timeTestAllSns(name.meta_metric, file_prefix)
  }
}
