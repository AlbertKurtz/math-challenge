extends Node

var operations = ["+", "-", "*", "/"]
var num1
var num2
var operation # Stores the symbol of the current math operation (e.g., "+", "-")
var operation2 # Previously used in an older version of generate_quiz_level3, currently unused.
var result # Stores the numerical result of the generated quiz question
var print_string
var min_time_allowed = 20 #seconds
var delta_time_difficulty = 5 #seconds
var time_levels = 5


func split_level(lvl):
	# Splits the overall game level (`lvl`) into two components:
	# 1. Operation Difficulty Component: Determines the complexity of numbers in math problems.
	#    Calculated as int(lvl / time_levels) + 1. Adding 1 ensures it's at least 1.
	# 2. Time Difficulty Component: Determines the time allowed for the quiz.
	#    Calculated as lvl % time_levels.
	# These components are then used by operation_difficulty() and time_difficulty() respectively.
	return [int(lvl/time_levels)+1, lvl%time_levels]

func time_difficulty (lvl_time_component): # lvl_time_component is from split_level()
	# Calculates the time allowed for a quiz based on the time difficulty component.
	# The base maximum time is implicitly (min_time_allowed + time_levels * delta_time_difficulty).
	# For each increment in lvl_time_component, the allowed time decreases by delta_time_difficulty.
	# The time is capped at min_time_allowed, ensuring it doesn't go below this value.
	# Example: if min_time_allowed=20, time_levels=5, delta_time_difficulty=5
	# Max possible time before reduction = 20 + 5*5 = 45 seconds.
	# lvl_time_component=0: time = 45s
	# lvl_time_component=1: time = 40s
	# ...
	# lvl_time_component=4: time = 25s
	# The result is clamped by max(..., min_time_allowed).
	return max(int((min_time_allowed + time_levels*delta_time_difficulty) - delta_time_difficulty*lvl_time_component), min_time_allowed)

func operation_difficulty(lvl_op_component): # lvl_op_component is from split_level()
	# Determines the range of numbers for operands based on the operation difficulty component.
	# The original comments below describe a detailed 100-level system for operand ranges.
	# However, the current implementation is simpler:
	# It uses split_digits to further break down lvl_op_component,
	# then generates two numbers, x and y, within calculated ranges.

	# Original design notes (may not be fully reflected in current simple implementation):
	# operation difficulty is in order +, -, *, /.
	#further difficulty is the number involved
	# 100 lvls
	# with x + y = N, N-y = x, x*y = N, N/x = y
	# 1) 0< x,y <10
	# 2) 0< x <10 and 0< y <20
	# 3) 0< x <10 and 0< y <30
	# 4) 0< x <10 and 0< y <40
	# ....
	# 9) 0< x < 10 and 0< y <90
	# 10) 0< x < 10 and 0< y < 100
	# 11) 0< x, y < 20
	# 12) 0< x < 20 and 0< y < 30
	# 13) 0< x < 20 and 0 < y < 40
	# 14) 0< x < 20 and 0 < y <50
	# ...
	# 99) 0< x < 100 and 0 < y < 90
	# 100) 0 < x < 100 and 0< y < 100
	
	# `split_digits` divides `lvl_op_component` into two parts.
	# e.g., if lvl_op_component is 23, lvl_split becomes [3, 2].
	var lvl_split = split_digits(lvl_op_component) 
	
	# `x_lvl` is the higher part (e.g., 2 from 23). Used for the first operand's range.
	var x_lvl = lvl_split[1] 
	# `y_lvl` is the last digit (e.g., 3 from 23). Used for the second operand's range.
	var y_lvl = lvl_split[0] 
	
	# Generate the first operand `x`. Its range is from 0 up to (x_lvl + 1) * 10 - 1.
	# Example: if x_lvl = 2, range is 0 to (2+1)*10 - 1 = 29.
	# Note: rand_int(min, max) currently returns min to max-1.
	var x = rand_int(0, (x_lvl + 1) * 10)
	
	# Generate the second operand `y`. Its range is from 0 up to y_lvl * 10 - 1.
	# Example: if y_lvl = 3, range is 0 to 3*10 - 1 = 29.
	# If y_lvl = 0, range is 0 to -1 (rand_int might handle this as 0 if min=max, or error if max < min before potential swap).
	# rand_int(0,0) should return 0 if min=max (current rand_int will fail here).
	var y = rand_int(0, y_lvl * 10) 
	
	#print("Generated operand ranges: 0 <= x < " , (x_lvl +1)*10, ";  0 <= y < ", y_lvl*10)
	return [x, y]
	
	# `pass` is unnecessary here.
	# pass 

