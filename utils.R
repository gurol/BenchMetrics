#' utils – Common Modules (Utilities)
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
#' Copyright (C) 2017-2018 Gürol CANBEK  
#' @references <http://gurol.canbek.com>  
#' @keywords utilities, common functions  
#' @title utils - Common utility R functions  
#' @date 25 Feb 2019  
#' @version 1.4  
#' @note version history  
#' 1.4, 25 Feb 2019, DataFrame by names
#' 1.3, 2 April 2018, Remove Columns having all NAs
#' 1.2, 16 Feburary 2018, Plot to devide or PNG file  
#' 1.1, 14 February 2018, Column name checking avoiding parameter for rclip  
#' 1.0, 1 February 2017, The first version  
#' @description Common R functions that can be called from other scripts  

#' libraries  
library(parallel) # Preinstalled in environment
library(plyr)
library(dplyr) # distinct

plot_to_device <- 'Device'

#' ### getNumberOfCPUCores
#' Return the number of CPU cores in the current host  
#' **Parameters:**  
#' *logical*: if possible, use the number of physical CPUs/cores (if FALSE)  
#'            (default: FALSE)  
#' **Return:**  
#' Number of CPU cores  
getNumberOfCPUCores<-function(logical=FALSE)
{
  cores <- detectCores(logical=logical)
  
  if (is.na(cores))
    cores <- 1
  
  return(cores)
}

#' ### wclip
#' Write to the Clipboard (i.e. Copy)  
#' **Parameters:**  
#' *metric*: Performance metric  
#' *sep*: Seperator between column values (default: TAB)  
#' *na*:  Not Available identifies (default: 'NA')  
#' *dec*: Decimal seperator (default: '.')  
#' *row.names*: Does source metric have row names (default: TRUE)  
#' *col.names*: Does source metric have column names (default: TRUE)  
#' **Return:**  
#' none  
#' **Details:**  
#' Code changes according to operating system (Windows or Mac OS)  
#' **Warning:**  
#' write.table writes unwanted leading empty column to header when has rownames  
#' See http://stackoverflow.com/questions/2478352/write-table-writes-unwanted-leading-empty-column-to-header-when-has-rownames  
#' **Examples:** `wclip(ACC)` or `wclip(ACC, dec= ',')`  
wclip <- function(metric, sep='\t', na='NA', dec='.', quote=TRUE,
                  row.names=TRUE, col.names=TRUE)
{
  if (.Platform$OS.type == 'windows')
    write.table(metric, 'clipboard-256', sep=sep, dec=dec, quote=quote,
                row.names=row.names, col.names=col.names)
  else {
    clip <- pipe('pbcopy', 'w')
    write.table(metric, file=clip, sep=sep, na=na, dec=dec, quote=quote,
                row.names=row.names, col.names=col.names)
    close(clip)
  }
}

#' ### rclip
#' Read from the Clipboard (i.e. Paste)  
#' **Parameters:**  
#' *sep*: Seperator between column values (default: TAB)  
#' *na*:  Not Available identifier (default: c('NA', '')) Use only 'NA' for not
#'        indicating NA for empty strings.  
#' *dec*: Decimal seperator (default: '.')  
#' *header*: Does source have column names (header)? (default: TRUE)  
#' *stringsAsFactors*: Should character vectors be converted to factors?  
#'                     (default: FALSE)  
#' *check.names*: Avoid addition of "X" prefix into column names (default: FALSE)
#' **Return:**  
#' Readed data frame  
#' **Details:**  
#' Code changes according to operating system (Windows or Mac OS)  
#' **Warning:**  
#' ignore warning message: incomplete final line found by readTableHeader on 'pbpaste'
#' **Examples:** `ACC <- rclip()` or `ACC <- wclip(dec= ',')`  
rclip <- function(sep='\t', na=c('NA','','N/A'), dec='.', header=TRUE,
                  strip.white=FALSE, stringsAsFactors=FALSE, check.names=FALSE)
{
  if (.Platform$OS.type == 'windows')
    f <- 'clipboard-256'
  else {
    clip <- pipe('pbpaste')
    f <- clip
  }
  
  values <- read.table(file=f, sep=sep, dec=dec, header=header,
                       stringsAsFactors=stringsAsFactors,
                       check.names=check.names, na.strings=na)
  
  return(values)
}


