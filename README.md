---
title: "Run_analysis_explanation"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Run_analysis explanation

### This script does the following:
1. Download and unzip the raw data files if not already in directory.
2. Open all necessary files, combine subject and activity ID's with collected data, and label measurement columns.
3. Check for "mean" and "std" in column names, deleting all other columns.
4. Rename columns to be more understandable.
5. Melt and re-cast dataset so that data are averaged across participants and activity type.