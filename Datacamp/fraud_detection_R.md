---
Title: Fraud Detection in R
---

# Introduction and Motivation

Fraud can be defined as an uncommon, well-considered, imperceptibly concealed, time evolving and oftern carefully organized crime which appears in many types nad forms.

Although fraud is rare, the cost of not detecting can be huge.

**Key characteristics of successful fraud analytics models**
- statistical accuracy
- Interpretability which refers to how well the model can be understood
- Regulatory compliance
- Economical impact
- Complement expert based approaches with data-driven techniques

**Challenges of fraud detection model**
- Imbalance
- Operational efficiency (decision time for credit card fraud detection is < 8 seconds)
- Avoid harassing good customers

The proportion of each class can be determined by using the following code:

```R
prop.table(table(fraud_label))
```

The following code returns a pie chart with data balance:

```R
# This first code basically creates the label to be used on the pie chart. Using the labels "no fraud" and "fraud" it pastes to the percentage which is generate by using `prop.table(table())` 

labels <- c("no fraud", "fraud")
labels <- paste(labels, round(100*prop.table(table(fraud_lable)),2))
labels <- paste0(lables, "%")

# Creates pie chart using the `pie()` function from the datavoz package
pie(table(fraud_lables), lables, col = c("blue","red"), main = "Pie chart of storm claims")
```

Due to the severe imbalanced, accuracy i not a good performance measure. Since fraud is typically very rare, it is important to take the large imbalance between the number of fraudulent cases and regular cases into account. 

Here follows and example of code to generate and a chart for imbalance data:

```R
# Print the first 6 rows of the dataset
head(transfers)

# Display the structure of the dataset
str(transfers)

# Determine fraction of legitimate and fraudulent cases
class_distribution <- prop.table(table(transfers$fraud_flag))
print(class_distribution)

# Make pie chart of column fraud_flag. This code mainly creates a new data frame with labels that will be used on the chart
df <- data.frame(class = c("no fraud", "fraud"), 
                 pct = as.numeric(class_distribution)) %>%
  mutate(class = factor(class, levels = c("no fraud", "fraud")),
         cumulative = cumsum(pct), midpoint = cumulative - pct / 2,
         label = paste0(class, " ", round(pct*100, 2), "%"))

# In this example it uses ggplot for generating the pie chart
ggplot(df, aes(x = 1, weight = pct, fill = class)) +
  scale_fill_manual(values = c("dodgerblue", "red")) +
  geom_bar(width = 1, position = "stack") +
  coord_polar(theta = "y") +
  geom_text(aes(x = 1.3, y = midpoint, label = label)) +
  theme_nothing()
```

Another example where we calculate the cost of not detecting fraud:

```R
# Create vector predictions containing 0 for every transfer
predictions <- factor(rep.int(0, nrow(transfers)), levels = c(0, 1))

# Compute confusion matrix
confusionMatrix(data = predictions, reference = transfers$fraud_flag)

# Compute cost of not detecting fraud
cost <- sum(transfers$amount[transfers$fraud_flag == 1])
print(cost)
```

Time is an importante aspect in fraud detection. Certain events are expected to occur at similar moments in time. The goal is to crete features that caputure information about the time aspect of events. 

Timestamps have tobe treated differently from other arithmetic data. We shouldn't use arithematic mean to compute an average timestamp! Digital times can be converted to decimals by using the function hms fro the ludbridate:

```R
library(lubridate)
ts <- as.numeric(hms(timestamps)) / 3600

# The following creates a circular histogram:
library(ggplot2)

clock <- ggplot(data.frame(ts), aes(x = ts)) +
  geom_histogram(breaks = seq(0, 24), colour = "blue", fill = "lightblue") +
  coord_polar()

# The mean is then added as a vertical line
arithmetic_mean <- mean(ts)

clock + geom_vline(xintercept = arithmetic_mean,
                     linetype = 2, color = "red", size = 2)
```

We can model a timestamp as periodic variable uisng the von Mises probability distribution. Periodic normal distribution = normal distribution wrapped around a circle.

$$D~vonMises(\mu,k)$$ 

Where $\mu$ is the periodic mean and 1/k is the periodic variance and k is a measure of concentration.