func split_digits(number):
	# Splits a number into two parts: the last digit and the rest of the number.
	# Example: 
	#   split_digits(123) returns [3, 12] (last_digit=3, other_digits=12)
	#   split_digits(34)  returns [4, 3]
	#   split_digits(7)   returns [7, 0]
	var last_digit = 1 # Default, though typically overwritten.
	var other_digits = 0
	var str_number = str(int(number))
	if str_number.length()<2:
		last_digit = number
		other_digits = 0
	else:
		last_digit = int(str_number[-1])
		other_digits = int(str_number.left(str_number.length()-1))
	
	return [last_digit, other_digits]
	
	

func ultimate_generate_quiz(operation_lvl_component):
	# Generates a single math quiz question with one operation.
	# `operation_lvl_component` (derived from the main game level via split_level) 
	# is used by operation_difficulty() to determine the range of numbers for operands.

	# Existing comments about general difficulty concepts:
	# difficulty in a math challenge can come from different sources
	# but basically there are 2 levels of difficulty:
	# - duration of the challenge: less time forces the player to calculate faster
	# - numbers involved: the bigger the numbers the harder
	# with sum and subtraction the constraint on bigger numbers is quite linear
	# for multiplication it is harder, because when numbers are greater than 10 we 
	# already struggle to visualize the result.
	# the difficulty balance is quite hard. 
	# 
	# level can have 2 labels X and Y, with X the "time difficulty" and Y the operation
	# difficulty. (This function primarily deals with the operation difficulty part).

	# Get two numbers (operands) based on the operation difficulty level component.
	var two_numbers = operation_difficulty(operation_lvl_component)
	
	# Randomly select one of the four basic operations: +, -, *, /
	# (operations array is defined at the class level: ["+", "-", "*", "/"])
	operation = operations[randi()%4] 
	
	# Assign the two numbers from operation_difficulty to num1 and num2,
	# with a random chance to swap them for variety.
	# These (num1, num2) are class member variables, which is a bit unusual for operands
	# if this function were purely static, but seems to be the existing pattern here.
	# randomize() REMOVED (should be called once, e.g., in _ready() of the main scene)
	if randf()<0.5:
		num1 = two_numbers[0]
		num2 = two_numbers[1]	
	else:
		num1 = two_numbers[1]
		num2 = two_numbers[0]	
		
	# Perform the selected operation and prepare the question string and result.
	if operation == "+":
		# Question: num1 + num2 = ?
		result = num1 + num2
		string_to_print = str(num1) + " " + operation + " " + str(num2)
	elif operation == "-":
		# Question: A - B = ? (where A >= B)
		# The values in num1 and num2 are used to determine minuend (A) and subtrahend (B).
		var val_a = num1 # Original first number
		var val_b = num2 # Original second number
		num1 = max(val_a, val_b) # Ensure num1 (class var) becomes the minuend (larger/equal)
		num2 = min(val_a, val_b) # Ensure num2 (class var) becomes the subtrahend (smaller/equal)
		result = num1 - num2
		string_to_print = str(num1) + " " + operation + " " + str(num2)
	elif operation == "*":
		# Question: num1 * num2 = ?
		result = num1 * num2
		string_to_print = str(num1) + " " + operation + " " + str(num2)
	elif operation == "/":
		# Question: (Divisor * Quotient) / Divisor = Quotient
		# num1 (class var, from operation_difficulty) acts as the Divisor.
		# num2 (class var, from operation_difficulty) acts as the Quotient.
		
		# Ensure Divisor (num1) is not zero to prevent division by zero error.
		if num1 == 0:
			num1 = 1 # If divisor is 0, set to 1. This makes the question num2 / 1 = num2.
		
		# num2 (the quotient) can be zero.
		var dividend = num1 * num2 # Calculate the dividend for the question string.
		string_to_print = str(dividend) + " " + operation + " " + str(num1)
		result = num2 # The actual answer is the quotient.
	

	# Returns the calculated result and the question string.
	# Note: class members `result` and `string_to_print` are updated too due to assignments above.
	return [result, string_to_print]


func rand_int(min_int, max_int):
	# randomize() REMOVED (should be called once, e.g., in _ready() of the main scene)
	# Returns a random integer in the interval [min_int, max_int-1].
	# CAUTION: If min_int == max_int, (max_int - min_int) will be 0,
	# leading to a "division by zero" error with randi() % 0.
	# This case should be handled (e.g., by returning min_int if min_int == max_int)
	# or ensured by the caller that min_int < max_int.
	# The current implementation was kept due to previous tool limitations for a fix.
	return (randi() % (max_int - min_int)) + min_int

func priority(operation):
	# This function is not actively used. It was part of an older quiz generation logic.
	# Determines if an operation has higher precedence (* or /).
	return (operation =="*" or operation == "/")

