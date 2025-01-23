#!/usr/bin/env python3

import sys
from typing import Tuple

# Constants
CURRENCY = 'INR'
DAYS_MONTH = 30
DAYS_WEEK = 7
SEPARATOR_LENGTH = 128

# Item data structure
class Item:
    def __init__(self, name: str, price: float, quantity: float, serving: float, unit: str):
        self.name = name
        self.price = price
        self.quantity = quantity
        self.serving = serving
        self.unit = unit
        self.daily_cost, self.weekly_cost, self.monthly_cost = calculate_cost(price, quantity, serving)

def print_separator():
    print(f"{'-' * SEPARATOR_LENGTH}")

def calculate_cost(total_price: float, total_quantity: float, serving_size: float, days: int = DAYS_WEEK) -> Tuple[float, float, float]:
    try:
        if total_price <= 0 or total_quantity <= 0 or serving_size <= 0:
            raise ValueError("total_price, total_quantity, and serving_size must all be greater than zero.")
        daily_cost = (total_price / total_quantity) * serving_size
        weekly_cost = daily_cost * days
        monthly_cost = daily_cost * DAYS_MONTH
        return daily_cost, weekly_cost, monthly_cost
    except ValueError as e:
        print(f"Error: {e}")
        print("Action: Exiting...")
        sys.exit(1)

# Create items
items = [
    Item('Chicken Breast', 320, 1000, 250, 'gm'),
    Item('Whey Concentrate', 5880, 4000, 35, 'gm'),
    Item('Magnesium Glycinate', 749, 120, 1, 'unit(s)'),
    Item('Omega3 Fish Oil', 1829, 240, 2, 'unit(s)'),
    Item('Vitamin D3', 67, 4, 1/7, 'unit(s)'),
    Item('Vitamin B Complex', 52, 20, 1, 'unit(s)'),
    Item('Whole Eggs', 200, 30, 3, 'unit(s)')
]

# Calculate totals
total_daily_cost = sum(item.daily_cost for item in items)
total_weekly_cost = total_daily_cost * DAYS_WEEK
total_monthly_cost = total_daily_cost * DAYS_MONTH

# Print results
# print(f"{'Total':<20}{' ':>37}{CURRENCY} {total_daily_cost:>11.2f}{CURRENCY} {total_weekly_cost:>11.2f}{CURRENCY} {total_monthly_cost:>11.2f}")

print(f"Daily Cost: {CURRENCY} {total_daily_cost:.2f}")
print(f"Weekly Cost: {CURRENCY} {total_weekly_cost:.2f}")
print(f"Monthly Cost: {CURRENCY} {total_monthly_cost:.2f}")
