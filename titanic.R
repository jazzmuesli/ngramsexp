# install.packages('randomForest')
library(randomForest)
data <- read.csv("titanic-train.csv")
data$survived <- as.factor(data$survived)

# 80% to train and 20% to test
ind <- sample(2, nrow(data), replace = TRUE, prob=c(0.8, 0.2))
rf <- randomForest(survived ~ pclass+sex+age+fare+parch+sibsp, data=data[ind == 1,], na.action=na.roughfix)
# error rate is about 18%..TODO: 18% from 100% aka data or 20% aka data[ind == 1,]?
pred <- predict(rf, data[ind == 2,])
table(observed = data[ind==2, "survived"], predicted = pred)
## Get prediction for all trees.
predict(rf, data[ind == 2,], predict.all=TRUE)
## Proximities.
predict(rf, data[ind == 2,], proximity=TRUE)
## Nodes matrix.
str(attr(predict(rf, data[ind == 2,], nodes=TRUE), "nodes"))