func generate_quiz_level1():
	# This function is not actively used by Main_game2.gd or Main_gameTIME.gd.
	# randomize() REMOVED
	
	var string_to_print = ""
	operation = operations[randi()%4]
	var l1_val1 = randi() % (10+1) # Local temp var for 0-10
	var l1_val2 = randi() % (10+1) # Local temp var for 0-10
	
	# Assign to class members num1, num2 based on operation
	if operation == "+":
		num1 = l1_val1
		num2 = l1_val2
		result = num1 + num2
		string_to_print = str(num1) + " " + operation + " " + str(num2)
	elif operation == "-":
		# Subtraction: A - B = C, where A >= B
		num1 = max(l1_val1, l1_val2) # num1 is minuend
		num2 = min(l1_val1, l1_val2) # num2 is subtrahend
		result = num1 - num2
		string_to_print = str(num1) + " " + operation + " " + str(num2)
	elif operation == "*":
		num1 = l1_val1
		num2 = l1_val2
		result = num1 * num2
		string_to_print = str(num1) + " " + operation + " " + str(num2)
	elif operation == "/":
		# Division: (divisor * quotient) / divisor = quotient
		# l1_val1 is potential divisor, l1_val2 is potential quotient.
		num1 = l1_val1 # num1 is divisor
		num2 = l1_val2 # num2 is quotient (can be 0)
		
		if num1 == 0: # Ensure divisor (num1) is not zero.
			num1 = randi() % 10 + 1 # Regenerate divisor if 0, range 1-10
		
		var dividend = num1 * num2 # Calculate dividend for the question
		string_to_print = str(dividend) + " " + operation + " " + str(num1)
		result = num2 # The answer is the quotient
	

	return [result, string_to_print]
	
func generate_quiz_level2():
	# This function is not actively used by Main_game2.gd or Main_gameTIME.gd.
	# randomize() REMOVED
	
	var string_to_print = ""
	operation = operations[randi()%4]
	# General operands for +, -, *
	var l2_val1 = randi() % (20+1) # Local temp var for 0-20
	var l2_val2 = randi() % (20+1) # Local temp var for 0-20
	
	# Assign to class members num1, num2 based on operation
	if operation == "+":
		num1 = l2_val1
		num2 = l2_val2
		result = num1 + num2
		string_to_print = str(num1) + " " + operation + " " + str(num2)
	elif operation == "-":
		# Subtraction: A - B = C, where A >= B
		num1 = max(l2_val1, l2_val2) # num1 is minuend
		num2 = min(l2_val1, l2_val2) # num2 is subtrahend
		result = num1 - num2
		string_to_print = str(num1) + " " + operation + " " + str(num2)
	elif operation == "*":
		num1 = l2_val1
		num2 = l2_val2
		result = num1 * num2
		string_to_print = str(num1) + " " + operation + " " + str(num2)
	elif operation == "/":
		# For division, Level 2 uses specific ranges: divisor 1-10, quotient 0-10
		num1 = randi() % 10 + 1   # Divisor is 1-10 (already non-zero)
		num2 = randi() % (10+1) # Quotient is 0-10
		
		var dividend = num1 * num2 # Calculate dividend for the question
		string_to_print = str(dividend) + " " + operation + " " + str(num1)
		result = num2 # The answer is the quotient
	return [result, string_to_print]

