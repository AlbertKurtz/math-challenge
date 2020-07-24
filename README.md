# Math Challenge

Math Challenge is one of the firs games/prototypes I made. 
It is a game about doing fast calculation with the basic operations +, -, *, /

There is a countdown clock that refreshes every 10 answers, with a progressively lower amount of time added to the clock.
Each time the player gains additional time, the difficulty of the questions increases.

All quizes are procedurally generated, based on an algorithm contained in `quiz_generator.gd`. The function used in the current state is
`ultimate_generate_quiz()`

  func ultimate_generate_quiz(lvl):
  
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
  
 
 Game requires some fixes and visual enhancement, but right now it is in a good state and playable.
