## ----echo=T,warning=FALSE,results=FALSE, message=FALSE-------------------------------------------------------
library (arules)
library (dplyr)
library(plyr)
library(tidyr)
library(tidyverse)
library (arulesViz)
library (Rcpp)


## ----Read data-----------------------------------------------------------------------------------------------
#read and summarize data
groceries <- read.csv("Groceries_dataset.csv")

head(groceries)
summary(groceries)



## ----Clean data----------------------------------------------------------------------------------------------
# Remove any duplicates
groceries <- distinct(groceries)

# Convert the Date column to a date format
groceries$Date <- as.Date(groceries$Date, format = "%Y-%m-%d")

# Remove any rows with missing values
groceries2 <- drop_na(groceries)

###Change the name of variables to make more easy 

colnames(groceries2)[colnames(groceries2)=="itemDescription"] <- "Item"

###Check last version of dataset
head(groceries2)
dim(groceries2)
str(groceries2)





## ------------------------------------------------------------------------------------------------------------
###Order data according to member_number
sorted <- groceries2[order(groceries2$Member_number),]


###Group all the items that  bought  by the same customer on the same date to see set of items
itemList <- aggregate(Item ~ Member_number + Date, data = groceries2, FUN = function(x) paste(x, collapse = ","))
                
head(itemList,5)
dim(itemList)


## ----Subset only for items and Convert Transaction-----------------------------------------------------------

subset <- itemList[,3]
write.csv(subset,"subset", quote = FALSE, row.names = TRUE)
head(subset)
dim(subset)


trans1 = read.transactions(file="subset", rm.duplicates= TRUE, format="basket",sep=",",cols=1);
head(trans1)
dim(trans1)

length(trans1)
LIST(head(trans1))


# Print the number of transactions and items in the dataset
cat("Number of transactions:", length(trans1), "\n")
cat("Number of items:", length(itemLabels(trans1)), "\n")


itemFrequencyPlot(trans1, topN = 25)



## ----One Dimension Table-------------------------------------------------------------------------------------
head(sort(round(itemFrequency(trans1),3),decreasing = TRUE))


## ------------------------------------------------------------------------------------------------------------
head(sort(itemFrequency(trans1, type="absolute"),decreasing = TRUE))


## ------------------------------------------------------------------------------------------------------------
sets<-eclat(trans1, parameter = list( sup = 0.001 , maxlen=15)) 
class(sets)

inspect(head(sets, n = 5))
head(round(support(items(sets), trans1) , 2))

# getting rules
sets<-ruleInduction(sets, trans1, confidence=0.08) 

# screening the  part of the rules
inspect(head(sets))

summary(sets)

plot(sets, jitter = 0)

plot(sets[1:50], method="graph")

plot(sets[1:50], method="paracoord")


## ------------------------------------------------------------------------------------------------------------
# creating rules - standard settings
rules.trans1<-apriori(trans1, parameter=list(supp=0.001 , conf=0.08))  

summary(rules.trans1)

plot(rules.trans1, jitter = 0)

plot(rules.trans1[1:50], method="graph")

plot(rules.trans1[1:50], method="paracoord")



## ------------------------------------------------------------------------------------------------------------
# Changing rules - standard settings
rules.trans2<-apriori(trans1, parameter=list(supp=0.002 , conf=0.05))  

summary(rules.trans2)

plot(rules.trans2, jitter = 0.25)

plot(rules.trans2[1:20], method="graph")

plot(rules.trans2[1:50], method="paracoord")



## ------------------------------------------------------------------------------------------------------------
trans1.closed<-apriori(trans1, parameter=list(target="closed frequent itemsets", support=0.01))
inspect(head(trans1.closed))
is.closed(trans1.closed)  

freq.closed<-eclat(trans1, parameter=list(supp=0.001, maxlen=15, target="closed frequent itemsets"))
inspect(head(freq.closed))

freq.max<-eclat(trans1, parameter=list(supp=0.001, maxlen=15, target="maximally frequent itemsets"))
inspect(head(freq.max)) 



## ------------------------------------------------------------------------------------------------------------
####similarity & dissimilarity 
trans.sel<-trans1[,itemFrequency(trans1)>0.05] # selected transations
d.jac.i<-dissimilarity(trans.sel, which="items") # Jaccard as default
round(d.jac.i,2) 