```R
# Convert the decimal timestamps to class "circular"
library(circular)
ts <- circular(ts, units = "hours", template = "clock24")
head(ts)
Circular Data: 
[1] 20.457889 21.144607  1.504422  0.950982 23.203917  4.904397

estimates <- mle.vonmises(ts)
p_mean <- estimates$mu %% 24
concentration <- estimates$kappa
```
If a transaction is done outside the confidence interval then it can be consider a abnormal.

```R
# Convert the plain text to hours
ts <- as.numeric(hms(timestamps)) / 3600

# Convert the data to class circular
ts <- circular(ts, units = "hours", template = "clock24")

# Estimate the periodic mean from the von Mises distribution
estimates <- mle.vonmises(ts)

# Extract the periodic mean from the estimates
p_mean <- estimates$mu %% 24

# Add the periodic mean to the circular histogram
clock <- ggplot(data.frame(ts), aes(x = ts)) +
  geom_histogram(breaks = seq(0, 24), colour = "blue", fill = "lightblue") +
  coord_polar() + scale_x_continuous("", limits = c(0, 24), breaks = seq(0, 24)) +
  geom_vline(xintercept = as.numeric(p_mean), color = "red", linetype = 2, size = 1.5)

plot(clock)
```

The following code creates a cut off based on 95% - Ci:

```R
# Estimate the periodic mean and concentration on the first 24 timestamps
p_mean <- estimates$mu %% 24
concentration <- estimates$kappa

# Estimate densities of all 25 timestamps
densities <- dvonmises(ts, mu = p_mean, kappa = concentration)

# Check if the densities are larger than the cutoff of 95%-CI
cutoff <- dvonmises(qvonmises((1 - alpha)/2, mu = p_mean, kappa = concentration), mu = p_mean, kappa = concentration)

# Define the variable time_feature
time_feature <- densities >= cutoff
print(cbind.data.frame(ts, time_feature))
```

In order to detect fraud we will need more features than just the timestamp. In this case we will look into authentication methods. We will create a feature that keeps track of how frequently a person used a specific authentication method.

A frequency feature counts how frequently a certain event has happened in the past. Creating such features helps detecting anomalous behavior.

Function counts the number of previous transfers with the same authentication method as the current one:

```R
frequency_fun <- function(steps, auth_method) {
      n <- length(steps)
      frequency <- sum(auth_method[1:n] == auth_method[n + 1])
      return(frequency)
  }
```

The function counts the transfers made before that used the same authentication method as the lastest transfer. We can automate this process by using zoo:

```R
library(zoo)
freq_auth <- rollapply(trans_Alice$transfer_id,
                         width = list(-1:-length(trans_Alice$transfer_id)),
                         partial = TRUE,
                         FUN = frequency_fun,
                         trans_Alice$authentication_cd)
```

This way the function frequency_fun is applied on each transfer consecutively. We then can apply this to all data:

```R
trans <- trans %>% group_by(account_name) %>%
   mutate(freq_auth = c(0,
                        rollapplyr(transfer_id,
                                   width = list(-1:-length(transfer_id)),
                                   partial = TRUE,
                                   FUN = count_fun, authentication_cd)
                        )
          )

```

Applying this to the example variable we noticed that both methods that generate fraud have a frequency of zero.

Another example of the above:
```R
# Frequency feature based on channel_cd
frequency_fun <- function(steps, channel) {
  n <- length(steps)
  frequency <- sum(channel[1:n] == channel[n+1])
  return(frequency)
}

# Create freq_channel feature
freq_channel <- rollapply(trans_Bob$transfer_id, width = list(-1:-length(trans_Bob$transfer_id)), partial = TRUE, FUN = frequency_fun, trans_Bob$channel_cd)

# Print the features channel_cd, freq_channel and fraud_flag next to each other
freq_channel <- c(0, freq_channel)
cbind.data.frame(trans_Bob$channel_cd, freq_channel, trans_Bob$fraud_flag)
```

We will now learn how to engineer another kinf of features called recency features. Recency features capture the dimension of time in such a way that anomalous behavior of fraud causes is highlighted. A zero or small recency could indicate anomalous behaviour. We define recency as the exponential of minus gamma time t. Being t the time interval between two conseutive events of the same type and gamma a tuning parameter:

