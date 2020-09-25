# Introduction

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone.

# Preconditions

## The expected structure of directories and files in data folder

```{r}
/UCI HAR Dataset
-/test
--/subject_test.txt
--/X_test.txt
--/y_test.txt
-/train
--/subject_train.txt
--/X_train.txt
--/y_train.txt
-/activity_labels.txt
-/features.txt
-/features_info.txt
-/README.txt
```

# Section 1. Code and Results

The data for this experiment supposed to be located in folder with the name "UCI HAR Dataset".

First I will save the name of the folder with data to the variable "path".

```{r}
path <- "UCI HAR Dataset"

```
I want to get a tidy data set with the average of each variable for each activity and each subject.
To do it I will run created script named "run_analysis.R".
The only argument for this function is the name of the folder where the data is, t.e. variable "path".

The resulting tidy dataset I will save to a variable "result".

```{r}
result <- run_analysis(path)

```

My script file contains two functions: **getExperimentData(data_folder, experiment_subfolder)** and **run_analysis(data_folder)**.

## Section 1.1. Function getExperimentData

The **getExperimentData** function is created to read all data from the provided subfolder of the main data folder, e.g. "test" or "train".
It has two arguments: 
 - **data_folder**, e.g. "UCI HAR Dataset",
 - **experiment_subfolder** e.g. "test" or "train".

First, it reads the names of the variables from **features.txt** file and saves it as a data frame to **col_names_data** variable.
```{r}
names_file_path <- file.path(data_folder, "features.txt",fsep = "/")
  
  col_names_data <- read.table(
    file = names_file_path,
    header = FALSE,
    col.names = c("id","name"),
    colClasses = c("integer","character"))
```

Next, the function reads the experiments' data from **X_...txt** file and saves it as a data frame to **variables_data** variable.
```{r}
variables_file_path <- file.path(
    data_folder,
    experiment_subfolder,
    paste("X_", experiment_subfolder, ".txt", sep = ""),
    fsep = "/")
  
  variables_data <- read.table(
    file = variables_file_path,
    header = FALSE,
    col.names = col_names_data[, 2],check.names = FALSE)
```

Next, the data with subjects is read from **subject_...txt** into **subject_data**.
```{r}
subject_file_path <- file.path(
    data_folder,
    experiment_subfolder,
    paste("subject_", experiment_subfolder, ".txt", sep = ""),
    fsep = "/")
  
  subject_data <- read.table(
    file = subject_file_path,
    header = FALSE,
    col.names = c("subject"))
```

In order to use descriptive activity names to name the activities in the data set, function loads data from **activity_labels.txt** into **activities_names_data** variable and data from **y_...txt** into **activities_data** variable. Then I substitute **activities_names_data** into **activities_data** instead of numerical values.
```{r}
activities_names_file_path <- file.path(data_folder, "activity_labels.txt",fsep = "/")
  
  activities_names_data <- read.table(
    file = activities_names_file_path,
    header = FALSE,
    col.names = c("id","name"),
    colClasses = c("integer","character"))
  
  activities_file_path <- file.path(
    data_folder,
    experiment_subfolder,
    paste("y_", experiment_subfolder, ".txt", sep = ""),
    fsep = "/")
  
  activities_data <- read.table(
    file = activities_file_path,
    header = FALSE,
    col.names = c("activity"),
    colClasses = "numeric")
    
activities_data <- activities_names_data[[2]][activities_data[[1]]]
```
To return the resulting data frame I use **cbind** function which combines subject data with activities and other experiment data.
```{r}
result <- cbind(subject_data, "activity" = activities_data, variables_data)
```

## Section 1.2. Function run_analysis

The main function **run_analysis** performs the joining of train and test data and further summarizing the results into a tidy data frame.
I has one argument **data_folder** - a folder with experiment results with certain structure as stated in Preconditions section above, t.e. "UCI HAR Dataset". **run_analysis** function uses previously created **getExperimentData** function to load experiments data from subfolders.
Firstly, I load test data from **test** subfolder and save it to **test_data** variable.
```{r}
test_data <- getExperimentData(data_folder, "test")
```
Then I load train data from **train** subfolder and save it to **train_data** variable.
```{r}
train_data <- getExperimentData(data_folder, "train")
```

The merged data frame is composed using the **rbind** function.
```{r}
data <- rbind(test_data, train_data)
```

After that the resultin data frame is received by using **select** function to select only mean and std variables, **group_by** function to group data by subjects and activities and **summarize_all** function to calculate average of each variable for each activity and each subject.
```{r}
filtered_data <- data %>% 
    select(subject, activity, contains("mean()") | contains("std()")) %>%
    group_by(subject, activity) %>% 
    summarize_all(.funs = mean)
```

# Conclusion

The resulting data frame contains 180 observations with 68 variables.