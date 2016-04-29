#models.R
#Models and testing on restructured dataset.
require(party)
require(ROCR)

#regularization
require(LiblineaR)

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

#display_results <- function(model,df,label,threshold=0.57){
#  print(summary(model))
#  tab = confusion_matrix(model,df,label=label,threshold=threshold)
#  print(tab)
#  accuracy = get_accuracy(tab)
#  print(c("accuracy:",accuracy))
#}

display_results <- function(model,df,label){
  print(summary(model))
  auc = get_auc(model,df,label)
  paste("auc =",format(round(auc, 2), nsmall = 2))
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

get_auc = function(model,data,label){
  prob <- predict(model, newdata=data, type="response")
  pred <- prediction(prob,label)
  auc <- performance(pred, measure = "auc")
  return(auc@y.values[[1]])
}

plot_roc_curve = function(){
  #NOTE: Pasted from http://blog.yhat.com/posts/roc-curves.html for later
  #Does not work with current dataset.
  
  prob <- predict(fit, newdata=test, type="response")
  pred <- prediction(prob, test$is_expensive)
  perf <- performance(pred, measure = "tpr", x.measure = "fpr")
  # I know, the following code is bizarre. Just go with it.
  auc <- performance(pred, measure = "auc")
  auc <- auc@y.values[[1]]
  
  roc.data <- data.frame(fpr=unlist(perf@x.values),
                         tpr=unlist(perf@y.values),
                         model="GLM")
  ggplot(roc.data, aes(x=fpr, ymin=0, ymax=tpr)) +
    geom_ribbon(alpha=0.2) +
    geom_line(aes(y=tpr)) +
    ggtitle(paste0("ROC Curve w/ AUC=", auc))
}

#Make test predictions
#tab = confusion_matrix(mylogit,train)
