#!/bin/bash

# Check if 3 arguments are provided
if [ $# -eq 3 ]; then
    age="${1}"
    height="${2}"
    weight="${3}"
else
    # Prompt user input interactively
    read -rp "Enter your age in years: " age
    read -rp "Enter your height in centimeters: " height
    read -rp "Enter your weight in kilograms: " weight
fi

# Define activity levels and multipliers
activity_levels=("sedentary" "low" "moderate" "high" "extreme")
multipliers=(1.2 1.375 1.55 1.725 1.9)

# Calculate BMR for male and female
bmr_male=$(printf "%.2f" "$(echo "10*${weight} + 6.25*${height} - 5*${age} + 5" | bc -l)")
bmr_female=$(printf "%.2f" "$(echo "10*${weight} + 6.25*${height} - 5*${age} - 161" | bc -l)")

# Collect output in a variable
output=""

# Add male BMR and TDEE results
output+=$"male - bmr - none - ${bmr_male}\n"
for i in "${!activity_levels[@]}"; do
    level=${activity_levels[$i]}
    multiplier=${multipliers[$i]}
    tdee_male=$(printf "%.2f" "$(echo "${bmr_male} * ${multiplier}" | bc -l)")
    output+=$"male - tdee - $level - ${tdee_male}\n"
done

# Add female BMR and TDEE results
output+=$"female - bmr - none - ${bmr_female}\n"
for i in "${!activity_levels[@]}"; do
    level=${activity_levels[$i]}
    multiplier=${multipliers[$i]}
    tdee_female=$(printf "%.2f" "$(echo "${bmr_female} * ${multiplier}" | bc -l)")
    output+=$"female - tdee - $level - ${tdee_female}\n"
done

# Print formatted output using two-space delimiter
echo -e "${output}" | column -t -s "-"