func generate_quiz_level3():
	# Generates a quiz question with two operations of the form (num1 op1 num2) op2 num3.
	# Ensures integer results for all operations, including division.
	# This function is not actively used by Main_game2.gd or Main_gameTIME.gd.
	# It was refactored for two-step operations but ultimate_generate_quiz (single step) is used instead for varying difficulty.
	# Operator precedence is handled by parentheses: the first operation is fully resolved before the second.
	# randomize() REMOVED

	var num1_val
	var num2_val
	var num3_val
	# Note: `operations` array is defined globally: var operations = ["+", "-", "*", "/"]
	var op1_str = operations[randi()%4]
	var op2_str = operations[randi()%4]

	var res1_val # Result of the first operation (num1 op1 num2)
	var final_res_val # Final result of (res1_val op2 num3)
	var part1_str = "" # String representation of "num1 op1 num2"
	var question_str = "" # Full question string "(num1 op1 num2) op2 num3"

	# --- Define operand ranges for difficulty ---
	var add_sub_range = 20 # Operands up to 20 for addition and subtraction.
	var mult_div_op_range = 10 # Operands up to 10 for multiplication, and for divisors/quotients in division.

	# --- First Operation: num1_val op1_str num2_val = res1_val ---
	if op1_str == "+":
		num1_val = randi() % (add_sub_range + 1) # 0 to add_sub_range
		num2_val = randi() % (add_sub_range + 1) # 0 to add_sub_range
		res1_val = num1_val + num2_val
		part1_str = str(num1_val) + " + " + str(num2_val)
	elif op1_str == "-":
		# Structure as: minuend - subtrahend = res1_val
		# To ensure res1_val is often positive and numbers are reasonable:
		# Let res1_val (the answer of this part) be val_a. Let subtrahend be val_b.
		# Then minuend = val_a + val_b.
		var val_a = randi() % (add_sub_range + 1) # Potential result of subtraction
		var val_b = randi() % (add_sub_range + 1) # Subtrahend
		num1_val = val_a + val_b # Minuend
		num2_val = val_b         # Subtrahend
		res1_val = num1_val - num2_val # This will be val_a
		part1_str = str(num1_val) + " - " + str(num2_val)
	elif op1_str == "*":
		num1_val = randi() % (mult_div_op_range + 1) # 0 to mult_div_op_range
		num2_val = randi() % (mult_div_op_range + 1) # 0 to mult_div_op_range
		res1_val = num1_val * num2_val
		part1_str = str(num1_val) + " * " + str(num2_val)
	else: # op1_str == "/"
		# Structure as: (quotient * divisor) / divisor = quotient
		# res1_val will be the quotient.
		var quotient1 = randi() % (mult_div_op_range + 1) # 0 to mult_div_op_range
		num2_val = randi() % mult_div_op_range + 1  # Divisor (1 to mult_div_op_range, to avoid division by zero)
		num1_val = quotient1 * num2_val # Dividend
		res1_val = quotient1 # Result of the first operation is the quotient
		part1_str = str(num1_val) + " / " + str(num2_val)

	# --- Second Operation: (res1_val) op2_str num3_val = final_res_val ---
	# The string for the first part is parenthesized for clarity.
	var question_prefix = "(" + part1_str + ")"

	if op2_str == "+":
		num3_val = randi() % (add_sub_range + 1) # 0 to add_sub_range
		final_res_val = res1_val + num3_val
		question_str = question_prefix + " + " + str(num3_val)
	elif op2_str == "-":
		# final_res_val = res1_val - num3_val.
		# Try to keep num3_val reasonable, especially if res1_val is positive and small, to get positive results more often.
		if res1_val >= 0 && res1_val <= add_sub_range:
			num3_val = randi() % (res1_val + 1) # num3 is 0 to res1_val (inclusive)
		else: # res1_val is large (e.g. > 20 or product from *) or negative
			num3_val = randi() % (add_sub_range + 1) # 0 to add_sub_range
		final_res_val = res1_val - num3_val
		question_str = question_prefix + " - " + str(num3_val)
	elif op2_str == "*":
		# Control product size: if res1_val is large, make num3_val (multiplier) smaller.
		if abs(res1_val) > (mult_div_op_range * 2): # If res1_val is e.g. > 20 (abs for safety)
			num3_val = randi() % (mult_div_op_range / 2 + 1) # Smaller multiplier (e.g., 0-5 if range is 10)
		else:
			num3_val = randi() % (mult_div_op_range + 1) # Standard multiplier (e.g., 0-10)
		final_res_val = res1_val * num3_val
		question_str = question_prefix + " * " + str(num3_val)
	else: # op2_str == "/"
		# Structure as: res1_val / num3_val = final_res_val
		# res1_val (result of first op) is the dividend. num3_val is the divisor.
		# Need to ensure num3_val is a non-zero factor of res1_val.
		if res1_val == 0:
			num3_val = randi() % mult_div_op_range + 1  # Divisor (1 to mult_div_op_range)
			final_res_val = 0
		else:
			# Find a suitable num3_val (divisor) from 1 to mult_div_op_range that divides res1_val.
			var possible_divisors = []
			for i in range(1, mult_div_op_range + 1): # Check potential divisors (1 to e.g. 10)
				if res1_val % i == 0:
					possible_divisors.append(i)
			
			if len(possible_divisors) > 0:
				# Choose one of the valid divisors randomly.
				num3_val = possible_divisors[randi() % len(possible_divisors)]
				final_res_val = res1_val / num3_val
			else:
				# No divisor found in the range [1, mult_div_op_range] that cleanly divides res1_val.
				# Example: res1_val = 13, mult_div_op_range = 10. Only divisor is 1.
				# Example: res1_val = 26, mult_div_op_range = 10. Divisors are 1, 2.
				# Example: res1_val = 77, mult_div_op_range = 10. Divisors are 1, 7.
				# If res1_val is prime and > mult_div_op_range, only factor is 1.
				# Fallback: use 1 as the divisor if res1_val is not zero.
				num3_val = 1 # Dividing by 1 is always possible and results in an integer.
				final_res_val = res1_val / num3_val
				# An alternative here could be to change op2_str to '*' or '+',
				# but using num3_val = 1 keeps the division operation.
		question_str = question_prefix + " / " + str(num3_val)

	return [final_res_val, question_str]

