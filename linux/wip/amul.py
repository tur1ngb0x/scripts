#!/usr/bin/env python3

# Define the data as dictionaries
products = [
    {"name": "buttermilk", "protein_per_pack": 15, "quantity": 30 * 200, "price": 750},
    {"name": "lassi_plain", "protein_per_pack": 15, "quantity": 27 * 200, "price": 675},
    {"name": "lassi_rose", "protein_per_pack": 15, "quantity": 30 * 200, "price": 750},
    {"name": "milk", "protein_per_pack": 35, "quantity": 8 * 250, "price": 792},
    {"name": "paneer_2", "protein_per_pack": 51.25, "quantity": 2 * 205, "price": 300},
    {"name": "paneer_30", "protein_per_pack": 51.25, "quantity": 24 * 205, "price": 3600},
    {"name": "shake", "protein_per_pack": 20, "quantity": 30 * 200, "price": 1500},
    {"name": "whey_30", "protein_per_100g": 78, "quantity": 30 * 32, "price": 2000},
    {"name": "whey_60", "protein_per_100g": 78, "quantity": 60 * 32, "price": 3500},
    {"name": "whey_choco", "protein_per_100g": 74, "quantity": 30 * 34, "price": 2299}
]

def calculate_protein_per_inr(products):
    results = []
    for product in products:
        # Calculate total protein content
        if 'protein_per_100g' in product:
            total_protein = product['quantity'] * product['protein_per_100g'] / 100
        else:
            total_protein = product['quantity'] * product['protein_per_pack']

        protein_per_inr = total_protein / product['price']

        results.append((product['name'], protein_per_inr))

    return results

# Calculate protein per INR for each product
results = calculate_protein_per_inr(products)

# Print the results
for name, protein_per_inr in results:
    print(f"{name}: {protein_per_inr:.2f} g/INR")
