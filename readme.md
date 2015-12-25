Readme for getting and cleaning data course project

The run_analysis.R script in this repository defines a set of functions, each of them implements a distinct requierment.
A full flow script is also defined.

Flow by functions:
1. mergeTrainAndTestSet - reads all test and train data (Xs, Ys and Subjects) to memory and combines them all into a single dataset
2. keepOnlyMeanAndStdMesurments(FullDataset) - this function recives output of [1], uses RegEx to filter out varialbes which name's does not contain mean / std 
   Applies variable names on columns
3. addActivityName - loads the activity_labels.txt and merge activities to the full data set loaded on [1]
4. renameColumnsInDataset - alter column names to variable names
5. getFeatureMeanForSubjectAndActivity - calculate mean and average for each variable.
