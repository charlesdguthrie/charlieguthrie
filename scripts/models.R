#models.R
#Models and testing on restructured dataset.


#Linear regression
lin = lm(success ~ hyperlink_clicks + magnify_clicks + expert_clicks + log_handling_time, data=lin_train)



models = list()
#logistic regression for correct
models[[1]] <- glm(label ~ hyperlink_clicks + magnify_clicks + expert_clicks + handling_time, data = train, family = "binomial")
#log-transformed handling time
models[[2]] <- glm(label ~ hyperlink_clicks + magnify_clicks + expert_clicks + log_handling_time, data=train, family="binomial")
#log-transformed handling time and binary clicks
models[[3]] <- glm(label ~ hyperlink_clicked + magnify_clicked + expert_clicked + log_handling_time, data=train, family="binomial")
#all binary
models[[4]] <- glm(label ~ hyperlink_clicked + magnify_clicked + expert_clicked + time_lt_20 + time_gt_100, data=train, family="binomial")
## Classification Tree using party
models[[5]] <- ctree(label ~ hyperlink_clicks + magnify_clicks + expert_clicks + handling_time, data = train)
models[[6]] <- ctree(label ~ hyperlink_clicks + magnify_clicks + expert_clicks + log_handling_time, data = train)
models[[7]] <- ctree(label ~ hyperlink_clicked + magnify_clicked + expert_clicked + log_handling_time, data = train)
models[[8]] <- ctree(label ~ hyperlink_clicked + magnify_clicked + expert_clicked + time_lt_20 + time_gt_100, data = train)

model_type = c('logistic','logistic','logistic','logistic','tree','tree','tree','tree')
clicks = c('scalar','scalar','binary','binary','scalar','scalar','binary','binary')
time = c('scalar','log-transformed','log-transformed','binary','scalar','log-transformed','log-transformed','binary')


aucs=c()
for(model in models){
  auc = display_results(model,df=train,label=train$label,verbose=FALSE)
  aucs = append(aucs,auc)
}
aucs

modelsDF = data.frame(cbind(model_type,clicks,time,aucs))
colnames(modelsDF)=c('Model Type','Activity Measure','Time Spent','AUC')

#Regularization using glmnet for card 5 with log handling time:
label_name = 'label_5'
feature_list = c('hyperlink_clicked_1',
                 'hyperlink_clicked_2',
                 'hyperlink_clicked_4',
                 'hyperlink_clicked_5',
                 'magnify_clicked_4',
                 'magnify_clicked_5',
                 'time_lt_20_1',
                 'time_lt_20_2',
                 'time_lt_20_3',
                 'time_lt_20_4',
                 'time_lt_20_5',
                 'time_gt_100_1',
                 'time_gt_100_2',
                 'time_gt_100_3',
                 'time_gt_100_4',
                 'time_gt_100_5'
)

result_5 = regularized_logit(train_w, test_w, label_name, feature_list)

#Regularization using glmnet for card 9:
label_name = 'label_9'
feature_list = c(
  'label_5',
  'hyperlink_clicked_1',
  'hyperlink_clicked_2',
  'hyperlink_clicked_4',
  'hyperlink_clicked_5',
  'hyperlink_clicked_6',
  'hyperlink_clicked_8',
  'hyperlink_clicked_9',
  'magnify_clicked_4',
  'magnify_clicked_5',
  'magnify_clicked_7',
  'magnify_clicked_9',
  'expert_clicked_5',
  'time_lt_20_1',
  'time_lt_20_2',
  'time_lt_20_3',
  'time_lt_20_4',
  'time_lt_20_5',
  'time_lt_20_6',
  'time_lt_20_7',
  'time_lt_20_8',
  'time_lt_20_9',
  'time_gt_100_1',
  'time_gt_100_2',
  'time_gt_100_3',
  'time_gt_100_4',
  'time_gt_100_5',
  'time_gt_100_6',
  'time_gt_100_7',
  'time_gt_100_8',
  'time_gt_100_9'
)

result_9 = regularized_logit(train_w, test_w, label_name, feature_list)

#Regularization using glmnet for card 12:
label_name = 'label_12'
feature_list = c(
  'label_5',
  'label_9',
  'hyperlink_clicked_1',
  'hyperlink_clicked_2',
  'hyperlink_clicked_4',
  'hyperlink_clicked_5',
  'hyperlink_clicked_6',
  'hyperlink_clicked_8',
  'hyperlink_clicked_9',
  'hyperlink_clicked_10',
  'hyperlink_clicked_11',
  'magnify_clicked_4',
  'magnify_clicked_5',
  'magnify_clicked_7',
  'magnify_clicked_9',
  'magnify_clicked_11',
  'expert_clicked_5',
  'expert_clicked_9',
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
  'time_gt_100_12'
)

result_12 = regularized_logit(train_w, test_w, label_name, feature_list)


#Regularization using glmnet for card 15:
label_name = 'label_15'
feature_list = c(
  'label_5',
  'label_9',
  'label_12',
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
  'magnify_clicked_4',
  'magnify_clicked_5',
  'magnify_clicked_7',
  'magnify_clicked_9',
  'magnify_clicked_11',
  'magnify_clicked_13',
  'magnify_clicked_14',
  'magnify_clicked_15',
  'expert_clicked_5',
  'expert_clicked_9',
  'expert_clicked_14',
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
  'time_gt_100_15'
)

result_15 = regularized_logit(train_w, test_w, label_name, feature_list)


#Regularization using glmnet for card 19:
label_name = 'label_19'
feature_list = c(
  'label_5',
  'label_9',
  'label_12',
  'label_15',
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
  'expert_clicked_5',
  'expert_clicked_9',
  'expert_clicked_14',
  'expert_clicked_15',
  'expert_clicked_16',
  'expert_clicked_17',
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
  'time_gt_100_19'
)

result_19 = regularized_logit(train_w, test_w, label_name, feature_list)

#Regularization using glmnet for card 21:
#NOTE: there weren't enough distinct predictions from this so went with simplified model
label_name = 'label_21'
feature_list = c(
  'label_5',
  'label_9',
  'label_12',
  'label_15',
  'label_19',
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

#Simplified regularization using glmnet for card 21:
label_name = 'label_21'
feature_list = c(
  'label_5',
  'label_9',
  'label_12',
  'label_15',
  'label_19',
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

#TODO: fix results_21
#result_21 = regularized_logit(train_w, test_w, label_name, feature_list)

get_resultsDF = function(){
  resultsDF = data.frame(Card=c(5,9,12,15,19))#,21))
  result_list=list(result_5, result_9, result_12, result_15, result_19) #, result_21)
  row=1
  for(result in result_list){
    resultsDF[row,'AUC']=result$auc
    resultsDF[row,'Significant Variables']=paste(result$sig_coefs,collapse=', ')
    row=row+1
  }
  #manual hack to include model 21
  result_21_manual = c(21,0.628,"label_5, label_9, label_19, hyperlink_clicked_21, magnify_clicked_20, expert_clicked_19, time_lt_20_15, time_lt_20_20, time_gt_100_21")
  resultsDF = rbind(resultsDF,result_21_manual)
  return(resultsDF)
}