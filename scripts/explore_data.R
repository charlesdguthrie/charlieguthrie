#exploration of data

load_data = function(dpath,dictpath){
  df <- read.csv(dpath,sep=',', header=TRUE)
  datadict = read.csv(dictpath)
  return(df)
}

get_summary = function(df){
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


freq_table = function(df,var){
  #print frequency table
  print(paste("Frequencies for",var))
  print(round(prop.table(table(df[var])),2))
}