$$recency= exp(-\gamma * t)$$

A recency feature says how recent a certain event has happened in the past. The more recent an event has occurred, the closer its recency will be to 1. If a new and previously unseen case occurs, its recency will be 0. Such features helps detecting anomalous behavior.

But how to choose gamma? Gamma is typically chosen such taht recency has to be equal to 0.01 after 180 days. Gamma = -log(0.01)/180

```R
recency_fun <- function(t, gamma, auth_cd, freq_auth) {
  n_t <- length(t)

  if (freq_auth[n_t] == 0) {
    recency <- 0 # recency = 0 when frequency = 0
  } else {
    time_diff <- t[1] - max(t[2:n_t][auth_cd[(n_t-1):1] == auth_cd[n_t]])
    # time-interval = current timestamp
    #                 - timestamp of previous transfer with same auth_cd
    recency <- exp(-gamma * time_diff)
  }
  return(recency)
}

# Choose gamma value
gamma <- -log(0.01)/180 # = 0.0256

# Applies function to all database
library(dplyr) # needed for group_by() and mutate()
library(zoo) # needed for rollapply()

trans <- trans %>% group_by(account_name) %>%
    mutate(rec_auth = rollapply(timestamp,
                               width = list(0:-length(transfer_id)),
                               partial = TRUE,
                               FUN = recency_fun,
                               gamma, authentication_cd, freq_auth))

```

```R
# Create the recency function
recency_fun <- function(t, gamma, channel_cd, freq_channel) {
  n_t <- length(t)
  if (freq_channel[n_t] == 0) {
    return(0)
  } else {
    time_diff <- t[1] - max(t[2:n_t][channel_cd[(n_t-1):1] == channel_cd[n_t]])
    exponent <- -gamma * time_diff
    return(exp(exponent))
  }
}

# Group, mutate and rollapply
trans <- trans %>% group_by(account_name) %>%
  mutate(rec_channel = rollapply(timestamp, width = list(0:-length(transfer_id)), partial = TRUE,
                                 FUN = recency_fun, gamma, channel_cd, freq_channel))

# Print a new dataframe
as.data.frame(trans %>% select(account_name, channel_cd, timestamp, rec_channel, fraud_flag))
```
# Social network analytics

In this chapter we will focus exclusively on using social networks for fraud detection.

A social network consists of both nodes and edges. Nodes can be customers, companies, products, credit cards, accounts or webpages. The edges or links define the connection between the nodes. The edge definition depends on the context we are working with. The edges can be weighted based upon interaction frequency. The edges can also be directed to reflect the flow of the relationship. 

Social networks can be represented by a sociogram, a connectivity matrix (where 1 represents a connection and 0 a non connection), Adjaceny List, 

```R
# From a transaccional data source we can construct the network as follows

library(igraph)
network <- graph_from_data_frame(transactions, directed = FALSE)

# The following code counts the multiplicity of each edge in the network

E(net)$width <- count.multiple(net)
``` 

You will construct a network starting from a transactional data source. Each line in the transactional data source transfers represents a money transfer between an originator and a beneficiary.

Despite the structured representation of the data, the relationships between originators and beneficiaries are hard to capture. Real life data sources contain billions of transactions making it impossible to extract correlations and useful insights.

```R
# The following creates and plots a network that shows the relationship between originators and beneficiaries

# Load the igraph library
library(igraph)

# Have a look at the data
head(transfers)

# Create an undirected network from the dataset
net <- graph_from_data_frame(transfers, directed = FALSE)
```
The two fundamental building blocks of a social network are nodes and edges. The weights are usually positive values.

```R
# Load igraph and create a network from the data frame
net <- graph_from_data_frame(edges, directed = FALSE)

# Plot the network with the multiple edges
plot(net, layout = layout_in_circle)

# Specify new edge attributes width and curved
E(net)$width <- count.multiple(net)
E(net)$curved <- FALSE

# Check the new edge attributes and plot the network with overlapping edges
edge_attr(net)
plot(net, layout = layout_in_circle)
```

One of the first questions when analysing fraud detection models is that if it might benefit from social network analytics. Are there effects indicating that fraud is a social phenomenon? Fraudster tend to cluster together. 

