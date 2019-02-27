#' TasKarMath – Common Modules (Math)
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
#' See the license file in <https://github.com/gurol>
#'
#' @author Gürol Canbek, <gurol44@gmail.com>
#' @references <http://gurol.canbek.com>
#' @keywords mathematics, statistics  
#' @title TasKarMath – Common Math Module
#' @date 3 Nov 2018
#' @version 1.0
#' @note version history
#' December 2017
#' 1.0, 3 Nov 2018, The first version  
#' @description R scripts for common mathematical operations.

#' ### klogK
#' Return k.log(k) avoiding 0.log(0) returns NaN according to "the convention
#' that 0.log(0) = 0, which is easily justified by continuity since
#' x log x -> 0 as x-> 0. Thus adding terms of zero probability does not change
#' the entropy." [Cover & Thomas 1991]
#' Thomas M. Cover, Joy A. Thomas, Elements of Information Theory, 2nd Ed,
#' Wiley-Interscience, 2006, Hoboken, New Jersey, p748
#' Page 14.  
#' **Parameters:**  
#' *k*: Coefficient  
#' **Return:**  
#' k.log(k)  
#' **Example:** `klogK(0)`  
logK <- function(k) {
  return (ifelse(k==0, 0, log(k)))
}

log2K <- function(k) {
  return (ifelse(k==0, 0, log2(k)))
}

log10K <- function(k) {
  return (ifelse(k==0, 0, log10(k)))
}

klogK <- function(k) {
  return (ifelse(k==0, 0, k*log(k)))
}

klog2K <- function(k) {
  return (ifelse(k==0, 0, k*log2(k)))
}

klog10K <- function(k) {
  return (ifelse(k==0, 0, k*log10(k)))
}

klogKByN <- function(k, n) {
  return (ifelse(k==0, 0, k*log(k/n)))
}

klog2KByN <- function(k, n) {
  return (ifelse(k==0, 0, k*log2(k/n)))
}

klog10KByN <- function(k, n) {
  return (ifelse(k==0, 0, k*log10(k/n)))
}

#' ### normalize
#' Change the minimum and maximum values of a vector into another range (i.e.
#' [0, 1])  
#' **Parameters:**  
#' *x*: Numeric vector  
#' *xmin*: Minimum of the new range (default: min(x) for [0, 1])  
#' *xmax*: Maximum of the new range (default: max(x) for [0, 1])  
#' **Return:**  
#' normalized numeric vector  
#' **Example:** `normalize(x)`  
# https://stats.stackexchange.com/questions/70801/how-to-normalize-data-to-0-1-range
normalize <- function(x, xmin=min(x), xmax=max(x))
{
  return ((x-xmin)/(xmax-xmin))
}
