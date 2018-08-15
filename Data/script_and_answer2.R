#set the working directory
setwd("C:\\Users\\junjun\\NadineWest_test\\Data")

#use the sqldf library as well as the SQLite driver
library(sqldf)
options(sqldf.driver="SQLite")
#get the category id that is being stole frequently
rslt <- sqldf("select category_id, max(cnt) from (select ps.category_id, count(1) cnt from prod_shpmnts as ps join shpmnts as shp on ps.shipment_id = shp.id where shp.is_stolen = 1 group by category_id order by cnt desc)")

#### ANSWER TO QUESTION #2    #### 
####   > rslt                 #### 
####   category_id max(cnt)   #### 
####  1        Tops    19031  #### 
####   > rslt[,1]             #### 
####   [1] "Tops"             #### 