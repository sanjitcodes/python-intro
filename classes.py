class point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

p = point(5,15)
p.x += 1
print(p.x)
print(p.y)
