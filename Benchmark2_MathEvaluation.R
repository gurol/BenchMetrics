#' MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Stage 2)
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
#' @title MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Stage 2)
#' @date 25 February 2019
#' @version 1.1
#' @note version history
#' 1.1, 25 February 2019, Smoothness plot is added 
#' 1.0, 15 May 2018, The first version
#' 0.1, December 2017, Draft version
#' @description R scripts for evaluating performance metrics from mathematical perspective 

plotDescriptiveCriteria <- function(
  metrics=dataFrameByNames(benchmark.metrics.names.group1),
  metric_names=benchmark.metrics.names.group1,
  cols=benchmark.metrics[benchmark.metrics.names.group1, c('Colors')],
  mfrow=bestRowColumnLayout(length(benchmark.metrics.names.group1)))
{
  par(mfrow=mfrow)
  for (i in 1:length(metric_names)) {
    plotMetricHist(
      metric=metrics[[i]], metric_name=metric_names[i],
      extras=c('add.normal'),
      color_metric=cols[i],
      color_element = 'black', color_note='black',
      color_set.others=c('#00008F', '#000000', '#23FFDC',
                         '#ECFF13', '#FF4A00', '#800000'))
  }
  par(mfrow=c(1,1))
}

plotOuputSmothness <- function(
  metrics=dataFrameByNames(benchmark.metrics.names.group1),
  metric_names=benchmark.metrics.names.group1,
  cols=benchmark.metrics[benchmark.metrics.names.group1, c('Colors')],
  mfrow=bestRowColumnLayout(length(benchmark.metrics.names.group1)))
{
  par(mfrow=mfrow)
  for (i in 1:length(metric_names)) {
    plot(
      sort(metrics[[i]]),
      xlab=NULL,
      ylab=metric_names[i],
      # pch=20, col=cols[i])
      type='l', col=cols[i])
  }
  par(mfrow=c(1,1))
}
