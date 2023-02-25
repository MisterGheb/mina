import os
import pandas as pd

# Set the path to the directory containing your CSV files
directory = "/workspace/tu-feb-2023--mina-ad-mina/src/Deep_Learning/price"

# Use os.walk to get a list of all CSV files in the directory and its subdirectories
csv_files = []
for root, directories, files in os.walk(directory):
    for file in files:
        if file.endswith(".csv"):
            csv_files.append(os.path.join(root, file))

# Loop through each CSV file and clean the data
for csv_file in csv_files:
    # Load the CSV file into a pandas DataFrame
    df = pd.read_csv(csv_file)

    # Drop any rows with missing values
    df.dropna(inplace=True)

    # Remove any leading or trailing spaces from column names
    df.columns = df.columns.str.strip()

    # Convert any string columns to numeric columns
    for col in df.columns:
        if df[col].dtype == 'object':
            df[col] = pd.to_numeric(df[col], errors='coerce')

    # Save the cleaned data back to the CSV file
    df.to_csv(csv_file, index=False)

print("Data cleaning complete!")
