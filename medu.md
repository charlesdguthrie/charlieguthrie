<style>
.reveal h1, .reveal h2, .reveal h3 {
  word-wrap: normal;
  -moz-hyphens: none;
  hyphens: none;
}
img {
  box-shadow:none;
  border:10px;
  border-color:none;
}
.midcenter {
    position: fixed;
    top: 50%;
    left: 50%;
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

Identifying Effective Learning Activities in an Online Course
========================================================
author: Charlie Guthrie
date: May 2, 2016
APSTA-GE 2017: Educational Data Science Practicum

 
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
<!-- #![Screenshot of sample learning card](figures/card_screenshot.png) -->
<img src="figures/card_screenshot.png" style="background-color:transparent; border:0px; box-shadow:none;"></img>

Goal
========================================================
Identify which learning activities were most effective at increasing student assessment performance.

Project Overview
========================================================
1. Predict a student's performance from his/her overall level of engagement in the class. 
1. Predict performance given specific learning activities.

Key Variables
========================================================
Assessment cards  
***
![answer example](resources/answer example.png)

Key Variables
========================================================
Variables that may have an impact on student performance:

  * **Clicking hyperlinks**
  * Magnifying images
  * Checking answers using "expert" links
  * Time spent on cards
  
***
![hyperlink example](resources/hyperlink example.png)
  
Key Variables
========================================================
Variables that may have an impact on student performance:

  * Clicking hyperlinks
  * **Magnifying images**
  * Checking answers using "expert" links
  * Time spent on cards
  
***
![magnify example](resources/magnify example.png)

Key Variables
========================================================
Variables that may have an impact on student performance:

  * Clicking hyperlinks
  * Magnifying images
  * **Checking answers using "expert" links**
  * Time spent on cards
  
***
![expert answer](resources/hyperlink example.png)

Key Variables
========================================================
Variables that may have an impact on student performance:

  * Clicking hyperlinks
  * Magnifying images
  * Checking answers using "expert" links
  * **Time spent on cards**
  
***

Key Variables
========================================================
![card_map](figures/card_map.png)


Initial experiment
========================================================
1. First I did a broad model to establish taht there was a relationship between student engagement and performance.  In other words, good study habits produce better results.

Results of initial experiment
========================================================
Indeed a relationship.  Show how?  With scatter plot?  

1. First say there was significance in model
1. Say students who did x were y more likely to get answer right

More detailed experiment
========================================================
1. Then I broke the data down to identify exactly which components of the lesson cards were useful for achieving better performance
1. Tweaked the models for better accuracy

Results
========================================================
List of significant results for each unit. What activities contributed to performance?
May need actual cards to demonstrate this.  

Thanks
========================================================
To Matt Cirigliano, Martin Pusic, and Oleksandr Savenkov of NYU School of Medicine for providing data and consultation.
