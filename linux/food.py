#!/usr/bin/env python3

# d_var = daily cost of the item
# m_var = monthly cost of the item
# p_var = total cost of the item
# q_var = total quantity of the item
# s_var = daily serving size of the item
# t_var = name of the item
# u_var = unit of measurement of the item
# w_var = weekly cost of the item

CURRENCY = '₹'
DAYS_MONTH = 30
DAYS_WEEK = 7
LINE_LENGTH = 128
LINE_CHAR = '-'

def print_line():
	print(f"{LINE_CHAR * LINE_LENGTH}")

def calculate_cost(total_price, total_quantity, serving_size, days=DAYS_WEEK):
	# if total_price == 0 or total_quantity == 0 or serving_size == 0:
	# 	print("Error: total_price, total_quantity, and serving_size must all be greater than zero.")
	# 	print("Action: Exiting...")
	# 	exit()
	daily_cost = (total_price / total_quantity) * serving_size
	weekly_cost = daily_cost * days
	monthly_cost = daily_cost * DAYS_MONTH
	return daily_cost, weekly_cost, monthly_cost

# chicken breast
t_chicken = 'Chicken Breast'
p_chicken = 320
q_chicken = 1000
s_chicken = 250
u_chicken = 'gm'
d_chicken, w_chicken, m_chicken = calculate_cost(p_chicken, q_chicken, s_chicken)

# whey protein
t_whey = 'Whey Concentrate'
p_whey = 5880
q_whey = 4000
s_whey = 35
u_whey = 'gm'
d_whey, w_whey, m_whey = calculate_cost(p_whey, q_whey, s_whey)

# magnesium
t_magnesium = 'Magnesium Glycinate'
p_magnesium = 749
q_magnesium = 120
s_magnesium = 1
u_magnesium = 'unit(s)'
d_magnesium, w_magnesium, m_magnesium = calculate_cost(p_magnesium, q_magnesium, s_magnesium)

# omega
t_omega = 'Omega3 Fish Oil'
p_omega = 1829
q_omega = 240
s_omega = 2
u_omega = 'unit(s)'
d_omega, w_omega, m_omega = calculate_cost(p_omega, q_omega, s_omega)

# vitamin d
t_vitd = 'Vitamin D3'
p_vitd = 67
q_vitd = 4
s_vitd = (1 / 7)
u_vitd = 'unit(s)'
d_vitd, w_vitd, m_vitd = calculate_cost(p_vitd, q_vitd, s_vitd)

# vitamin b
t_vitb = 'Vitamin B Complex'
p_vitb = 52
q_vitb = 20
s_vitb = 1
u_vitb = 'unit(s)'
d_vitb, w_vitb, m_vitb = calculate_cost(p_vitb, q_vitb, s_vitb)

# egg
t_egg = 'Whole Eggs'
p_egg = 200
q_egg = 30
s_egg = 3
u_egg = 'unit(s)'
d_egg, w_egg, m_egg = calculate_cost(p_egg, q_egg, s_egg)

total_daily_cost = \
	d_chicken + \
	d_egg + \
	d_magnesium + \
	d_omega + \
	d_vitb + \
	d_vitd + \
	d_whey

total_weekly_cost = total_daily_cost * DAYS_WEEK

total_monthly_cost = total_daily_cost * DAYS_MONTH

# print_line()
# print(f"Item\t\t\tCost\t\tQuantity\tServing\t\tDaily\t\tWeekly\t\tMonthly")
# print_line()
# print(f"{t_chicken}\t\t{CURRENCY} {p_chicken:.0f}\t\t{q_chicken:.0f} {u_chicken} \t{s_chicken:.0f} {u_chicken}\t\t{CURRENCY} {d_chicken:.2f}\t{CURRENCY} {w_chicken:.2f}\t{CURRENCY} {m_chicken:.2f}")
# print(f"{t_whey}\t{CURRENCY} {p_whey:.0f}\t{q_whey:.0f} {u_whey}\t\t{s_whey:.0f} {u_whey}\t\t{CURRENCY} {d_whey:.2f}\t{CURRENCY} {w_whey:.2f}\t{CURRENCY} {m_whey:.2f}")
# print(f"{t_egg}\t\t{CURRENCY} {p_egg:.0f}\t\t{q_egg:.0f} {u_egg}\t{s_egg:.0f} {u_egg}\t{CURRENCY} {d_egg:.2f}\t{CURRENCY} {w_egg:.2f}\t{CURRENCY} {m_egg:.2f}")
# print(f"{t_omega}\t\t{CURRENCY} {p_omega:.0f}\t{q_omega:.0f} {u_omega}\t{s_omega:.0f} {u_omega}\t{CURRENCY} {d_omega:.2f}\t{CURRENCY} {w_omega:.2f}\t{CURRENCY} {m_omega:.2f}")
# print(f"{t_magnesium}\t{CURRENCY} {p_magnesium:.0f}\t\t{q_magnesium:.0f} {u_magnesium}\t{s_magnesium:.0f} {u_magnesium}\t{CURRENCY} {d_magnesium:.2f}\t{CURRENCY} {w_magnesium:.2f}\t{CURRENCY} {m_magnesium:.2f}")
# print(f"{t_vitb}\t{CURRENCY} {p_vitb:.0f}\t\t{q_vitb:.0f} {u_vitb}\t{s_vitb:.0f} {u_vitb}\t{CURRENCY} {d_vitb:.2f}\t{CURRENCY} {w_vitb:.2f}\t{CURRENCY} {m_vitb:.2f}")
# print(f"{t_vitd}\t\t{CURRENCY} {p_vitd:.0f}\t\t{q_vitd:.0f} {u_vitd}\t{s_vitd:.2f} {u_vitd}\t{CURRENCY} {d_vitd:.2f}\t{CURRENCY} {w_vitd:.2f}\t{CURRENCY} {m_vitd:.2f}")
# print_line()
# print(f"Total\t\t\t\t\t\t\t\t\t{CURRENCY} {total_daily_cost:.2f}\t{CURRENCY} {total_weekly_cost:.2f}\t{CURRENCY} {total_monthly_cost:.2f}")
# print_line()

print(f"Daily Cost\t{CURRENCY} {total_daily_cost:.2f}\nWeekly Cost\t{CURRENCY} {total_weekly_cost:.2f}\nMonthly Cost\t{CURRENCY} {total_monthly_cost:.2f}")
