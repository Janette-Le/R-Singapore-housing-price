install.packages("MASS")
library("MASS")

install.packages("glmnet")
library("glmnet")

install.packages("pls")
library("pls")

install.packages("tree")
library("tree")

library("ggplot2")
library("corrplot")


sing <- read.csv("Combined 2.csv")
sing <- na.omit(sing)
dim(sing)
head(sing)
str(sing)

# Convert
sing$Area..sqm. <- as.numeric(sing$Area..sqm.)
sing$Transacted.Price.... <- as.numeric(sing$Transacted.Price....)
sing$Unit.Price....psm. <- as.numeric(sing$Unit.Price....psm.)
sing$Unit.Price....psf. <- as.numeric(sing$Unit.Price....psf.)
sing$Postal.Code <- as.factor(sing$Postal.Code)

# Outlier remove
out1 <- sing$Area..sqm.
ggplot(sing, aes(x=out1)) + geom_histogram(colour="black", fill="pink") + ggtitle("Area distribution")   + ylab("Quantity") + xlab("Fixed acidity") + theme(plot.title = element_text(face = "bold", color = "black", size=14)) + theme(axis.title.x = element_text(face = "bold", color = "black", size=10)) + theme(axis.title.y = element_text(face = "bold", color = "black", size=10))
box1 <- boxplot(out1,
                main = "Fixed acidity boxplot",
                xlab = "Grams/liter",
                ylab = "Fixed acidity",
                col = "orange",
                border = "brown",
                horizontal = TRUE,
                notch = TRUE
)$out
box1 <- out1[out1>500]
sing <- sing[-which(out1 %in% box1),]
out1 <- sing$Area..sqm.
box1 <- boxplot(out1,
                main = "Fixed acidity boxplot",
                xlab = "Grams/liter",
                ylab = "Fixed acidity",
                col = "orange",
                border = "brown",
                horizontal = TRUE,
                notch = TRUE)

out2 <- sing$Transacted.Price....
ggplot(sing, aes(x=out2)) + geom_histogram(colour="black", fill="pink") + ggtitle("Area distribution")   + ylab("Quantity") + xlab("Fixed acidity") + theme(plot.title = element_text(face = "bold", color = "black", size=14)) + theme(axis.title.x = element_text(face = "bold", color = "black", size=10)) + theme(axis.title.y = element_text(face = "bold", color = "black", size=10))
box2 <- boxplot(out2,
                main = "Fixed acidity boxplot",
                xlab = "Grams/liter",
                ylab = "Fixed acidity",
                col = "orange",
                border = "brown",
                horizontal = TRUE,
                notch = TRUE
)$out
box2 <- out2[out2>95e+05]
sing <- sing[-which(out2 %in% box2),]
out2 <- sing$Transacted.Price....
box2 <- boxplot(out2,
                main = "Fixed acidity boxplot",
                xlab = "Grams/liter",
                ylab = "Fixed acidity",
                col = "orange",
                border = "brown",
                horizontal = TRUE,
                notch = TRUE)

out3 <- sing$Unit.Price....psm.
ggplot(sing, aes(x=out3)) + geom_histogram(colour="black", fill="pink") + ggtitle("Area distribution")   + ylab("Quantity") + xlab("Fixed acidity") + theme(plot.title = element_text(face = "bold", color = "black", size=14)) + theme(axis.title.x = element_text(face = "bold", color = "black", size=10)) + theme(axis.title.y = element_text(face = "bold", color = "black", size=10))
box3 <- boxplot(out3,
                main = "Fixed acidity boxplot",
                xlab = "Grams/liter",
                ylab = "Fixed acidity",
                col = "orange",
                border = "brown",
                horizontal = TRUE,
                notch = TRUE
)$out
box3 <- out3[out3>37000]
sing <- sing[-which(out3 %in% box3),]
out3 <- sing$Area..sqm.
box3 <- boxplot(out3,
                main = "Fixed acidity boxplot",
                xlab = "Grams/liter",
                ylab = "Fixed acidity",
                col = "orange",
                border = "brown",
                horizontal = TRUE,
                notch = TRUE)

