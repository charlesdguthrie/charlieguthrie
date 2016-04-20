#models.R
#Models and testing on restructured dataset.
require(party)

#logistic regression for correct
mylogit <- glm(label ~ hyperlink_clicks + magnify_clicks + expert_clicks + handling_time, data = train, family = "binomial")
summary(mylogit)

#log-transformed variables
mylogit2 <- glm(label ~ hyperlink_clicked + magnify_clicked + expert_clicked + log_handling_time, data=train, family="binomial")
summary(mylogit2)

## Classification Tree using party
mydat_tree <- ctree(label ~ hyperlink_clicks + magnify_clicks + expert_clicks + handling_time, data = train)
plot(mydat_tree)

#Linear regression to predict score
mylm <- lm(success ~ hyperlink_clicked + magnify_clicked + expert_clicked + log_handling_time, data = train)
summary(mylm)

##Regression Tree
reg_tree <- ctree(success ~ hyperlink_clicked + magnify_clicked + expert_clicked + log_handling_time, 
            data = train)
plot(reg_tree)

#Make training predictions
confusion_matrix = function(model,df,label=df$label,threshold=.57){
  df$pred_prob <- predict(model, df)
  df$pred_label <- ifelse(df$pred_prob>= threshold,1,0)
  tab = table(df$pred_label,label, dnn=list('predicted','actual'))
  return(tab)
}

#Get accuracy score
get_accuracy <- function(crosstab) {
  return(sum(diag(crosstab))/sum(sum((crosstab))))
}

display_results <- function(model,df,label,threshold=0.57){
  print(summary(model))
  tab = confusion_matrix(model,df,label=label,threshold=threshold)
  print(tab)
  accuracy = get_accuracy(tab)
  print(c("accuracy:",accuracy))
}


#TODO: don't bother with setting threshold as a parameter.  Compare models using AUC instead.
optimize_threshold = function(){
  #
  accuracies = c()
  thresholds = c(1:10)
  for(i in thresholds){
    threshold = i/10
    tab = confusion_matrix(model,df,label=label,threshold=threshold)
    accuracies[i] = get_accuracy(tab)
  }
  opt_threshold = thresholds[which.max(accuracies)]
  return(opt_threshold)
}

#Make test predictions
#tab = confusion_matrix(mylogit,train)
