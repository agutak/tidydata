# Running the script

In order to run a script **run_analysis** you should:
1) provide a folder with exact structure of files and subfolders as described in CodeBook.md
2) Ensure that "dplyr" package is installed and loaded

To run a script and save results to a data frame variable you can execute commands:
```{r}
path <- "UCI HAR Dataset"
result <- run_analysis(path)
```