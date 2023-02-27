import numpy as np
import matplotlib.pyplot as plt
plt.style.use('fivethirtyeight')
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from keras.models import Sequential
from keras.layers import Dense, LSTM, Dropout, GRU, Bidirectional
from keras.optimizers import SGD
import math
from sklearn.metrics import mean_squared_error

directory = "/workspace/tu-feb-2023--mina-ad-mina/src/Deep_Learning/Milestone 2/ABB.csv"
dataset = pd.read_csv(directory, index_col='Date', parse_dates=['Date'])
dataset.head()

def plot_predictions(test,predicted):
    plt.plot(test, color='red',label='Real ABB Stock Price')
    plt.plot(predicted, color='blue',label='Predicted ABB Stock Price')
    plt.title('ABB Stock Price Prediction')
    plt.xlabel('Time')
    plt.ylabel('ABB Stock Price')
    plt.legend()
    plt.show()

def return_rmse(test,predicted):
    rmse = math.sqrt(mean_squared_error(test, predicted))
    print("The root mean squared error is {}.".format(rmse))


