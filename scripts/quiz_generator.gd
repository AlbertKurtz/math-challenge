extends Node

var operations = ["+", "-", "*", "/"]
var num1
var num2
var operation
var operation2
var result
var print_string
var min_time_allowed = 20 #seconds
var delta_time_difficulty = 5 #seconds
var time_levels = 5


func split_level(lvl):
	# returns operation_difficulty (first) and time difficulty (second)
	return [int(lvl/time_levels)+1, lvl%time_levels]

func time_difficulty (lvl): #returns time in seconds

	#first attempt to formulate a time difficulty
	#easier is 60 seconds time, harder is 5.
	# in this way there are "10 time levels"
	return max(int((min_time_allowed + time_levels*delta_time_difficulty) -delta_time_difficulty*lvl), min_time_allowed)

func operation_difficulty(lvl): #returns 2 numbers
	
	
	#operation difficulty is in order +, -, *, /.
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
	var lvl_split = split_digits(lvl)
	var x_lvl = lvl_split[1]
	var y_lvl = lvl_split[0]
	var x = rand_int(0, (x_lvl +1)*10)
	var y = rand_int(0, y_lvl*10)
	#print("0< x <" , (x_lvl +1)*10, ";  0< y <", y_lvl*10)
	return [x, y]
	
	
	pass

func split_digits(number):
	#splits every number in two:  the last digit and all the others
	#example: 
	# 123 -> 3, 12
	# 34 -> 4, 3
	# 999923 -? 3, 99992
	var last_digit = 1
	var other_digits = 0
	var str_number = str(int(number))
	if str_number.length()<2:
		last_digit = number
		other_digits = 0
	else:
		last_digit = int(str_number[-1])
		other_digits = int(str_number.left(str_number.length()-1))
	
	return [last_digit, other_digits]
	
	

func ultimate_generate_quiz(lvl):
	#lvl is operation lvl
	
	# difficulty in a math challenge can come from differen sources
	# but basically there are 2 levels of difficulty:
	# - duration of the challenge: less time forces the player to calculate faster
	# - numbers involved: the bigger the numbers the harder
	# with sum and subtraction the constraint on bigger numbers is quite linear
	# for multiplication it is harder, because when number are greater than 10 we 
	# already struggle to visualize the result.
	# the difficulty balance is quite hard. 
	# 
	# level can have 2 labels X and Y, with X the "time difficulty" and Y the operation
	# difficulty.
	var two_numbers = operation_difficulty(lvl)
	
	var string_to_print = ""
	operation = operations[randi()%4]
	randomize()
	if randf()<0.5:
		num1 = two_numbers[0]
		num2 = two_numbers[1]	
	else:
		num1 = two_numbers[1]
		num2 = two_numbers[0]	
		
	if operation == "+":
		result = num1 + num2
		string_to_print =str(num1) +" "+ operation +" "+ str(num2)
	if operation == "-":
		result = num1 + num2
		string_to_print =str(result) +" "+ operation +" "+ str(num1)
		result = num2
	if operation == "*":

		result = num1 * num2
		string_to_print =str(num1) +" "+ operation +" "+ str(num2)
	if operation == "/":
		if num1 == 0:
			num1+= randi() % (10)+1
		result = num1 * num2
		string_to_print =str(result) +" "+ operation +" "+str(num1)
		result = num2
	

	return [result, string_to_print]


func rand_int(min_int, max_int):
	randomize()
	#returns random int in interval
	return (randi() % (max_int - min_int)) + min_int

func priority(operation):
	return (operation =="*" or operation == "/")

func generate_quiz_level1():
	randomize()
	
	var string_to_print = ""
	operation = operations[randi()%4]
	num1 = randi() % (10+1)
	num2 = randi() % (10+1)	
	if operation == "+":
		result = num1 + num2
		string_to_print =str(num1) +" "+ operation +" "+ str(num2)
	if operation == "-":

		result = num1 + num2
		string_to_print =str(result) +" "+ operation +" "+ str(num1)
		result = num2
	if operation == "*":

		result = num1 * num2
		string_to_print =str(num1) +" "+ operation +" "+ str(num2)
	if operation == "/":
		if num1 == 0:
			num1+= randi() % (10)+1
		result = num1 * num2
		string_to_print =str(result) +" "+ operation +" "+str(num1)
		result = num2
	

	return [result, string_to_print]
	
func generate_quiz_level2():
	randomize()
	
	var string_to_print = ""
	operation = operations[randi()%4]
	num1 = randi() % (20+1)
	num2 = randi() % (20+1)	
	if operation == "+":
		
		result = num1 + num2
		string_to_print =str(num1) +" "+operation +" "+ str(num2)
	if operation == "-":
		result = num1 + num2
		string_to_print =str(result) +" "+operation +" "+ str(num1)
		result = num2
	if operation == "*":
		result = num1 * num2
		string_to_print =str(num1) +" "+ operation +" "+str(num2)
	if operation == "/":
		num1 = randi() % (10)+1
		num2 = randi() % (10+1)	
		result = num1 * num2
		string_to_print =str(result) +" "+operation +" "+str(num1)
		result = num2
	return [result, string_to_print]

func generate_quiz_level3():
	#NEED TO FIX THIS THING, DOES NOT WORK
	#give priority to * and / compared to + and -
	randomize()
	var string_to_print = ""
	operation = operations[randi()%4]
	operation2 = operations[randi()%4]
	if operation == "+" and not priority(operation2):
		num1 = randi() % (20+1)
		num2 = randi() % (20+1)	
		result = num1 + num2
		string_to_print =str(num1) +" "+ operation +" "+ str(num2)
	if operation == "-" and not priority(operation2) :
		num1 = randi() % (20+1)
		num2 = randi() % (20+1)	
		result = num1 + num2
		string_to_print =str(result) +" "+operation +" "+str(num1)
		result = num2
	if operation == "*":
		num1 = randi() % (20+1)
		num2 = randi() % (10+1)
		result = num1 * num2
		string_to_print =str(num1) +" "+ operation +" "+str(num2)
	if operation == "/":
		num1 = randi() % (10)+1
		num2 = randi() % (10+1)	
		result = num1 * num2
		string_to_print =str(result) +" "+ operation +" "+ str(num1)
		result = num2
		
	if operation2 == "+":
		num1 = result
		num2 = randi() % (20+1)	
		result = num1 + num2
		string_to_print = string_to_print +" "+ operation2 +" "+ str(num2)
	if operation2 == "-":
		num1 = result
		num2 = randi() % (20+1)	
		result = num1 + num2
		string_to_print = str(result) +" "+ operation2  +" "+ string_to_print
		result = num2
	if operation2 == "*":
		num1 = result
		num2 = randi() % (10+1)
		result = num1 * num2
		string_to_print =string_to_print +" "+ operation2 +" "+ str(num2)
	if operation2 == "/":
		num1 = result
		num2 = randi() % (10+1)	
		result = num1 * num2
		string_to_print = str(result) +" "+ operation2  +" "+string_to_print
		result = num2
	
	return [result, string_to_print]

