#exploration of data

#setwd("~/git/edsp/notebooks")

load_data = function(){
  dpath <- "data/fullData.csv"
  df <- read.csv(dpath,sep=',', header=TRUE)
  datadict = read.csv('data/dataDefs.csv')
  return(df)
}

get_summary <- function(df){
  #builds data frame of summary statistics given input df
  summary = data.frame(variable = colnames(df))
  cols = colnames(df)
  for (i in 1:length(cols)){
    col=cols[i]
    summary[i,"uniques"] = dim(unique(df[col]))[1]
    #summary[i,"type"] = typeof(df[[col]])
  }
  
  return(summary)
}

#df = load_data()
#dfsum=get_summary(df)
#dfsum

#Also this is useful for exploring the data
#str(df)