The following function measures the homophily on a certain network:

```R
assortativity_nominal(network, types = V(network)$isFraud, directed = FALSE)
```

Homophily is a concept which stems from sociology. In a fraud network, homophily implies that fraudsters are more likely to be connected to other fraudsters, and legitimate people are more likely to be connected to other legitimate people. Depending upon the business context and type of fraud, homophily may be present or absent. 

If the coefficient is high, that means that connected vertices tend to have the same labels. 

Attributes can be added to the nodes of your network with V(my_network)$new_node_attribute.

```R
# Add account_type as an attribute to the nodes of the network
V(net)$account_type <- account_info$type

# Have a look at the vertex attributes
print(vertex_attr(net))

# Check for homophily based on account_type
assortativity_nominal(net, types = V(net)$account_type, directed = FALSE)
```

```R
# Each account type is assigned a color
vertex_colors <- c("grey", "lightblue", "darkorange")

# Add attribute color to V(net) which holds the color of each node depending on its account_type
V(net)$color <- vertex_colors[V(net)$account_type]

# Plot the network
plot(net)
```

A relation model is based on the idea that the behavior between nodes is correlated, meaning that connected nodes have a propensity to belong to the same class. The relational neighbor classifier, in particular, predicts a node's class based on its neighboring nodes and adjacent edges.

The geodesic represents the shortest path between two nodes. The closer to the fraudulent node the bigger its influence and impact. 

The degree of a node represents the number of edges or connections. The nomalized degree can be obtained by dividing the degree by the maximum degree possible. 

# Imbalanced class distributions

When a dataset is imbalanced, a classifier tends to favour the amjority class by labeling each case as elgitimate. Classifiers tend to learn better from a *balanced* distribution. We can resolve the imbalance by increasing the number of fraud cases. This is called over sampling the minority class. We can al reduce the number o legitimate cases in our dataset, which is called under sampling the majority class. The result can be the class distribution to be equal or more or less equal. 

Random over-sampling will increase the number of fraud cases on the trainning set by copying randomly selected fraud cases multiple times to an over-sampled dataset. 

In order to know the proportion of each case we can use the following code:

```R
table(creditcard$Class)
prop.table(table(creditcard$Class))
```

**ROSE:** Random over-sampling examples

Using the data package ROSE we can specify how much will be the oversampling:

```R
oversampling_result <- ovun.sample(Class~., data = creditcard, method = "over", N = 42816, seed = 2018)
```

```R
# Load ROSE
library("ROSE")

# Calculate the required number of cases in the over-sampled dataset
# Note that it uses the class = 0 values and says which percentage will it have in the future. 

n_new <- as.numeric(table(creditcard$Class)[1]/(1-0.3333))

# Over-sample
oversampling_result <- ovun.sample(formula = Class~., data = creditcard,
                           method = "over", N = n_new, seed = 2018)

# Verify the Class-balance of the over-sampled dataset
oversampled_credit <- oversampling_result$data
prop.table(table(oversampled_credit$Class))
```

Besides random over-sampling, we can also change the class distribution in a dataset with random under-sampling. Randomly under-sampling the regular cases will decrease the percentage of legitimate cases in the dataset by removing some of them from the training set by random. 

We can use the same way the rose functions on the rose package. When specifying the number of cases in the desired under-sampled dataset, we have to divide the number of fraud cases in the original dataset, which is 492, by the percentage of fraud cases we like in the undersampled dataset. 

Rather than increasing the number of fraud cases in the dataset, you can randomly remove legitimate cases to balance the dataset. 

```R
n_fraud <- 492
new_frac_fraud <- 0.5
new_n_total <- n_fraud/new_frac_fraud

library(ROSE)
undersampling_result <- ovun.sample(Class ~., data = creditcard, method = "under", N = new_ne_total, seed = 2018)
```

We can do both if we specify the method = "both"

```R
n_new <- nrow(creditcard)
fraction_fraud_new <-0.5

sampling_result <- ovun.sample(Class~., data = creditcard, method = "both", N = n_new, p = fraction_fraud_new, seed = 2018)

```
This code will over-sample the fraud cases and undersample the legitimate cases.

Example of using both 