out4 <- sing$Unit.Price....psf.
ggplot(sing, aes(x=out4)) + geom_histogram(colour="black", fill="pink") + ggtitle("Area distribution")   + ylab("Quantity") + xlab("Fixed acidity") + theme(plot.title = element_text(face = "bold", color = "black", size=14)) + theme(axis.title.x = element_text(face = "bold", color = "black", size=10)) + theme(axis.title.y = element_text(face = "bold", color = "black", size=10))
box4 <- boxplot(out4,
                main = "Fixed acidity boxplot",
                xlab = "Grams/liter",
                ylab = "Fixed acidity",
                col = "orange",
                border = "brown",
                horizontal = TRUE,
                notch = TRUE)

# Split data into train and test
set.seed(12345)
row.number <- sample(x=1:nrow(sing),size=0.75*nrow(sing))
train <- sing[row.number,]
test <- sing[-row.number,]

# Visualize
# positions <- c("6/2018", "7/2018", "8/2018", "9/2018", "10/2018", "11/2018", "12/2018", "1/2019", "2/2019", "3/2019", "4/2019", "5/2019")
ggplot(sing, aes(x=Sale.Date)) +
  geom_bar()+ 
  labs(y= "Count", x="Sale date", title = "Frequency of transation")


area <- sort(table(sing$Planning.Area), decreasing = TRUE)[1:12]
area
headdata <- head(sing, 10)
headdata$col1 <- c(1320, 805 , 607, 598, 564, 513, 350, 295, 278, 271)
headdata$col2 <- c("Toa Payoh", "Tampines", "Bukit Timah", "Pasir Ris", "Bishan", "Bedok", "Bukit Merah", "Senkang", "Hougang", "Marine Parade")
ggplot(headdata, aes(x=col2, y=col1)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(y= "Count", x="Planning Area", title = "Top 10 area involved")

ggplot(sing, aes(x=Low...Mid...High)) +
  geom_bar(binwidth = 10)+ 
  labs(y= "Count", x="Class", title = "Count by class")


ggplot(sing, aes(x=Tenure)) +
  geom_bar()+ 
  labs(y= "Count", x="Tenure", title = "Count by Tenure Category")


# Variables selection
corrplot(corr=cor(sing[,c(1,2,3,4,10)], use = "complete.obs"), type = "up", method = "number")

#Multiple linear regression
original <- lm(Unit.Price....psm. ~  Area..sqm. + Transacted.Price.... + Type.of.Sale  + Purchaser.Address.Indicator + Planning.Region , data =train)
summary(original)

# Predict Y
predicted_y_original <- predict(original, newdata=test)
predicted_y_original

observe_y <- test$Unit.Price....psm.

# Evaluate the prediction accuracy: original model
# R squared
SSE1 <- sum((observe_y - predicted_y_original) ^ 2)
SST1 <- sum((observe_y - mean(observe_y)) ^ 2)
r2.1 <- 1 - SSE1/SST1

# RSS
RSS1 <- sum ((predicted_y_original - observe_y)^2)

#MAE
MAE1 <- mean(abs(observe_y - predicted_y_original))

#RMSE
RMSE1 <- sqrt(sum((predicted_y_original - observe_y)^2)/length(observe_y))

r2.1
RSS1
MAE1
RMSE1

# Stepwise Selection
fake <- lm(Unit.Price....psm. ~ Area..sqm. + Transacted.Price.... + Tenure + Completion.Date + Type.of.Sale + Purchaser.Address.Indicator + 
             Postal.Code + Planning.Region, data =train)
step <- stepAIC(fake,direction ="backward")
step$anova

# Predict Y
predicted_y_step <- predict(step, newdata=test)
predicted_y_step

# Evaluate the prediction accuracy: reduced model

# R squared
SSE2 <- sum((observe_y - predicted_y_step) ^ 2)
SST2 <- sum((observe_y - mean(observe_y)) ^ 2)
r2.2 <- 1 - SSE2/SST2

# RSS
RSS2 <- sum ((predicted_y_step - observe_y)^2)

#MAE
MAE2 <- mean(abs(observe_y - predicted_y_step))

#RMSE
RMSE2 <- sqrt(sum((predicted_y_step - observe_y)^2)/length(observe_y))

r2.2
RSS2
MAE2
RMSE2

# LASSO

# Tranform data:
trainX <- model.matrix(Unit.Price....psm.~., train)[,-1]
trainY <- c(train$Unit.Price....psm.)

testX <- model.matrix(Unit.Price....psm.~., test)[,-1]
testY <- c(test$Unit.Price....psm.)

lasso1 <- cv.glmnet(trainX, trainY, alpha =1, nlambda = 100, lambda.min.ratio=0.0001)
plot(lasso1)
best.lambda <- lasso1$lambda.min
best.lambda

lasso2 <- glmnet(trainX, trainY, alpha =1, nlambda = 100, lambda.min.ratio=0.0001)

ridge <- predict(lasso2, s = best.lambda, new = testX)

# Evaluate the prediction accuracy: Lasso model

# R squared
SSE3 <- sum((testY- ridge) ^ 2)
SST3 <- sum((testY - mean(testY)) ^ 2)
r2.3 <- 1 - SSE3/SST3

# RSS
RSS3 <- sum ((ridge - observe_y)^2)

#MAE
MAE3 <- mean(abs(testY - ridge))

#RMSE
RMSE3 <- sqrt(sum((ridge - testY)^2)/length(testY))

r2.3
RSS3
MAE3
RMSE3


#PCR
pcr_model <- pcr(Unit.Price....psm.~Area..sqm. + Transacted.Price.... + Unit.Price....psf. + 
                   Sale.Date + Tenure + Completion.Date + Type.of.Sale + Purchaser.Address.Indicator + 
                   Postal.Code + Planning.Region,data=train, scale = TRUE, validation ="CV")
summary(pcr_model)

validationplot(pcr_model,val.type = c("RMSEP"))
validationplot(pcr_model,val.type = c("MSEP"))
validationplot(pcr_model,val.type = c("R2"))

pcr <- predict(pcr_model, test, ncomp=3)

# Evaluate the prediction accuracy: PCR

# R squared
SSE4 <- sum((observe_y - pcr) ^ 2)
SST4 <- sum((observe_y - mean(observe_y)) ^ 2)
r2.4 <- 1 - SSE4/SST4

# RSS
RSS4 <- sum ((pcr - observe_y)^2)

#MAE
MAE4 <- mean(abs(observe_y - pcr))

#RMSE
RMSE4 <- sqrt(sum((pcr - observe_y)^2)/length(observe_y))

r2.4
RSS4
MAE4
RMSE4

# CLASSIFICATION TREE
# Split data into train and test
names(sing) <- c("area_sqm","TransactedPrice","UnitPrice_psm","UnitPrice_psf","SaleDate","Tenure","CompletionDate","TypeofSale","PurchaserType","PostalCode","PlanningRegion","PlanningArea","Classification")
set.seed(12345)
row.number <- sample(x=1:nrow(sing),size=0.75*nrow(sing))
train <- sing[row.number,]
test <- sing[-row.number,]

#Model0
classification_train=tree(Classification ~.-UnitPrice_psf -UnitPrice_psm -PostalCode -area_sqm -TransactedPrice -CompletionDate,data=train)
summary(classification_train)
plot(classification_train)
text(classification_train,pretty=0)
classification_test=predict(classification_train,test,type="class")
table(classification_test,test$Classification)

#Model1
classification_train1=tree(Classification ~.-UnitPrice_psf -UnitPrice_psm -PostalCode -area_sqm -TransactedPrice -CompletionDate -PlanningArea,data=train)
plot(classification_train1)
text(classification_train1,pretty=0)
classification_test1=predict(classification_train1,test,type="class")
table(classification_test1,test$Classification)