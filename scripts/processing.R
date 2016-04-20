#processing.R
#process the data, restructuring into activity/assessment pairs: 1 row for each student-answer
library(reshape)


#change student success to binary
df$label=ifelse(df$success>50,1,0) 
assessment_cards = c(5,9,12,15,19,21)


#Rename columns
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
  # params:
  #   df: raw dataframe
  #   first_card_num: number of first card corresponding to test card (first card in unit)
  #   test_card_num: number of assessment card
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

widen = function(df){
  #Reshape data to give an indicator for each card, each label. 
  df2 = rename_cols(df,new_names)
  df2 = transform_vars(df2)
  keep = c('user_id','label','card_num','hyperlink_clicked','magnify_clicked','expert_clicked','time_lt_20','time_gt_100')
  subdf = df2[,keep]
  mdf = melt(subdf, id=c("user_id","card_num"))
  cdf = cast(mdf,user_id ~ variable + card_num)
  keep = c('user_id',
           'label_5',
           'label_9',
           'label_12',
           'label_15',
           'label_19',
           'label_21',
           'hyperlink_clicked_1',
           'hyperlink_clicked_2',
           'hyperlink_clicked_4',
           'hyperlink_clicked_5',
           'hyperlink_clicked_6',
           'hyperlink_clicked_8',
           'hyperlink_clicked_9',
           'hyperlink_clicked_10',
           'hyperlink_clicked_11',
           'hyperlink_clicked_13',
           'hyperlink_clicked_14',
           'hyperlink_clicked_15',
           'hyperlink_clicked_16',
           'hyperlink_clicked_17',
           'hyperlink_clicked_18',
           'hyperlink_clicked_19',
           'hyperlink_clicked_20',
           'hyperlink_clicked_21',
           'magnify_clicked_4',
           'magnify_clicked_5',
           'magnify_clicked_7',
           'magnify_clicked_9',
           'magnify_clicked_11',
           'magnify_clicked_13',
           'magnify_clicked_14',
           'magnify_clicked_15',
           'magnify_clicked_16',
           'magnify_clicked_17',
           'magnify_clicked_18',
           'magnify_clicked_19',
           'magnify_clicked_20',
           'magnify_clicked_21',
           'expert_clicked_5',
           'expert_clicked_9',
           'expert_clicked_14',
           'expert_clicked_15',
           'expert_clicked_16',
           'expert_clicked_17',
           'expert_clicked_19',
           'expert_clicked_21',
           'time_lt_20_1',
           'time_lt_20_2',
           'time_lt_20_3',
           'time_lt_20_4',
           'time_lt_20_5',
           'time_lt_20_6',
           'time_lt_20_7',
           'time_lt_20_8',
           'time_lt_20_9',
           'time_lt_20_10',
           'time_lt_20_11',
           'time_lt_20_12',
           'time_lt_20_13',
           'time_lt_20_14',
           'time_lt_20_15',
           'time_lt_20_16',
           'time_lt_20_17',
           'time_lt_20_18',
           'time_lt_20_19',
           'time_lt_20_20',
           'time_lt_20_21',
           'time_gt_100_1',
           'time_gt_100_2',
           'time_gt_100_3',
           'time_gt_100_4',
           'time_gt_100_5',
           'time_gt_100_6',
           'time_gt_100_7',
           'time_gt_100_8',
           'time_gt_100_9',
           'time_gt_100_10',
           'time_gt_100_11',
           'time_gt_100_12',
           'time_gt_100_13',
           'time_gt_100_14',
           'time_gt_100_15',
           'time_gt_100_16',
           'time_gt_100_17',
           'time_gt_100_18',
           'time_gt_100_19',
           'time_gt_100_20',
           'time_gt_100_21'
          )
  cdf = cdf[,keep]
  data = train_test_split(cdf)
  return(data)
}

#draw scatterplots and correlations between variables?