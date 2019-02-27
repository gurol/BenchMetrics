#' MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Metric Colors)
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
#' @title MetaMetrics – Binary-Classification Performance-Metrics Benchmarking (Metric Colors)
#' @date 25 February 2019
#' @version 1.0
#' @note version history
#' 1.0, 25 February 2019, The first version  
#' @description Color palette for benchmarked metrics 

library(RColorBrewer)

# For hexbin
hexbin.colors <- colorRampPalette(rev(brewer.pal(11, 'Spectral')))
# Color like jetcolors in MatLab
# See http://stackoverflow.com/questions/18360196/how-can-i-get-a-certain-colorful-scale-in-r
jet.colors <- colorRampPalette(c('#00007F', 'blue', '#007FFF', 'cyan',
                                 '#7FFF7F', 'yellow', '#FF7F00', 'red',
                                 '#7F0000'))

# Background colors   Base (0),  1st level  2nd level
metric.bgcolors <- c('#FED96F', '#FEE59D', '#FFF1CE')
# Forecolors        Base (0),  1st level  2nd level
metric.colors <- c('#974715', '#BD581A', '#E46A21')

# Background colors    Base (0),  1st level  2nd level  3rd level
measure.bgcolors <- c('#A6A6A6', '#BFBFBF', '#D9D9D9', '#F2F2F2')
# Forecolors         Base (0),  1st level  2nd level  3rd level
measure.colors <- c('#000000', '#000000', '#000000', '#000000')