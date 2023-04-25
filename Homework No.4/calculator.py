def add(x, y): # Add two numbers
    return x + y


def subtract(x, y): # Subtract two numbers
    return x - y


def multiply(x, y): #Multiply two numbers
    return x * y


def divide(x, y): #Divide two numbers
    return x / y


print("Select operation.")
print("1.Add")
print("2.Subtract")
print("3.Multiply")
print("4.Divide")

while True:
    # choice from the user
    choice = input("Enter choice(1/2/3/4):! ")

    # check if choice is valid
    if choice in ('1', '2', '3', '4'):
        try:
            num1 = float(input("Enter first number: ")) #User enter first number
            num2 = float(input("Enter second number: ")) # User enter seconf number
        except ValueError: #if not valid print massage
            print("Invalid input. Only numbers allowed.")
            continue # continue to next iteration

        if choice == '1':
           print(num1, "+", num2, "=", add(num1, num2))

        elif choice == '2':
            print(num1, "-", num2, "=", subtract(num1, num2))

        elif choice == '3':
            print(num1, "*", num2, "=", multiply(num1, num2))

        elif choice == '4':
            if num2 != 0: #check second number if not 0 print out the result
                 print(num1, "/", num2, "=", divide(num1, num2))
            
            else: #if zero enter new number and print the result

                print("Can not divide by zero") 
                num2 = float(input("Enter second number again: "))
                print(num1, "/", num2, "=", divide(num1, num2))

               
            
        
        
        
        next_calculation = input("Would you like to do a new calculation? (yes/no): ")
        if next_calculation == "no":
          break
    else:
        print("Invalid Input")
