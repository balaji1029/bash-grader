import sys
import numpy as np
import pandas as pd
import os
import matplotlib.pyplot as plt

usage = "Usage: "

csv_file = "./main.csv"
if not os.path.exists(csv_file):
    # print("main.csv exists")
    print("Combine the csv files first...")
    sys.exit(1)

if len(sys.argv) == 1:
    df = pd.read_csv('./main.csv')
    # df = np.loadtxt(csv_file, delimiter=',')
    # if 'total' not in df.columns:
    #     print("Total the csv files first...")
    #     sys.exit(1)
    # totals = np.array(df['total'])
    # print(df)
    # print(df['total'])
    totals = np.array(df['total'])
    print("Total number of samples: ", len(totals))
    print("Mean: ", np.mean(totals))
    print("Standard deviation: ", np.std(totals))
    print("Minimum: ", np.min(totals))
    print("Maximum: ", np.max(totals))
    print("Median: ", np.median(totals))
    print("25th percentile: ", np.percentile(totals, 25))
    print("75th percentile: ", np.percentile(totals, 75))
    print("95th percentile: ", np.percentile(totals, 95))
    print("99th percentile: ", np.percentile(totals, 99))
    print("99.9th percentile: ", np.percentile(totals, 99.9))
    print("99.99th percentile: ", np.percentile(totals, 99.99))
    print("99.999th percentile: ", np.percentile(totals, 99.999))