```R
# Load ROSE
library(ROSE)

# Specify the desired number of cases in the balanced dataset and the fraction of fraud cases
n_new <- 10000
fraud_fraction <- 0.3

# Combine ROS & RUS!
sampling_result <- ovun.sample(formula = Class~., data = creditcard,
                           method = "both", N = n_new,  p = fraud_fraction, seed = 2018)

# Verify the Class-balance of the re-balanced dataset
sampled_credit <- sampling_result$data
prop.table(table(sampled_credit$Class))
```

## Synthetic Minority Over-Sampling (SMOT)

SMOTE stands for synthetic minority over sampling technique. The method over samples the fraud class by creating synthetic fraud cases.

In the first step, SMOTE finds the k nearest neighbors of a point that are also fraudulent. On the second step SMOTE randomly chooses one of these k fraudulent neighbors. In step 3 SMOTE will create a synthetic fraudulent sample. First SMOTE chooses a random number between 0 and 1 for example 0.6. A synthetic fraud sample is then created as a linear combination between the first and second point. For this SMOTE computes the difference between the attributes of both points and multiplies with 0.6. 

Smote uses eucledian distance to calculate k neighbors.

```R
# Set the number of fraud and legitimate cases, and the desired percentage of legitimate cases
n0 <- 9348; n1 <- 492; r0 <- 0.6

# Calculate the value for the dup_size parameter of SMOTE
ntimes <- ((1 - r0) / r0) * (n0 / n1) - 1

# Create synthetic fraud cases with SMOTE
smote_output <- SMOTE(X = creditcard[ , -c(1, 31, 32)], target = creditcard$Class, K = 5, dup_size = ntimes)

# Make a scatter plot of the original and over-sampled dataset
credit_smote <- smote_output$data
colnames(credit_smote)[30] <- "Class"
prop.table(table(credit_smote$Class))

ggplot(creditcard, aes(x = V1, y = V2, color = Class)) +
  geom_point() +
  scale_color_manual(values = c('dodgerblue2', 'red'))

ggplot(credit_smote, aes(x = V1, y = V2, color = Class)) +
  geom_point() +
  scale_color_manual(values = c('dodgerblue2', 'red'))
```

```R
# Train the rpart algorithm on the original training set and the SMOTE-rebalanced training set
model_orig <- rpart(Class ~ ., data = train_original)
model_smote <- rpart(Class ~ ., data = train_oversampled)

# Predict the fraud probabilities of the test cases
scores_orig <- predict(model_orig, newdata = test, type = "prob")[, 2]
scores_smote <- predict(model_smote, newdata = test, type = "prob")[, 2]

# Convert the probabilities to classes (0 or 1) using a cutoff value
predicted_class_orig <- factor(ifelse(scores_orig > 0.5, 1, 0))
predicted_class_smote <- factor(ifelse(scores_smote > 0.5, 1, 0))

# Determine the confusion matrices and the model's accuracy
CM_orig <- confusionMatrix(data = predicted_class_orig, reference = test$Class)
CM_smote <- confusionMatrix(data = predicted_class_smote, reference = test$Class)
print(CM_orig$table)
print(CM_orig$overall[1])
print(CM_smote$table)
print(CM_smote$overall[1])
```

```R

### Function to predict the cost of a model

cost_model <- function(predicted.classes, true.classes, amounts, fixedcost) {
  library(hmeasure)
  predicted.classes <- relabel(predicted.classes)
  true.classes <- relabel(true.classes)
  cost <- sum(true.classes * (1 - predicted.classes) * amounts + predicted.classes * fixedcost)
  return(cost)
}

### Aplying the formula

# Calculate the total cost of deploying the original model
cost_model(predicted_class_orig, test$Class, test$Amount, 10)

# Calculate the total cost of deploying the model using SMOTE
cost_model(predicted_class_smote, test$Class, test$Amount, 10)
```	
```R
# Create boxplot
bp.thexp <- boxplot(thexp, col = "lightblue", main = "Standard boxplot", ylab = "Total household expenditure")

# Extract the outliers from the data
bp.thexp$out

# Create adjusted boxplot
adj.thexp <- adjbox(thexp, col = "lightblue", main = "Adjusted boxplot", ylab = "Total household expenditure")
```























