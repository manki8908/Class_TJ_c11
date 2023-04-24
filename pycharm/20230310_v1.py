# 가끔 진행중인 것을 통과시킬때
def hellow():
    pass

# 언패킹
x = (10, 20, 30)
print(x)
print(*x)  # 10 20 30

def my_fuc(a):
    print(f'my_fuc에는 {a}가 있고 타입은 {type(a)}')

tp = (1,2,3,4)
#my_fuc(tp)
#my_fuc(1,2,3,4)


def print_num(a,b,c):
    print(a)
    print(b)
    print(c)

print_num(1,2,3)
x = [1,2,3]
y = (1,2,3)

#print_num(x)   # 1을 [1,2,3]으로 인식 --> 에러
#print_num(*x)   # 언패킹 사용
#print_num(*y)

def sum_many(*args):
    sum = 0
    for i in args:
        sum += i
    return sum

res = sum_many(1,2,3,4,5)
print(res)