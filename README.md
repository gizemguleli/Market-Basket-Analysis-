# Market-Basket-Analysis-

## Table of Contents 

* [DATA](#DATA )





## DATA 

The Groceries dataset is a collection of 14935 transactions made at a grocery store. Each transaction contains a list of items purchased by a customer. This dataset can be used for market basket analysis, which is a technique used to identify patterns in customer purchasing behavior.

I first read data set and then clean missing values and dublicates row. 



## ANALYSE

First of all the original groceries data frame is subsetted  to select only the column containing the items , and then converted the resulting data frame of items to a transaction object  using read.transaction() function because the transaction object is the preferred format for performing market basket analysis using the arules package in R.

By converting the item data into a transaction object, we can use the functions in the arules package to perform association rule mining, which involves finding patterns in the data such as frequent itemsets (groups of items that are frequently purchased together) and association rules. In the end I print the total number of transactions and items in the dataset.As we see from the result there are 14935 transaction and 168 items.


Calculates the relative and absolute frequency of occurrence of each item in the transaction dataset trans1. First frequencies are expressed as a proportion between 0 and 1, where 1 represents an item that appears in every transaction and 0 represents an item that does not appear in any transaction while the second (absolute) frequencies are expressed as infinite integers that represent the number of transactions in which the item appears. To see the most occured items I ordered result as descending and results show that whole milk, other vegetables and rollss/buns are the most occured 3 items.


### Algorithms

#### Eclat

#### The Apriori 

#### Rules for closed itemsets

#### similarity & dissimilarity 


### Conclusion

When examining the co-occurrence of items in the dataset, we can see that there are many strong associations between items. For example, if a customer purchases citrus fruit, they are also likely to purchase tropical fruit, root vegetables, other vegetables, and whole milk. The lift values show us that these associations are stronger than what we would expect by chance.

The chi-squared test shows that there are significant associations between many of the items in the dataset. The p-values are very small, indicating that we can reject the null hypothesis of independence and conclude that there are associations between items.

Overall, the analysis shows that there are many strong associations between items in the groceries dataset, and that these associations are significant. This information can be useful for retailers who want to optimize product placement, promotions, and recommendations for customers based on their purchase history.


I set the minimum support to 0.001 and the minimum confidence to 0.08. This means that we are only interested in rules with a support of at least 0.001 (i.e., the rule must appear in at least 0.1% of all transactions) and a confidence of at least 0.08 (i.e., the rule must be correct at least 8% of the time). Then tried it with minimum support to 0.002 and the minimum confidence to 0.05.

Then I use the inspect() function to generate a list of association rules based on the specified itemsets, and sort the rules by lift. Finally,  convert the list of rules to a data frame and show the top 10 rules.



### REFERENCES

Data: https://www.kaggle.com/datasets/heeraldedhia/groceries-dataset








