import pandas as pd
import numpy as np
from sklearn.preprocessing import MinMaxScaler
from keras.models import Sequential
from keras.layers import Dense, Dropout, LSTM

# Load the stock data into DataFrames
df_aapl = pd.read_csv('ABB.csv')
df_amzn = pd.read_csv('AMZN.csv')
df_googl = pd.read_csv('GOOG.csv')
df_msft = pd.read_csv('MSFT.csv')
df_nflx = pd.read_csv('BHP.csv')

# Select the features to use for prediction
features = ['Open', 'High', 'Low', 'Close', 'Volume']

# Normalize the data
scaler_aapl = MinMaxScaler(feature_range=(0, 1))
scaler_amzn = MinMaxScaler(feature_range=(0, 1))
scaler_googl = MinMaxScaler(feature_range=(0, 1))
scaler_msft = MinMaxScaler(feature_range=(0, 1))
scaler_nflx = MinMaxScaler(feature_range=(0, 1))

df_aapl[features] = scaler_aapl.fit_transform(df_aapl[features])
df_amzn[features] = scaler_amzn.fit_transform(df_amzn[features])
df_googl[features] = scaler_googl.fit_transform(df_googl[features])
df_msft[features] = scaler_msft.fit_transform(df_msft[features])
df_nflx[features] = scaler_nflx.fit_transform(df_nflx[features])

# Split the data into training and testing sets
train_size = int(len(df_aapl) * 0.8)
test_size = len(df_aapl) - train_size
train_data_aapl = df_aapl[:train_size]
test_data_aapl = df_aapl[train_size:]
train_data_amzn = df_amzn[:train_size]
test_data_amzn = df_amzn[train_size:]
train_data_googl = df_googl[:train_size]
test_data_googl = df_googl[train_size:]
train_data_msft = df_msft[:train_size]
test_data_msft = df_msft[train_size:]
train_data_nflx = df_nflx[:train_size]
test_data_nflx = df_nflx[train_size:]

# Define the neural network architecture
model = Sequential()
model.add(Dense(64, input_dim=len(features), activation='relu'))
model.add(Dense(32, activation='relu'))
model.add(Dense(1, activation='linear'))

#Compile the model

model.compile(loss='mean_squared_error', optimizer='adam')

#Define a function to prepare the data for training
def prepare_data(data):
    X = []
    Y = []
    for i in range(len(data) - 1):
        print("I GOT HEREEEEEEEEEEEEEE")
        X.concatenate(data[i:i+1][features].values[0])
        Y.concatenate(data[i+1:i+2]['Close'].values[0])
        X = np.array(X)
        Y = np.array(Y)
    return X, Y

#Prepare the data for training
train_X_aapl, train_Y_aapl = prepare_data(train_data_aapl)
test_X_aapl, test_Y_aapl = prepare_data(test_data_aapl)
train_X_amzn, train_Y_amzn = prepare_data(train_data_amzn)
test_X_amzn, test_Y_amzn = prepare_data(test_data_amzn)
train_X_googl, train_Y_googl = prepare_data(train_data_googl)
test_X_googl, test_Y_googl = prepare_data(test_data_googl)
train_X_msft, train_Y_msft = prepare_data(train_data_msft)
test_X_msft, test_Y_msft = prepare_data(test_data_msft)
train_X_nflx, train_Y_nflx = prepare_data(train_data_nflx)
test_X_nflx, test_Y_nflx = prepare_data(test_data_nflx)

#Train the model
model.fit(train_X_aapl, train_Y_aapl, epochs=50, batch_size=32, validation_data=(test_X_aapl, test_Y_aapl), verbose=2)
model.fit(train_X_amzn, train_Y_amzn, epochs=50, batch_size=32, validation_data=(test_X_amzn, test_Y_amzn), verbose=2)
model.fit(train_X_googl, train_Y_googl, epochs=50, batch_size=32, validation_data=(test_X_googl, test_Y_googl), verbose=2)
model.fit(train_X_msft, train_Y_msft, epochs=50, batch_size=32, validation_data=(test_X_msft, test_Y_msft), verbose=2)
model.fit(train_X_nflx, train_Y_nflx, epochs=50, batch_size=32, validation_data=(test_X_nflx, test_Y_nflx), verbose=2)