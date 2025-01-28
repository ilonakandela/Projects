# Comprehensive Sales Review with SQL

### Project Description
In this SQL-based project, I conducted an analysis of sales data for a retail business, focusing on product and brand performance across various categories and regions. Using SQL, I built a series of queries to analyze trends in sales, revenue, and profitability, including monthly comparisons, year-on-year changes, and performance by country and category. By applying advanced SQL functions like window functions and grouping, I identified high-performing products, revenue growth areas, and profit margins for different product categories. This project helped uncover valuable insights into customer behavior, sales dynamics, and business performance, all through SQL analysis.

### Tools
- SQL (SSMS)
- Data Normalization
- Aggregate Functions: SUM(), COUNT(), ROUND()
- Window Functions: ROW_NUMBER(), LAG(), and SUM() OVER()
- CASE Statements
- Joins
- Grouping and Partitioning
- Date Functions
- Filtering
- Ordering

### Key Questions and Insights
#### Data Normalization
The initial dataset was stored in a single file and included information about orders, transactions, products, customers, countries, and stores. The data was normalized to ensure consistency and avoid redundancy, and a snowflake schema was created to optimize data structure and facilitate efficient querying. The normalization process helped in organizing the data into different related tables, such as stores, products, and transactions, allowing for more flexible and scalable data analysis.
![Diagram](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/DB%20diagram.png)

#### What is the range of order dates?
![Q1](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/Q1.png) <br>
The range of order dates spans from January 1, 2016 to February 20, 2021.

#### Which products had the lowest profit margins in 2020, and how do their revenues and costs compare?
![Q2](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/Q2.png) <br>
The lowest profit margin is 33%.

#### What is the total profit for each product category in the years 2016-2020, and how has it evolved over time?
![Q3](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/Q3.png) <br>
The most notable trend is that 2020 generally saw a decline in profits for many categories, which may have been due to external market conditions (such as the pandemic). However, some categories like Home Appliances and Music, Movies, and Audio Books still maintained positive profit figures.

#### What is the comparison of the monthly number of orders between 2019 and 2020?
![Q4](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/Q4.png) <br>
The data shows a significant decline in the number of orders from 2019 to 2020, especially from March to December, with the largest drop occurring in December (2967 orders in 2019 compared to 761 in 2020). This decline is particularly evident in the months of March, April, and May, which could be linked to external factors like the impact of the COVID-19 pandemic. The decrease in 2020 orders suggests a shift in consumer behavior or market conditions. The seasonal trend observed in 2019, with a peak in December, was not replicated in 2020.

#### What is the distribution of profit per square meter for physical stores during 2020?
![Q5](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/Q5.png) <br>
The highest profit per square meter is 278, recorded by a store in Germany, while the lowest is 17, observed in a store in Australia. 

#### What are the most frequently purchased product pairs?
![Q6](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/Q6.png) <br>
The most frequently purchased product pair, consisting of product 1648 and product 1699, has been bought together 5 times.

#### What is the cumulative revenue percentage for each brand, and how does it contribute to the overall total revenue for the year 2020?
![Q7](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/Q7.png) <br>
The analysis shows that Adventure Works was the top contributor in 2020, with a revenue of 1,936,075, making up a significant portion of the total sales. As we move down the list, brands like Wide World Importers, Contoso, and Fabrikam also made strong contributions, but their share decreased compared to Adventure Works, reaching around 68% to 79% of the total revenue. The smaller brands, like Litware, Tailspin Toys, and Northwind Traders, added less to the total, with Northwind Traders contributing just 1% of the total revenue. This indicates that most of the revenue came from a few key brands, with the rest contributing smaller amounts.

#### What is the total number of customers who made only one order and the number of customers who made more than one order during the given period?
![Q8](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/Q8.png) <br>
Approximately 55% of customers make more than one purchase, indicating that over half of the customers return for additional orders, which suggests a relatively high level of customer retention.

#### What is the monthly sales change percentage for online store after 2019, compared to the previous month?
![Q9](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/Q9.png) <br>
In 2020, online sales showed significant fluctuations, with several months experiencing large decreases in sales compared to the previous month. For example, in March 2020, there was a 58.54% drop in sales, followed by a rebound in May, where sales increased by 275.62%. Despite some recovery, there were still substantial declines, such as in July (-21.72%) and October (-35.44%). However, towards the end of the year, there was a sharp increase in December with a 172.29% rise. The trend continued into early 2021 with a decrease in January and a slight increase in February.

#### What are the top three most popular product categories in each country based on the total sales in 2020?
![Q10](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/Q10.png) <br>
The most popular product categories in each country for 2020 are dominated by "Computers" and "Cell phones," with "Games and Toys" and "Music, Movies and Audio Books" appearing as the third most popular category in several countries. The United States leads in sales, particularly in Computers and Cell phones, followed by strong performances in countries like the United Kingdom and Germany, where similar trends are observed.

#### What is the top-performing brand in terms of revenue for each product category from 2020 onwards?
![Q11](https://github.com/ilonakandela/projects/blob/main/Comprehensive%20Sales%20Review%20with%20SQL/img/Q11.png)
In 2020, the top brands by revenue in each product category were as follows: Adventure Works topped the Computers category with $1,461,096, while The Phone Company led the Cell phones category with $1,233,435. Fabrikam was the top brand for Cameras and camcorders with $855,244, and Adventure Works also led in TV and Video with $665,902. Other top brands included Contoso in Home Appliances ($624,570), Wide World Importers in Audio ($346,489), Southridge Video in Music, Movies and Audio Books ($317,570), and Tailspin Toys in Games and Toys ($158,425).
