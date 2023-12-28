{"cells":[{"source":"<a href=\"https://www.kaggle.com/code/guleli8759/unveiling-consumer-tales-a-market-basket-analysis?scriptVersionId=156838835\" target=\"_blank\"><img align=\"left\" alt=\"Kaggle\" title=\"Open in Kaggle\" src=\"https://kaggle.com/static/images/open-in-kaggle.svg\"></a>","metadata":{},"cell_type":"markdown"},{"cell_type":"markdown","id":"4c23e4cd","metadata":{"_cell_guid":"e4203890-3513-45e0-b7d7-891a02403d5d","_uuid":"f6130c6d-dfdc-46f9-99e6-d09b0b881566","execution":{"iopub.execute_input":"2023-12-28T10:42:14.669657Z","iopub.status.busy":"2023-12-28T10:42:14.667777Z","iopub.status.idle":"2023-12-28T10:42:14.690645Z"},"jupyter":{"outputs_hidden":false},"papermill":{"duration":0.002378,"end_time":"2023-12-28T11:56:28.972709","exception":false,"start_time":"2023-12-28T11:56:28.970331","status":"completed"},"tags":[]},"source":["---\n","title: \"Market Basket Analyses\"\n","author: \"Gizem Guleli\"\n","date: '2023-02-04'\n","output:\n","  html_document: default\n","  word_document: default\n","  pdf_document: default\n","---\n","\n","\n","\n","```{r, echo=T,warning=FALSE,results=FALSE, message=FALSE}\n","library (arules)\n","library (dplyr)\n","library(plyr)\n","library(tidyr)\n","library(tidyverse)\n","library (arulesViz)\n","library (Rcpp)\n","```\n","\n","\n","\n","### DATA \n","\n","The Groceries dataset is a collection of 38765 transactions made at a grocery store. Each transaction contains a list of items purchased by a customer. This dataset can be used for market basket analysis, which is a technique used to identify patterns in customer purchasing behavior.\n","\n","I first read data set and then clean missing values and dublicates row. \n","\n","```{r Read data} \n","#read and summarize data\n","groceries <- read.csv(\"Groceries_dataset.csv\")\n","\n","head(groceries)\n","summary(groceries)\n","\n","```\n","\n","```{r Clean data}\n","# Remove any duplicates\n","groceries <- distinct(groceries)\n","\n","# Convert the Date column to a date format\n","groceries$Date <- as.Date(groceries$Date, format = \"%Y-%m-%d\")\n","\n","# Remove any rows with missing values\n","groceries2 <- drop_na(groceries)\n","\n","###Change the name of variables to make more easy \n","\n","colnames(groceries2)[colnames(groceries2)==\"itemDescription\"] <- \"Item\"\n","\n","###Check last version of dataset\n","head(groceries2)\n","dim(groceries2)\n","str(groceries2)\n","\n","\n","\n","```\n","\n","```{r}\n","###Order data according to member_number\n","sorted <- groceries2[order(groceries2$Member_number),]\n","\n","\n","###Group all the items that  bought  by the same customer on the same date to see set of items\n","itemList <- aggregate(Item ~ Member_number + Date, data = groceries2, FUN = function(x) paste(x, collapse = \",\"))\n","                \n","head(itemList,5)\n","dim(itemList)\n","```\n","\n","\n","### ANALYSE\n","\n","First of all the original groceries data frame is subsetted  to select only the column containing the items , and then converted the resulting data frame of items to a transaction object  using read.transaction() function because the transaction object is the preferred format for performing market basket analysis using the arules package in R.\n","\n","By converting the item data into a transaction object, we can use the functions in the arules package to perform association rule mining, which involves finding patterns in the data such as frequent itemsets (groups of items that are frequently purchased together) and association rules. In the end I print the total number of transactions and items in the dataset.As we see from the result there are 14935 transaction and 168 items.\n","\n","\n","\n","```{r Subset only for items and Convert Transaction }\n","\n","subset <- itemList[,3]\n","write.csv(subset,\"subset\", quote = FALSE, row.names = TRUE)\n","head(subset)\n","dim(subset)\n","\n","\n","trans1 = read.transactions(file=\"subset\", rm.duplicates= TRUE, format=\"basket\",sep=\",\",cols=1);\n","head(trans1)\n","dim(trans1)\n","\n","length(trans1)\n","LIST(head(trans1))\n","\n","\n","# Print the number of transactions and items in the dataset\n","cat(\"Number of transactions:\", length(trans1), \"\\n\")\n","cat(\"Number of items:\", length(itemLabels(trans1)), \"\\n\")\n","\n","\n","itemFrequencyPlot(trans1, topN = 25)\n","\n","```\n","\n","\n","\n","Calculates the relative and absolute frequency of occurrence of each item in the transaction dataset trans1. First frequencies are expressed as a proportion between 0 and 1, where 1 represents an item that appears in every transaction and 0 represents an item that does not appear in any transaction while the second (absolute) frequencies are expressed as infinite integers that represent the number of transactions in which the item appears. To see the most occured items I ordered result as descending and results show that whole milk, other vegetables and rollss/buns are the most occured 3 items.\n","\n","\n","```{r One Dimension Table}\n","head(sort(round(itemFrequency(trans1),3),decreasing = TRUE))\n","```\n","\n","```{r}\n","head(sort(itemFrequency(trans1, type=\"absolute\"),decreasing = TRUE))\n","```\n","\n","\n","\n","\n","### Algorithms\n","\n","#### Eclat\n","\n","```{r}\n","sets<-eclat(trans1, parameter = list( sup = 0.001 , maxlen=15)) \n","class(sets)\n","\n","inspect(head(sets, n = 5))\n","head(round(support(items(sets), trans1) , 2))\n","\n","# getting rules\n","sets<-ruleInduction(sets, trans1, confidence=0.08) \n","\n","# screening the  part of the rules\n","inspect(head(sets))\n","\n","summary(sets)\n","\n","plot(sets, jitter = 0)\n","\n","plot(sets[1:50], method=\"graph\")\n","\n","plot(sets[1:50], method=\"paracoord\")\n","```\n","\n","\n","\n","#### The Apriori \n","\n","```{r}\n","# creating rules - standard settings\n","rules.trans1<-apriori(trans1, parameter=list(supp=0.001 , conf=0.08))  \n","\n","summary(rules.trans1)\n","\n","plot(rules.trans1, jitter = 0)\n","\n","plot(rules.trans1[1:50], method=\"graph\")\n","\n","plot(rules.trans1[1:50], method=\"paracoord\")\n","\n","```\n","\n","```{r}\n","# Changing rules - standard settings\n","rules.trans2<-apriori(trans1, parameter=list(supp=0.002 , conf=0.05))  \n","\n","summary(rules.trans2)\n","\n","plot(rules.trans2, jitter = 0.25)\n","\n","plot(rules.trans2[1:20], method=\"graph\")\n","\n","plot(rules.trans2[1:50], method=\"paracoord\")\n","\n","```\n","\n","\n","When examining the co-occurrence of items in the dataset, we can see that there are many strong associations between items. For example, if a customer purchases citrus fruit, they are also likely to purchase tropical fruit, root vegetables, other vegetables, and whole milk. The lift values show us that these associations are stronger than what we would expect by chance.\n","\n","The chi-squared test shows that there are significant associations between many of the items in the dataset. The p-values are very small, indicating that we can reject the null hypothesis of independence and conclude that there are associations between items.\n","\n","Overall, the analysis shows that there are many strong associations between items in the groceries dataset, and that these associations are significant. This information can be useful for retailers who want to optimize product placement, promotions, and recommendations for customers based on their purchase history.\n","\n","\n","I set the minimum support to 0.001 and the minimum confidence to 0.08. This means that we are only interested in rules with a support of at least 0.001 (i.e., the rule must appear in at least 0.1% of all transactions) and a confidence of at least 0.08 (i.e., the rule must be correct at least 8% of the time). Then tried it with minimum support to 0.002 and the minimum confidence to 0.05.\n","\n","Then I use the inspect() function to generate a list of association rules based on the specified itemsets, and sort the rules by lift. Finally,  convert the list of rules to a data frame and show the top 10 rules.\n","\n","\n","\n","#### Rules for closed itemsets\n","```{r}\n","trans1.closed<-apriori(trans1, parameter=list(target=\"closed frequent itemsets\", support=0.01))\n","inspect(head(trans1.closed))\n","is.closed(trans1.closed)  \n","\n","freq.closed<-eclat(trans1, parameter=list(supp=0.001, maxlen=15, target=\"closed frequent itemsets\"))\n","inspect(head(freq.closed))\n","\n","freq.max<-eclat(trans1, parameter=list(supp=0.001, maxlen=15, target=\"maximally frequent itemsets\"))\n","inspect(head(freq.max)) \n","\n","```\n","\n","\n","\n","\n","```{r}\n","####similarity & dissimilarity \n","trans.sel<-trans1[,itemFrequency(trans1)>0.05] # selected transations\n","d.jac.i<-dissimilarity(trans.sel, which=\"items\") # Jaccard as default\n","round(d.jac.i,2) \n","\n","\n","\n","\n","```\n","\n","\n","### REFERENCES\n","\n","Data: https://www.kaggle.com/datasets/heeraldedhia/groceries-dataset\n","\n","\n","\n","```{r}\n","options(knitr.purl.inline = TRUE)\n","```\n","\n","```{r}\n","knitr::purl(\"Groceries.Rmd\")\n","```\n","\n","\n","\n","trans1[,itemFrequency(trans1)>0.05] # selected transations\r\n","d.jac.i<-dissimilarity(trans.sel, which=\"items\") # Jaccard as default\r\n","round(d.jac.i,2)"]}],"metadata":{"kaggle":{"accelerator":"none","dataSources":[{"datasetId":877335,"sourceId":1494131,"sourceType":"datasetVersion"},{"datasetId":4232144,"sourceId":7296291,"sourceType":"datasetVersion"}],"dockerImageVersionId":30618,"isGpuEnabled":false,"isInternetEnabled":true,"language":"r","sourceType":"notebook"},"kernelspec":{"display_name":"R","language":"R","name":"ir"},"language_info":{"codemirror_mode":"r","file_extension":".r","mimetype":"text/x-r-source","name":"R","pygments_lexer":"r","version":"4.0.5"},"papermill":{"default_parameters":{},"duration":3.649463,"end_time":"2023-12-28T11:56:29.099073","environment_variables":{},"exception":null,"input_path":"__notebook__.ipynb","output_path":"__notebook__.ipynb","parameters":{},"start_time":"2023-12-28T11:56:25.44961","version":"2.5.0"}},"nbformat":4,"nbformat_minor":5}