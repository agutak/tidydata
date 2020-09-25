run_analysis <- function(data_folder){
  test_data <- getExperimentData(data_folder, "test")
  train_data <- getExperimentData(data_folder, "train")
  
  data <- rbind(test_data, train_data)
  
  names(data) <- gsub("^t", "Time", names(data))
  names(data) <- gsub("^f", "Frequency", names(data))
  names(data) <- gsub("Acc", "Accelerometer", names(data))
  names(data) <- gsub("Gyro", "Gyroscope", names(data))
  names(data) <- gsub("Mag", "Magnitud", names(data))
  names(data) <- gsub("BodyBody", "Body", names(data))
  names(data) <- gsub("-mean", "Mean", names(data))
  names(data) <- gsub("-std", "STD", names(data))
  names(data) <- gsub("-freq", "Frecuency", names(data))
  names(data) <- gsub("angle", "Angle", names(data))
  names(data) <- gsub("gravity", "Gravity", names(data))
  
  filtered_data <- data %>% 
    select(subject, activity, contains("mean()") | contains("std()")) %>%
    group_by(subject, activity) %>% 
    summarize_all(.funs = mean)
}

getExperimentData <- function(data_folder, experiment_subfolder){
  
  names_file_path <- file.path(data_folder, "features.txt",fsep = "/")
  
  col_names_data <- read.table(
    file = names_file_path,
    header = FALSE,
    col.names = c("id","name"),
    colClasses = c("integer","character"))
  
  variables_file_path <- file.path(
    data_folder,
    experiment_subfolder,
    paste("X_", experiment_subfolder, ".txt", sep = ""),
    fsep = "/")
  
  variables_data <- read.table(
    file = variables_file_path,
    header = FALSE,
    col.names = col_names_data[, 2],check.names = FALSE)
  
  subject_file_path <- file.path(
    data_folder,
    experiment_subfolder,
    paste("subject_", experiment_subfolder, ".txt", sep = ""),
    fsep = "/")
  
  subject_data <- read.table(
    file = subject_file_path,
    header = FALSE,
    col.names = c("subject"))
  
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
  
  result <- cbind(subject_data, "activity" = activities_data, variables_data)
  
  result
}
