#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: Percentage should be greater than 0 and add up to 100."
    exit 1
}

# Prompt the user for total calories
read -rp "Total Calories : " TotalC

# Validate the total calories input: check if it is a number and positive
if ! [[ "$TotalC" =~ ^[0-9]+$ ]] || (( TotalC <= 0 )); then
    echo "Total calories must greater than 0."
    exit 1
fi

# Prompt the user for percentages
read -rp "Carb %: " CarbP
read -rp "Protein %: " ProteinP
read -rp "Fat %: " FatP

# Validate the inputs: check if they are numbers and within the range of 0-100
for arg in "$CarbP" "$ProteinP" "$FatP"; do
    if ! [[ "$arg" =~ ^[0-9]+(\.[0-9]+)?$ ]] || (( $(echo "$arg < 0" | bc -l) )) || (( $(echo "$arg > 100" | bc -l) )); then
        usage
    fi
done

# Check if the percentages sum up to 100
total_percentage=$(echo "$CarbP + $ProteinP + $FatP" | bc)
if (( $(echo "$total_percentage != 100" | bc -l) )); then
    usage
fi

# Calculate calories for each macronutrient
CarbC=$(echo "$TotalC * $CarbP / 100" | bc)
ProteinC=$(echo "$TotalC * $ProteinP / 100" | bc)
FatC=$(echo "$TotalC * $FatP / 100" | bc)

# Calculate weight for each macronutrient (1 gram of carbohydrate = 4 calories, 1 gram of protein = 4 calories, 1 gram of fat = 9 calories)
CarbW=$(echo "$CarbC / 4" | bc)
ProteinW=$(echo "$ProteinC / 4" | bc)
weight_of_fats=$(echo "$FatC / 9" | bc)

# Prompt the user for the number of meals
read -rp "Number of meals (1-10): " num_meals

# Validate the number of meals
if ! [[ "$num_meals" =~ ^[1-9]$ ]] && [ "$num_meals" -ne 10 ]; then
    echo "Number of meals must be an integer between 1 and 10."
    exit 1
fi

# Calculate per meal values
CarbW_PM=$(echo "$CarbW / $num_meals" | bc)
ProteinW_PM=$(echo "$ProteinW / $num_meals" | bc)
FatW_PM=$(echo "$weight_of_fats / $num_meals" | bc)

CarbC_PM=$(echo "$CarbC / $num_meals" | bc)
ProteinC_PM=$(echo "$ProteinC / $num_meals" | bc)
FatC_PM=$(echo "$FatC / $num_meals" | bc)

# Output the results
echo ""
(

    echo "Total Weight(g) Calories(kcal) Ratio(%) "
    echo "Carb ${CarbW} ${CarbC} $CarbP"
    echo "Protein ${ProteinW} ${ProteinC} $ProteinP"
    echo "Fat ${weight_of_fats} ${FatC}  $FatP "
) | column -t
echo ""
# Output per meal results
(
	echo "Per-Meal Weight(g) Calories(kcal) Ratio(%) "
    echo "Carb $CarbW_PM $CarbC_PM $CarbP"
	echo "Protein $ProteinW_PM $ProteinC_PM $ProteinP"
	echo "Fat $FatW_PM $FatC_PM $FatP"
) | column -t
echo ""
