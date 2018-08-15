#set the working directory
setwd("C:\\Users\\junjun\\NadineWest_test\\Data")

#use the sqldf library as well as its driver
library(sqldf)
options(sqldf.driver="SQLite") 

#get the customer id, category_id and count the customer_id
rslt <- sqldf("select count(shp.customer_id) cnt, shp.customer_id, ps.category_id from prod_shpmnts as ps join shpmnts as shp on ps.shipment_id = shp.id group by ps.category_id, shp.customer_id order by ps.category_id, cnt desc")

#split the category ID in preparation for the display of the customer ID which bought the most items
categories <- split(rslt,rslt$category_id)

#display the customer ID which bought the most item per category ID
customerIDWithMostItems <- lapply(categories,function(x) {x[1,2]})


#### ANSWER TO QUESTION # 3 #### 
#### $Bottoms    #### 
#### [1] 23989   #### 
####             #### 
#### $Bracelets  #### 
#### [1] 19961   ####  
####             #### 
#### $Dresses    #### 
#### [1] 6835    ####  
####             #### 
#### $Earrings   #### 
#### [1] 463     ####  
####             #### 
#### $Necklaces  #### 
#### [1] 887     #### 
####             #### 
#### $Others     #### 
#### [1] 29476   #### 
####             #### 
#### $Scarves    #### 
#### [1] 1538    #### 
####             #### 
#### $Tops       #### 
#### [1] 463     ####  