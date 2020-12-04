import sys

for line in sys.stdin:
    
    # expecting line in for of "num,num\n"
    line = line.strip()
    # EOF
    if line == "": break
    
    # strings to ints, and sum
    values = line.split(",")
    nums = map(int, values)
    result = sum(nums)

    # send the result via stdout
    sys.stdout.write(str(result) + "\n")
    sys.stdout.flush()