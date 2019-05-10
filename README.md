# Stock-Chart-Plotter
This is a test of sharing a program to plot a handful of technical indicators for select stocks as well as investigate 
the usefulness of a Neural Network

There are a handful of important details in order for the program to run correctly 

Aside from setting the right file directory and such, the main file you will be running is titled "DataCollector_Plotter.m"
Currently, the file only reads in the "Industry_Lists" for future useability or comparison to some plots if desired,
and this Index Data section may be commented out

Setting the dates for the script to run is a very important step, the 'enddate' variable is a string value of the latest date
you wish to collect data fom
for reasons below, you may want to select days a handful of days removed from the current business day. 

the 'startdate', in a similar fashion is the first date you wish to collect data from 

the 'his_stock_data' is a function being shared on MathWorks, and scrapes data from input string stocks that are historically 
available on Yahoo and Google stock tracking websites

much of the script is currently written to be ran in loop form for multitple stock inputs, but is currently static 
for while using the Neural Network

"Will write a specific file of data collected" section is designated for creating an xcel file with the values collected by 
the collection function

the "daystoplot" variable is important to chose the number of days you are looking to plot values for 

the "Data Assignment" section splits the structure of the imported data into matricies of the input including the following values

    1. Date
    2. Market Open Price
    3. Daily Max Price
    4. Daily Low Price
    5. Adjusted Close Price
    6. Volume of Stock

Neural Network Section

This section is where any sort of automation for multiple stock choices is where work is needed, 
currently a .mat file needs to be loaded that contains a handful of variables, including 
the trained nerual network itself.

For this network a Nonlinear Autoregressive (NAR) series was used, to predict a  series y(t) given d past values of y(t)
The input of this network would end up being a 10x800 matrix representing 5 variables for 2 stocks, and 800 timesteps, 
starting january 2nd 2016.

    1.Open price stock 1
    2.High price stock 1
    3.Low price stock 1
    4.Close price stock 1
    5.Volume stock 1
    6.Open price stock 2
    7.High price stock 2
    8.Low price stock 2
    9.Close price stock 2
    10.Volume stock price 2
    
A Bayesian Regularization Model (BR) is used for training, and takes only a couple of minutes to be completed
- A Scaled Conjugate Gradient model was investigated, because it is able to handle much larger inputs, up to hundreds of stock variables
- At this time the R Value of these training model was inferior to the BR method 

At this time a correction factor of 10,000 is being applied to the input price numbers to the stock, I believe that 
the model is not valuing the change in stock prices due to their insignificant change compared to volume fluctuation, 
this correction factor is reversed at the output of the model to obtain a true magnitude stock price guess

Because this is a time series function, guesses are used in future guesses of the model, and that can obviously result
in gross error, for this reason i'm investigating using some simple indicators and averages to remove noise from the NN guesses

A figure is created for simple comparison at this time, and consists of the vector of stock price one (VNET) 
for 36 days before 05/01/2019 (May 1st) as well as the output of the Nural Network for 5 following days (red circles)

The Last Volume and Plotting sections are using the "daystoplot" variable as well as the finance toolbox to calculate and 
plot the following indicators 

     1. Candlestick Stock Charts
     2. Bollinger Bands
     3. 20 day moving average
     4. 50 day moving average
     5. MACD Indicator Line
     6. RSI indicator
     
These charts are organized in a similar matter to an online platform I currently use, StockCharts.com

    

