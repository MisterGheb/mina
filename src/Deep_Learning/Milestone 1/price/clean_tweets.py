import json
import os

# Set the path to the directory containing your folders
directory = "/workspace/tu-feb-2023--mina-ad-mina/src/Deep_Learning/price"

# Loop through each folder in the directory
for foldername in os.listdir(directory):
    folderpath = os.path.join(directory, foldername)

    # Check if the item in the directory is a folder
    if os.path.isdir(folderpath):
        # Loop through each JSON file in the folder
        for filename in os.listdir(folderpath):
            if filename.endswith(".json"):
                filepath = os.path.join(folderpath, filename)
                with open(filepath, "r") as f:
                    # Load the JSON data into a dictionary
                    data = json.load(f)

                # Drop any keys with missing values
                data = {k: v for k, v in data.items() if v is not None}

                # Save the cleaned data back to the JSON file
                with open(filepath, "w") as f:
                    json.dump(data, f)

print("Data cleaning complete!")
