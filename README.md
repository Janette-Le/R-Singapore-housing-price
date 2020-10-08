# R - Condominium prices in Singapore

**:black_nib: [Codes file](https://github.com/Janette-Le/R-Singapore-housing-price/blob/main/Codes.R)**<br>
**:page_with_curl: [Report](https://github.com/Janette-Le/R-Singapore-housing-price/blob/main/Report.pdf)**

<p align="justify">This project aims to provide insights and outcomes by analyzing using past data of private residential units, specifically condominiums in Singapore. The factors that affect customer's willingness to buy include the area of the flats, whether it’s a resale or new sale, leasehold of the flat, completion year, et cetera.<br>  Developers can use these insights to make pricing decisions for both resale and new flats from observing the willingness to pay of buyers based on historical data.</p>

## Project sections:

1. [Project topic](#R---condominium-prices-in-singapore)
2. [Data](#prelimitary-exploration-analysis)
   - Data cleansing
   - Data visualization
3. [Multiple linear regression](#multiple-linear-regression)
   - Building model
   - Step backward method
   - LASSO
   - PCR (Principle Components Regression)
4. [Classification Tree](#classification-tree)
5. [Conclusion](#conclusion)

# Data
## Data cleansing

**Adding Class based on transacted price**<br>
Range of transacted price was applied for classifiers involving class determination. The 25th percentile and 75th percentile of transacted price are used to segment transacted price into Low, Mid and High classes respectively. For condominiums with transacted price at most S$996,000, these condominiums are classified as the **Low class**. For condominiums with transacted price at least S$1,780,000, these condominiums are classified as the **High class**. For condominiums with transacted price between S$996,000 and S$1,780,00, these condominiums are classified as the **Mid class**.

**Precluded Data**<br>
Due to the limitations imposed by R software in which only a maximum of 32 categories can be processed, 5 categories are removed from the planning area. These planning areas are Downtown Core, Mandai, Museum, Orchard and Outram. They are chosen due to the minimal condominium sale data in these areas.

**NA and Outliers values**<br>
The original dataset included 8525 rows. After checking some statistics index and sknewness as well as the distribution of each variables, I removed 89 rows, and had a data with 8436 observation to work on it.

**Variables to be modified**<br>
There are various existing categorical variables that needs to be modified before the model can be constructed, as they could not be measured on a quantitative scale. While handing the data set, Tenure was considered as complex character string. Getting rid of the unused information in each cells, this column turned to be category variables with 7 options.


## Data visualization

# Multiple linear regression
<p align="justify">
  
  Regression analysis allows understanding of how the world operates and allows making of predictions. To obtain improved fit to the data, several explanatory variables could be used in the regression equation, and being known as multiple regression. The regression equation is still estimated by the least squares method.<br>
For building multiple regression model, I use different methods, specifically, by hand, by using <code>stepIC()</code> backwards, by sing LASSO method and PCR (Principle Components Regression) to built the models; then fitting them one by one into the test dataset.<br> 
After that, comparing the predict accuracy of these model together to chose which on is the best models to predict dependent variable. The predictor variable in this case is Unit Price ($psm).</p>

**Multiple regression**

![image_2](/images/2.PNG)

**With Step backward** Based on Step backward result, the model contains 3 most significant variable named: Area, Transacted Price, Tenure, Completion Date, Type of Sale, Purchaser Address Indicator, Postal Code and Planning Region

**LASSO:** I choose the best lambda i.e. first lambda.min where minimum error observed is 143.9336

**PCR (Principle Components Regression):** Use the validationplot() function either set to RMSEP, MSEP, and/or R2 to determine how many principle components should be used in the final model. In the case, it looks like 4 components are enough to explain more than 90% of the variability in the data.
  
**Prediction accuracy:** After using different methods to create 4 models and assessing model performance by calculating measures of prediction accuracy, I will choose models which has smallest RSS, MAE, RMSE and largest R2. Table below summarizes these measures of 4 models, and can be witnessed clearly from it, Lasso is the best model for predicting.
  
  | Models | R squared | RSS | MAE | RMSE |
  |--------|-----------|-----|-----|------|
  | Multiple regression | 0.8645 | 679 | 1134 | 1795 |
  | Step backward | 0.895 | 526 | 1580 | 1075 |
  | LASSO | 0.897 | 553 | 1044 | 942 |
  | PCR | 0.885 | 646 | 1100 | 1263 |
  
# Classification Tree
<p align="justify">Classification Trees are one of the commonly used decision trees for predictive modeling. It predicts a categorical target variable and is often binary. Every single branch node represents a single variable and a split point of the variable, and the selected variable is able to generate the highest node purity. The leaf nodes contain the training data from which the most commonly occurring class is used to predict the class of the testing data. It is simple to understand and can be used to be presented to managers who are not familiar with other complex predictive model.<br>
The variables actually used in the classification tree are:<br>
  - Sale month & year<br>
  - Tenure<br>
  - Type of Sale (new sale, resale, or sub-sale)<br>
  - Type of Purchaser (based on purchaser address)<br>
  - Planning Region<br>
  - Planning Area* (additional data processing, see note below)<br>
  </p>

# Conclusion
<p align="justify">A comparison may not be most appropriate in this case as one analysis is a regression and another one is a classification. Thus, an area of further investigation will be to deploy a regression tree, a form of a decision tree that will be more aligned in terms of comparison to the multiple regression method. Also, I can explore other external variables that are not currently in the dataset that determine the housing price, such as distance to public transport amenities (bus interchange, subway), or the reputation of the developer of the estate.</p>
