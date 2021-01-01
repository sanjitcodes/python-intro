import pandas as pd
import pandas_datareader as web
import numpy as np
import matplotlib.pyplot as plt
aapl = web.get_data_yahoo("AAPL", start="2020-10-12", end="2020-12-31")

print(aapl.head())

aapl["Adj Close"].plot()
plt.xlabel("Date")
plt.ylabel("Adjusted Price")
plt.title("Apple price data")
plt.show()