#' ### pressEnterToContinue
#' Stop script run and show a (custom) message to user to press ENTER  
#' **Parameters:**  
#' *message*: custom message text to display (default: '')  
#' **Return:**  
#' none  
#' **Details:**  
#' Show a given message with 'Press [enter] to continue' statement and wait for  
#' the user interaction. It is useful for pausing script run  
#' **Examples:** `pressEnterToContinue()` or `pressEnterToContinue('wait')`  
pressEnterToContinue<-function(message='')
{
  invisible(readline(prompt=paste(message, 'Press [enter] to continue')))
}

#' ### dataFrameByNames
#' Return a dataframe with the objects given as names  
#' **Parameters:**  
#' *metric_names*: One or more object names (characters)  
#' **Return:**  
#' A dataframe  
#' **Example:** `dataFrameByNames(c('ACC', 'G', 'BACC')`  
dataFrameByNames <- function(objects.names)
{
  for (i in 1:length(objects.names)) {
    if (i == 1) {
      df <- data.frame(get(objects.names[i]))
      colnames(df)[1] <- objects.names[i]
    }
    df[[objects.names[i]]] <- get(objects.names[i])
  }
  
  return (df)
}

#' ### renameDataFrameColumn
#' Rename the column name of a data frame  
#' **Parameters:**  
#' *df*: data frame  
#' *column_name*: existing column name  
#' *new_column_name*: new column name  
#' **Return:**  
#' new data frame  
#' **Details:**  
#' **Examples:** `renameDataFrameColumn(df, 'test', 'product')`  
renameDataFrameColumn<-function(df, column_name, new_column_name)
{
  colnames(df)[colnames(df)==column_name] <- new_column_name
  
  return(df)
}

#' ### appendDataFrameColumns
#' Append a prefix and/or suffix to a data frame  
#' **Parameters:**  
#' *df*: data frame  
#' *prefix*: text added before the column name (default: '')  
#' *suffix*: text added after the column name (default: '')  
#' **Return:**  
#' new data frame  
#' **Details:**  
#' **Examples:** `appendDataFrameColumns(df, 'pre_', '_suf')`  
appendDataFrameColumns<-function(df, prefix='', suffix='', sep='')
{
  colnames(df) <- paste(prefix, colnames(df), suffix, sep=sep)
  
  return(df)
}

#' ### emptyDataFrame
#' Create and return an empty data frame with given column names  
#' **Parameters:**  
#' *column_names*: column names vector  
#' *stringsAsFactors*: should character vectors be converted to factors  
#' **Return:**  
#' new data frame  
#' **Details:**  
#' **Examples:** `df <- emptyDataFrame(c('Col1', 'Col2'))`  
emptyDataFrame<-function(column_names, stringsAsFactors=FALSE)
{
  return(setNames(
    data.frame(
      matrix(ncol=length(column_names), nrow=0),
      stringsAsFactors=stringsAsFactors),
    column_names))
}

#' ### roundDataFrame
#' Round all the numeric columns in a data frame  
#' **Parameters:**  
#' *df*: data frame  
#' *digits*: decimal digits to round  
#' **Return:**  
#' new data frame  
#' **Details:**  
#' **Examples:** `df <- roundDataFrame(df, 2)`  
#' **Reference:** https://stackoverflow.com/a/29876220/2101864  
roundDataFrame <- function(df, digits)
{
  numeric_columns <- sapply(df, mode) == 'numeric'
  df[numeric_columns] <-  round(df[numeric_columns], digits)
  
  return (df)
}

