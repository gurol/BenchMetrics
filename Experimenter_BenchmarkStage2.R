#' MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Experimenter Stage-2)
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
#' @title MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Experimenter Stage-2)
#' @date 25 February 2019
#' @version 1.0
#' @note version history 
#' 1.0, 25 February 2019, The first version  
#' @description Experiment the Stage-2 of the benchmark

source('Benchmark2_MathEvaluation.R')

plotGraph <- function(FUN, plot_to_file=FALSE, filepath=NULL, width=20, height=15, units='cm', res=300, file_type='png')
{
  if (plot_to_file) {
    if (file_type == 'png') {
      png(filename=filepath, width=width, height=height, units=units, res=res)
    }
    else {
      pdf(filename=filepath, width=width, height=height, units=units, res=res)
    }
  }
  FUN()
  if (plot_to_file) {
    dev.off()
  }
}

plotAndStoreGraphs <- function()
{
  cat('Plotting metric-space density graphs...');
  plotGraph(plotDescriptiveCriteria,
            plot_to_file=TRUE,
            filepath='../results/Stage2/Fig1_MetricSpaceDistribution.png')
  cat(' [done]\n');
  
  cat('Plotting metric-space ouput smoothness graphs...');
  plotGraph(plotOuputSmothness,
            plot_to_file=TRUE,
            filepath='../results/Stage2/Fig2_MetricSpaceSmoothness.png')
  cat(' [done]\n');
}
