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
confusion_matrix = function(model,df,threshold=.57){
  pred_prob <- predict(model, subset(df, select=-label))
  
  prob2label = function(x,threshold=threshold){
    if(x>=threshold){
      return(1)
    } else {
      return(0)
    }
  }
  
  pred_label = sapply(pred_prob,prob2label)
  
  tab = table(pred_label,df$label, dnn=list('predicted','actual'))
  return(tab)
}

#Get accuracy score
get_accuracy <- function(crosstab) {
  return(sum(diag(crosstab))/sum(sum((crosstab))))
}




#Make test predictions
#tab = confusion_matrix(mylogit,train)
