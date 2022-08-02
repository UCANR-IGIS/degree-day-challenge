## This R script compiles the individual degree calculations from the UC-IPM website
## into a single table, which separate columns for each method.
## This combined table will serve as the 'correct answers' for the Degree Day Validation Challenge.

library(readr); library(dplyr); library(tidyr)

# setwd("D:/GitHub/degday/degree-day-challenge/ipm-results")
# fn_base <- "dd-ipm_low50-up90"

## First we loop thru the CSV files, import them, add a column for the method, and put them in a list
tbl_lst <- list()
num_rows <- numeric()
col_names <- character()

for (dd_method in c("sngsine", "dblsine", "sngtri", "dbltri")) {
  for (dd_cutoff in c("horiz", "vert", "intrmd")) {

    ## Construct the csv file name
    fn_csv <- paste0("ucipm_low50_high70_", dd_method, "_", dd_cutoff, ".csv")
    cat(" -", fn_csv, "\n")

    ## Add on the path and make sure it exists
    fn_path_csv <- file.path("./data/ucipm_results", fn_csv)
    if (!file.exists(fn_path_csv)) stop(paste0("File not found! ", fn_path_csv))

    ## Construct the name of the method (will be used for the column name)
    method_chr <- paste0(dd_method, "_", dd_cutoff)

    ## Import the csv
    vals_tbl <- read_csv(fn_path_csv, skip = 30, col_names = TRUE,
                                col_types = list(col_character(), col_double(),
                                                 col_double(), col_double()),
                                col_select = c(date = 'Date', tmin = "Temp min",
                                               tmax = "Temp max", dly_dd = "Daily DD",
                                               acc_dd = "Accumulated DD")) %>%
      mutate(method = method_chr)

    ## Verify the number of rows is the same for all csv files
    if (length(num_rows) == 0) {
      num_rows <- nrow(vals_tbl)
    } else {
      if (num_rows != nrow(vals_tbl)) {
        stop(paste0("Oh dear. ", fn_csv, " has a different number of rows!"))
      }
    }

    ## Verify the column names are the same for all csv files
    if (length(col_names) == 0) {
      col_names <- names(vals_tbl)
    } else {
      if (!identical(names(vals_tbl), col_names)) {
        stop(paste0("Oh dear. ", fn_csv, " has different column names!"))
      }
    }

    ## Add this table to the master list
    tbl_lst[[method_chr]] <- vals_tbl

  }
}

## We now have a list of all the tables
names(tbl_lst)
sapply(tbl_lst, nrow)

## Start a new table based on the first one.
## We'll throw away the accumulated degree day column (not needed for our use case)
## and rename the values columns with the method
degdaychal_ans_tbl <- tbl_lst[[1]] %>%
  select(-acc_dd) %>%
  pivot_wider(names_from = method, values_from = dly_dd)

## Sort thru the remaining and append the columns
for (i in 2:length(tbl_lst)) {

  ## Verify the key columns are identical to the 'master'
  for (fld in c("date", "tmin", "tmax")) {
    if (!all.equal(tbl_lst[[1]][[fld]], degdaychal_ans_tbl[[fld]])) {
      stop(paste0(" - Oh dear. The ", fld, " column is not equal for ", names(tbl_lst)[i]))
    }
  }

  ## Get the name of the method in this table
  method_chr <- names(tbl_lst)[i]

  ## Pull out the values for the daily degree day column
  new_vals <- tbl_lst[[i]] %>%
    select(-acc_dd) %>%
    pivot_wider(names_from = method, values_from = dly_dd) %>%
    pull(method_chr)

  ## Append the daily degree day column to the master
  degdaychal_ans_tbl[[method_chr]] <- new_vals

}

## We're done! Save the table to disk.
write_csv(degdaychal_ans_tbl, file = "./data/ucipm_results/ucipm_low50_high70_all.csv")

