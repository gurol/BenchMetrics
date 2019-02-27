#' MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Metrics)
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
#' @title MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Metrics)
#' @date 25 February 2019
#' @version 1.1
#' @note version history
#' 1.1, 25 February 2019, 
#' 1.0, 15 May 2018, The first version  
#' @description Information and some paremeters for the benchmarked 13 performance metrics

source('TasKarPlot.R')
source('utils.R')

benchmark.metrics <- data.frame(
  Colors.Level=c(rep(metric.colors[1], 5), # Base level
                 rep(metric.colors[2], 7), # 1st level
                 metric.colors[3]),        # 2nd level
  Colors=c(
    rep(metric.colors[1], 4), '#f35e5a',   # Base level
    '#c78006', '#829d05', '#17b12b', '#18b78d', '#15abdc', '#5086ff', # 1st lev.
    '#d052fa',
    '#fc42b6'), # 2nd level
  Marker.Letters=c(
    #   1   2    3   4    5
    #   P...p    V   v    A
    80, 112, 86, 118, 65, # Base level
    #   6    7    8   9   10  11  12
    #   i    m    B   G   I   F   C
    105, 109, 66, 71, 73, 70, 67, # 1st level
    #   13
    #   M
    77), # 2nd level
  Marker.Shapes = c(
    #   1   2    3   4    5
    #   P...p    V   v    +
    80, 112, 86, 118, 3, # Base level
    #   6  7  8  9  10 11  12
    #   ^  v  x  o  <> [] [.]
    2, 6, 4, 1, 5, 0, 15, # 1st level
    #   13
    #   (.)
    20), # 2nd level
  stringsAsFactors=FALSE
)

benchmark.metrics.names <- c(
  'TPR', 'TNR', 'PPV', 'NPV', 'ACC', # Base measures
  'INFORM', 'MARK', 'BACC', 'G', 'nMI', 'F1', 'CK', # 1st
  'MCC')
benchmark.metrics.names.group1 <- benchmark.metrics.names[
  !benchmark.metrics.names %in% c('TNR', 'PPV', 'NPV', 'MARK')]

row.names(benchmark.metrics) <- benchmark.metrics.names

benchmark.metrics.cex.letters <- 1.33

# Helper function for some meta-metrics
getMetricValue<-function(name.metric, TP, FP, FN, TN)
{
  P <- TP + FN
  N <- FP + TN
  OP <- TP + FP
  ON <- FN + TN
  TC <- TP + TN
  FC <- FP + FN
  Sn <- P + N
  
  switch (name.metric,
          TPR = TP/P,
          TNR = TN/N,
          PPV = TP/OP,
          NPV = TN/ON,
          ACC = TC/Sn,
          INFORM = (TP*N + TN*P)/(P*N) - 1,
          MARK = (TP*ON + TN*OP)/(OP*ON) - 1,
          BACC = (TP*N + TN*P)/(2*P*N),
          G = sqrt(TP*TN/(P*N)),
          PREV = P/Sn,
          BIAS = OP/Sn,
          nMI = {
            # The same as nMIari
            mi <- (klogKByN(TP/Sn, P*OP/Sn^2) + klogKByN(FP/Sn, N*OP/Sn^2) + 
                     klogKByN(FN/Sn, P*ON/Sn^2) + klogKByN(TN/Sn, N*ON/Sn^2))
            hu <- -klogK(OP/Sn)-klogK(ON/Sn)
            hv <- -klogK(P/Sn)-klogK(N/Sn)
            nMI = 2*mi/(hu+hv)
          },
          F1 = 2*TP/(2*TP + FC),
          CK = {
            result <- 2*(TP*TN - FP*FN)/(P*ON + N*OP)
            CK = ifelse(is.nan(result), 0, result)
          },
          nCK = {
            result <- 2*(TP*TN - FP*FN)/(P*ON + N*OP)
            nCK = (ifelse(is.nan(result), 0, result) + 1)/2.0
          },
          MCC = {
            result <- (TP*TN - FP*FN)/sqrt(P*N*OP*ON)
            MCC = ifelse(is.nan(result), 0, result)
          },
          nMCC = {
            result <- (TP*TN - FP*FN)/sqrt(P*N*OP*ON)
            nMCC = (ifelse(is.nan(result), 0, result) + 1)/2.0
          },
          stopifnot(FALSE)
  )
}
