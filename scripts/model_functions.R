#models.R
#Models and testing on restructured dataset.
require(party)
require(ROCR)
require(ggplot2)

#regularization
require(glmnet)

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

plot_roc_curve = function(model,data,label){
  #From http://blog.yhat.com/posts/roc-curves.html
  #Plots ROC curve with AUC in title
  
  prob <- predict(model, newdata=data, type="response")
  pred <- prediction(prob, label)
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

get_auc = function(model,data=train,label=train$label){
  prob <- predict(model, newdata=data, type="response")
  pred <- prediction(prob,factor(label))
  auc <- performance(pred, measure = "auc")
  return(auc@y.values[[1]])
}

display_results <- function(model,df=train,label=train$label,verbose=TRUE){
  auc = get_auc(model,df,label)
  paste("auc =",format(round(auc, 2), nsmall = 2))
  if(verbose){
    print(summary(model))
    print(paste("auc =",round(auc,3)))
  }
  return(round(auc, 3))
}

regularized_logit = function(train,test,label_name,feature_list,p_val=0.05,verbose=FALSE){
  #uses glmnet to loop through regularization hyperparameters (lambda)
  #uses the one that minimizes the AUC on a cross-validation set
  #JK it actually uses the largest lambda whose AUC is <1 se less than the minimum AUC
  #then runs traditional glm to check the result and take advantage of its convenient output
  #finally it prints model, significant features, and auc of optimized model on test set
  
  #print(paste("Training model for ",label_name))

  #clean data and convert to matrix for glmnet
  train_clean = train[complete.cases(train),]
  yTrain = as.vector(train_clean[[label_name]])
  xTrain = as.matrix(train_clean[feature_list])
  
  #run cross-validated glmnet loop to select best features
  fit = cv.glmnet(xTrain,yTrain,family="binomial", type.measure = "auc")
  coefs = as.matrix(coef(fit))
  feature_ids = which(coefs!=0) - 1 #ignore intercept
  feature_ids = feature_ids[-1] #pop off intercept index
  reduced_feature_list = feature_list[feature_ids]
  
  #define logistic model from reduced feature list
  feat_spec = paste(reduced_feature_list,collapse=' + ')
  model_spec = paste(label_name,'~',feat_spec)
  
  #train model
  reduced_logit = glm(model_spec,data=train,family="binomial")
  
  #return performance and significant coefficients
  auc=display_results(reduced_logit,test, test[[label_name]],verbose)
  sc = summary(reduced_logit)$coefficients
  sig_coefs = names(which(sc[,'Pr(>|z|)']<p_val))
  return (list(model=reduced_logit,sig_coefs=sig_coefs,auc=auc))
}


