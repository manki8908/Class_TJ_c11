import turtle as t

# 기본값은 화살표
t.shape('turtle')

# 사각형
#for i in range(4):
#    t.right(90)
#    t.forward(100)

# 삼각형
#for i in range(3):
#    t.fd(100)
#    t.rt(120)

# 하트
red = t.Turtle()

def curve():
    for i in range(200):
        red.right(1)
        red.forward(1)

def heart():
    red.fillcolor('red')
    red.begin_fill()
    red.lefft(140)
    red.forward(113)
    curve()  # left
    red.left(120)
    curve()  # rigt
    red.forward(112)
    red.end_fill()

# 사용자 종료
t.mainloop()