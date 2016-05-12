
<style>
.reveal h1, .reveal h2, .reveal h3 {
  word-wrap: normal;
  -moz-hyphens: none;
  hyphens: none;
}
img {
  box-shadow:none;
  border:0px;
}
.midcenter {
    position: fixed;
    top: 50%;
    left: 50%;
}
.wide .reveal{
  margin: 10px
}
.exclaim .reveal .state-background {
  background: black;
} 

.exclaim .reveal h1,
.exclaim .reveal h2,
.exclaim .reveal h3,
.exclaim .reveal p {
  color: white;
}
</style>



Evaluating Online Course Materials
========================================================
author: Charlie Guthrie
date: May 2, 2016
transition: none

APSTA-GE 2017: Educational Data Science Practicum


Goal
========================================================
Identify which learning activities were most effective at increasing student assessment performance.

 
========================================================
<img src="resources/logo.png" style="background-color:transparent; border:0px; box-shadow:none;margin-left:30px"></img>

***

23-card online course

Learning activities on cards include:
- reading material
- links
- images
- assessments throughout


About the Data
========================================================
title:false
<img src="figures/card_screenshot.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>

Key Variables
========================================================
Assessment cards  
***
<img src="resources/answer example.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>

Key Variables
========================================================
Variables that may have an impact on student performance:

  * **Clicking hyperlinks**
  * Magnifying images
  * Checking answers using "expert" links
  * Time spent on cards
  
***
<img src="resources/hyperlink example.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>
  
Key Variables
========================================================
Variables that may have an impact on student performance:

  * Clicking hyperlinks
  * **Magnifying images**
  * Checking answers using "expert" links
  * Time spent on cards
  
***
<img src="resources/magnify example.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>

Key Variables
========================================================
Variables that may have an impact on student performance:

  * Clicking hyperlinks
  * Magnifying images
  * **Checking answers using "expert" links**
  * Time spent on cards
  
***
<img src="resources/expert answer.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>

Key Variables
========================================================
Variables that may have an impact on student performance:

  * Clicking hyperlinks
  * Magnifying images
  * Checking answers using "expert" links
  * **Time spent on cards**
  
***
![plot of chunk unnamed-chunk-2](medu-figure/unnamed-chunk-2-1.png)

Key Variables
========================================================
Not all activities are present on all cards.
<img src="figures/card_map.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>

Project Overview
========================================================
<h3>Investigation 1</h3>
Predict student performance from overall activity engagement. 

<h3>Investigation 2</h3>
Measure impact of specific learning activities and cards.

Investigation 1: Does Studying Work?
========================================================
Is there a relationship between student engagement and performance?

Investigation 1: Does Studying Work?
========================================================
<img src="figures/card_map_blocked.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>
<img src="figures/model 1.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>

Investigation 1: Procedure
========================================================
1. Restructure data: 1 line per student per assessment
    - assessments are aggregated together
1. Data transformations
   - convert assessment scores to pass/fail
   - converting clicks to binary
   - log-transform and binary transform of handling_time
1. Classification model predicts if student will pass an assessment given measures of engagement

Investigation 1: Results
========================================================
title: false
<font size=6>

```

Call:
glm(formula = label ~ hyperlink_clicked + magnify_clicked + expert_clicked + 
    time_lt_20 + time_gt_100, family = "binomial", data = train)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-1.5622  -1.2518   0.9056   1.0506   1.3147  

Coefficients:
                  Estimate Std. Error z value Pr(>|z|)    
(Intercept)       -0.01487    0.03685  -0.403  0.68663    
hyperlink_clicked  0.18811    0.04131   4.554 5.28e-06 ***
magnify_clicked    0.18530    0.04233   4.377 1.20e-05 ***
expert_clicked     0.19103    0.06980   2.737  0.00621 ** 
time_lt_20        -0.30221    0.05917  -5.107 3.27e-07 ***
time_gt_100        0.32078    0.04335   7.400 1.36e-13 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 18454  on 13510  degrees of freedom
Residual deviance: 18073  on 13505  degrees of freedom
AIC: 18085

Number of Fisher Scoring iterations: 4
```
</font>

Investigation 1: Results
========================================================

|   |Model Type |Activity Measure |Time Spent      |AUC   |
|:--|:----------|:----------------|:---------------|:-----|
|1  |logistic   |scalar           |scalar          |0.589 |
|2  |logistic   |scalar           |log-transformed |0.589 |
|3  |logistic   |binary           |log-transformed |0.593 |
|4  |logistic   |binary           |binary          |0.596 |
|5  |tree       |scalar           |scalar          |0.597 |
|6  |tree       |scalar           |log-transformed |0.596 |
|7  |tree       |binary           |log-transformed |0.597 |
|8  |tree       |binary           |binary          |0.595 |

```
[1] "auc on test of model 4 = 0.61"
```

Investigation 2
========================================================
Which specific learning activities helped assessment score?

<img src="figures/card_map_blocked.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>

Investigation 2: Procedure
========================================================
Which activities help students answer the question on card 5?
<img src="figures/card_map_5.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>
<img src="figures/model 2 full.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>

Investigation 2: Procedure
========================================================
1. Run lasso-regularized logistic regression using all activities before assessment card
1. Find largest regularization parameter that is close to maximum cross-validation AUC
1. Re-run logistic with remaining variables
1. Return variables that have significant impact with p-value < 0.05

Investigation 2: Results
========================================================
<img src="figures/trained model 5.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>

Investigation 2: Results
========================================================
What activities contributed to performance on each assessment card?

|Card |AUC   |Significant Variables                                                                                                                                              |
|:----|:-----|:------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|5    |0.626 |(Intercept), magnify_clicked_5, time_lt_20_3, time_lt_20_4, time_lt_20_5                                                                                           |
|9    |0.617 |(Intercept), label_5, magnify_clicked_9, time_lt_20_7                                                                                                              |
|12   |0.656 |label_5, label_9, hyperlink_clicked_10, time_lt_20_5, time_lt_20_9, time_lt_20_12                                                                                  |
|15   |0.576 |(Intercept), time_lt_20_5, time_lt_20_8                                                                                                                            |
|19   |0.611 |label_5, label_12, label_15, hyperlink_clicked_19, magnify_clicked_19, expert_clicked_15, time_lt_20_2, time_lt_20_5, time_lt_20_15, time_lt_20_19, time_gt_100_19 |
|21   |0.628 |label_5, label_9, label_19, hyperlink_clicked_21, magnify_clicked_20, expert_clicked_19, time_lt_20_15, time_lt_20_20, time_gt_100_21                              |

Investigation 2: Results
========================================================
<img src="figures/results map.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>

Next Steps
========================================================
- Close analysis of card content
- Discussion with MedU content designers
- Make re-usable for any online course.
- Use more robust, summative assessment.

Thanks
========================================================
To Matt Cirigliano, Martin Pusic, and Oleksandr Savenkov of NYU School of Medicine for providing data and consultation.
