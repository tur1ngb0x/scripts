#!/usr/bin/env python3

# Input data as a list of dictionaries
data = [
    {"BrandName": "A", "TotalWeight (grams)": 1000, "TotalCost (INR)": 3000, "ProteinRatio (%)": 75},
    {"BrandName": "B", "TotalWeight (grams)": 2270, "TotalCost (INR)": 6434, "ProteinRatio (%)": 80},
]

# Calculate ProteinPerINR for each entry and add it to the dictionary
for item in data:
    total_weight = item["TotalWeight (grams)"]
    protein_ratio = item["ProteinRatio (%)"]
    total_cost = item["TotalCost (INR)"]

    protein_per_inr = (total_weight * protein_ratio) / total_cost
    item["ProteinPerINR"] = round(protein_per_inr, 2)

# Define the column headers
headers = ["BrandName", "TotalWeight (grams)", "TotalCost (INR)", "ProteinRatio (%)", "ProteinPerINR"]

# Print the headers
print(", ".join(headers))

# Print the data rows
for item in data:
    row = [
        item["BrandName"],
        item["TotalWeight (grams)"],
        item["TotalCost (INR)"],
        item["ProteinRatio (%)"],
        item["ProteinPerINR"],
    ]
    print(", ".join(map(str, row)))
