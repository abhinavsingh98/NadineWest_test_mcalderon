#set the working directory
setwd("C:\\temp\\NadineWest_test\\Data")

#use the sqldf library as well as its driver
library(sqldf)
options(sqldf.driver="SQLite")
#load the products in shipments data
prod_shpmnts <- readRDS("./products_in_shipments.rds")
#count the category id and get the max
rslt <- sqldf("select category_id, max(cnt) from (select category_id, count(1) as cnt from prod_shpmnts where kept_flag = 1 group by category_id order by cnt desc)")

#### ANSWER TO QUESTION 1   ####
#### category_id max(cnt)   #### 
#### 1        Tops   213538 #### 
#### rslt[,1]               ####   
#### [1] "Tops"             #### 