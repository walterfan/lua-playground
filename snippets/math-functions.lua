-- The math library
print("pi    =", math.pi)
print("huge  =", math.huge)
print("floor =", math.floor(3.7), "ceil =", math.ceil(3.2))
print("abs   =", math.abs(-42), "fmod =", math.fmod(7, 3))
print("max/min =", math.max(3, 1, 4, 1, 5), math.min(3, 1, 4))
print("sqrt  =", math.sqrt(144))
print("pow   =", 2 ^ 0.5)

-- trigonometry works in radians
print(string.format("sin(pi/6) = %.3f", math.sin(math.pi / 6)))
print("deg(180) =", math.deg(math.pi), " rad(90) =", math.rad(90))

-- random numbers (unseeded in 5.1, so the sequence repeats each run)
print("dice:", math.random(1, 6), math.random(1, 6), math.random(1, 6))

-- all numbers are doubles; integers too
print(7 / 2, 7 % 2, 2 ^ 53 == 2 ^ 53 + 1)
