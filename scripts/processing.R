#processing.R
#process the data, restructuring into activity/assessment pairs: 1 row for each student-answer

#change student success to binary
df$label=ifelse(df$success>50,1,0) 
assessment_cards = c(5,9,12,15,19,21)

new_names = list(
  'new_hl_clicked_num'='hyperlink_clicks',
  'new_magnify_clicked_num'='magnify_clicks',
  'new_expert_clicked_num'='expert_clicks'
)

rename_cols = function(df,new_names){
  for (old_name in names(new_names)){
    names(df)[names(df)==old_name] <- new_names[[old_name]]
  }
  return(df)
}


aggregate_cards = function(df,first_card_num,test_card_num){
  # aggregate cards by adding up the number of engagement activities and summing the handling time
  features = c('user_id','card_num','new_hl_clicked_num','new_magnify_clicked_num','new_expert_clicked_num','handling_time')
  activity_cards = df[df$card_num>=first_card_num & df$card_num<test_card_num,features]
  test_card = df[df$card_num==test_card_num,c('user_id','label','success')]
  agg = aggregate(activity_cards, by=list(activity_cards$user_id), FUN=sum, na.rm=FALSE)
  
  #rename grouping column
  agg = agg[c(-2)] #drop column 2
  names(agg)[names(agg)=="Group.1"] <- "user_id" #rename to user_id
  
  #merge into one dataframe
  stan = merge(test_card,agg,by="user_id")
  stan$card_num=test_card_num
  return(stan)
}


restructure = function(df){
  #restructure data so that each row represents a student's score on a test card
  last=1
  for(card in assessment_cards){
    stan = aggregate_cards(df,last,card) #stan for STudent ANswers
    if(card==5){
      outdf=stan
    } else {
      outdf = rbind(outdf,stan)
    }
    last=card+1
  }
  return(outdf)
}

transform_vars = function(df){
  df$hyperlink_clicked = ifelse(df$hyperlink_clicks>0,1,0) 
  df$magnify_clicked = ifelse(df$magnify_clicks>0,1,0) 
  df$expert_clicked = ifelse(df$expert_clicks>0,1,0) 
  df$log_handling_time = ifelse(df$handling_time>0,log(df$handling_time),0)
  df$time_lt_20 = ifelse(df$handling_time<20,1,0)
  df$time_gt_100 = ifelse(df$handling_time>100,1,0)
  return(df)
}

train_test_split=function(df,train_frac=0.75){
  #split into training and test set
  set.seed(2016)
  train_index <- sample(2, nrow(df), replace=TRUE, prob=c(train_frac, 1-train_frac))
  train <- df[train_index==1,]
  test <- df[train_index==2,]
  return (list(train,test))
}

get_single_card = function(df,card_num){
  #take subset of data that refers to a single assessment card
  return (df[which(df$card_num==card_num),])
}

process_data=function(df){
  #wrapper function to process all data
  #returns: data which is composed of train and test
  outdf = restructure(df)
  outdf = rename_cols(outdf,new_names)
  kable(head(outdf))
  outdf = transform_vars(outdf)
  data = train_test_split(outdf)
  return(data)
}

#draw histograms of the data - specifically hl_clicked, mm_clicked, expert_clicked, handling_time

#draw scatterplots and correlations between variables

#build model predicting overall assessment performance from engagement activities

#display results in KnitR