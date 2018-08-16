library(dplyr)

#############Load data

#Set working directory
setwd("C:/Users/mcalderonloor/Documents/UP/")
#Read data
customers <- readRDS("customers.rds")
products <- readRDS("products_in_shipments.rds")
shipments <- readRDS("shipments.rds")


#1. Which is the item category (category_id) that customers kept the most?

#filter kept items
sb1<- products %>%
  select(category_id,kept_flag) %>%
  filter (kept_flag=='TRUE')

#count categories
answer_q1<- sb1 %>% 
  count(category_id)

#answer
answer_q1[which(answer_q1$n==max(answer_q1$n)),"category_id"]

#2. What is the item category (category_id) that most cutomers stole?

#subset data
sb2<-products[,c("category_id","shipment_id")]

#filter stolen items
sb3<-shipments[which(shipments$has_stolen=='TRUE'),c("id","customer_id")] #the max amount can change if is_stolen is choosen instead, but the category is the same
colnames(sb3)<-c("shipment_id","customer_id")

#create a new dataframe relating the products, customers and shipments
sb4<-merge(sb2,sb3,by=c("shipment_id"),all=FALSE)

#count categories
answer_q2<- sb4 %>% 
  count(category_id)
#answer
answer_q2[which(answer_q2$n==max(answer_q2$n)),"category_id"]

#3. For each item category (category_id) find the customer id that has bought the most amount of items.

#subset data
sb5<-shipments[,c("id","customer_id")]
colnames(sb5)<-c("shipment_id","customer_id")  

# create dataframe for analysis
sb6<-merge(sb2,sb5,by=c("shipment_id"),all=FALSE)

# create a list by group
sb6<-split(sb6,sb6$category_id)

#apply a function for identifying the customer that most bougth per item
answer_q3 <- list()
answer_q3<-lapply(sb6,function (x) {
  tail(names(sort(table(x["customer_id"]))), 1)
  })
print(answer_q3)


#4 Using customers that have closed at least 5 shipments, create 2 or more groups of customers according 
# to their behaviour (the items they keep the most) and explain the model used to group the models.
  
# load library for grouping (clustering) customers
library(cluster)
#filter items that has been kept
prod_sb<-products[which(products$kept_flag=='TRUE'),c("category_id","shipment_id")]
#filter shipments with items that has been kept
ship_sb<-shipments[which(shipments$items_kept_count>0),c("id","customer_id")]
colnames(ship_sb)<-c("shipment_id","customer_id")

#filter customers that have closed at least 5 shipments
filter_shipments <- count(ship_sb, customer_id)
filter_shipments <- filter_shipments[which(filter_shipments$n >= 5),"customer_id"]

#update subsetted shipments and products
ship_sb<-merge(filter_shipments,ship_sb,all=FALSE)
prod_sb<-prod_sb[prod_sb$shipment_id %in% ship_sb$shipment_id,]

#create a dataframe for clustering
sb7<-merge(prod_sb,ship_sb,by=c("shipment_id"),all=FALSE)
# transform category_id to numeric values for using it during the clustering
sb7$category_id<-as.numeric(as.factor(sb7$category_id))
# selecting only the variables that will be considered for the clustering
sb7<-sb7[,2:3]

#A kmeans clustering algorithm (unsupervised learning) has been selected as we don't have any previous information
#about customer behaviour, in this case the firs step is to determine the optimum number of clusters here this step
# is done by calculating the within groups sum of squares assuming different number of clusters.
cluster_numbers <- (nrow(sb7)-1)*sum(apply(sb7,2,var))

#within groups sum of squares by number of clusters
for (i in 2:8) {
  cluster_numbers[i] <- sum(kmeans(sb7,centers=i)$withinss)
}

#The final number of clusters is determined based on the slope of the following graph
#the intention is to find a number of clusters so the within groups sum of squares is minimum
#a rule of thumb is applied, from the analysis of the graph it can be seen that the sum of squares
#start to stabilize around 3-4 clusters.
plot(1:8, cluster_numbers, type="b", xlab="Number of Clusters",ylab="Within groups sum of squares")

#From the previous step a number of three clusters was choosen. With this the clustering can be performed
#by using the kmeans algorithm
kmeans_fit <- kmeans(sb7, 3)

#adding the cluster number to each observation
sb7 <- data.frame(sb7, kmeans_fit$cluster)

#analyse the resulting cluster
clusplot(sb7, kmeans_fit$cluster, color=TRUE, shade=TRUE, lines=0)