#' ### plotToDeviceOrFile
#' Plot a graphic to a device of a PNG file (if a file name is given)  
#' **Parameters:**  
#' *data*: data or R object to plot  
#' *main_title*: overall title for the plot (default: NULL)  
#' *sub_title*: sub title for the plot (default: NULL)  
#' *xlabel*: title for the x axis (default: NULL)  
#' *ylabel*: title for the x axis (default: NULL)  
#' *filepath*: path of the file (default: NULL to plot on device)  
#' *width*: the width of the device/file (default: 20cm)  
#' *height*: the height of the device/file (default: 15cm)  
#' *units*: The units in which height and width are given (default: 'cm')
#'          Could be 'in', 'px', 'mm'  
#' *res*: The nominal resolution in ppi which will be recorded in the bitmap  
#' file (default: 300)  
#' *file_type*: Type of the file if filepath is provided: 'png', 'pdf'  
#'              (default: 'png')  
#' **Return:**  
#' none  
#' **Examples:** `plotToDeviceOrFile(data, filepath='fig1.png')`  
plotToDeviceOrFile<-function(data, col=NULL, main_title=NULL, sub=NULL,
                             xlabel=NULL, ylabel=NULL,
                             filepath=NULL, width=20, height=15, units='cm',
                             res=300, file_type='png')
{
  if (filepath != plot_to_device) {
    if (file_type == 'png') {
      png(filename=filepath, width=width, height=height, units=units, res=res)
    }
    else {
      pdf(filename=filepath, width=width, height=height, units=units, res=res)
    }
  }
  plot(data, col=col, main=main_title, xlab=xlabel, sub=sub)
  if (filepath != plot_to_device) {
    dev.off()
  }
}

extractVectorFromDataFrame<-function(df, irow, icol, use.names=FALSE)
{
  # m <- matrix(unlist(df, use.names=FALSE), )
  # as.vector(t(df[1,]))[,-1]
}

# https://stackoverflow.com/a/15968937/2101864
# For correlation matrix use df[, colSums(is.na(df)) != nrow(df) - 1]
removeNaColumns<-function(df)
{
  return (df[colSums(!is.na(df)) > 0])
}

countCharacterInString<-function(char, s)
{
  s2 <- gsub(char,"",s)
  return (nchar(s) - nchar(s2))
}

# Use with cautions especially nmin different from 0 and 1
# Combinations of (k) elements having maximum (n) value and minimum n0 and yielding given sum (s)
combSum <- function(nmax, k, s, nmin=1) {
  if (nmin == 0)
    all <- combn(0:(nmax+1), k)
  else
    all <- combn(nmin:nmax, k)
  
  sums <- colSums(all)
  return (t(all[, sums == s]))
}

# Use with cautions especially nmin different from 0 and 1
# nrow(permSum(50, 4, 50, 0))
permSum <- function(nmax, k, s, nmin=1) {
  # all <- permutations(Sn+1, k, 0:Sn+1)
  if (nmin == 0)
    all <- gtools::permutations(nmax+1, k, nmin:(nmax+1), repeats.allowed=TRUE)
  else
    all <- gtools::permutations(nmax, k, nmin:nmax, repeats.allowed=TRUE)
  
  sums <- rowSums(all)
  return (all[sums == s, ])
}

# PermissionsAndroidStandard
# df <- convertCsvToDataFrame(dfCSV, sep=',', filter=permStandard)
convertCsvToDataFrame <- function (csvs, sep=', ', filter=NULL) {
  uniques_csvs <- distinct(csvs)
  colnames.df <- character()
  all_elements <- character()
  
  for (i in 1:nrow(uniques_csvs)) {
    csv_line <- uniques_csvs[i, ]
    element <- strsplit(csv_line, sep)[[1]]
    colnames.df <- unique(c(colnames.df, element))
    all_elements <- c(all_elements, element)
  }
  
  df <- emptyDataFrame(names(sort(table(all_elements), decreasing = TRUE)))
  # df <- emptyDataFrame(sort(colnames.df))
  
  i <- 1
  for (i in 1:nrow(csvs)) {
    csv_line <- csvs[i, ]
    elements <- strsplit(csv_line, sep)[[1]]
    
    if (!is.null(filter)) {
      elements <- intersect(filter[[1]], elements)
    }
    
    for (element in elements) {
      df[i, element] <- element
    }
  }
  
  if (!is.null(filter)) {
    common <- intersect(filter[[1]], colnames(df))
    df <- df[, common]
  }
  
  return (df)
}

# https://stackoverflow.com/a/42631524/2101864
# https://stackoverflow.com/a/38312713/2101864
countLinesAndFunctionsInScript <- function(script_file_path)
{
  data <- getParseData(parse(file=script_file_path))
  # function_names <- data$text[which(data$token=="SYMBOL_FUNCTION_CALL")]
  function_names <- data$text[which(data$token=="FUNCTION")]
  occurrences <- data.frame(table(function_names))
  result <- occurrences$Freq
  names(result) <- occurrences$function_names
  
  con <- file(script_file_path, open='r')
  print(length(readLines(con)))
  close(con)
  
  cat(basename(script_file_path))
  print (result)
}
