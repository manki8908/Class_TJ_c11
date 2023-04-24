# 1. 모듈 별칭을 사용해서 계산기능 사용
# 2. 모듈이름을 붙이지 않고 함수 사용하기
#    2개 함수만 함수명1, 함수명2
#    함수명3을 가져올때 어떻게 동작되는지
# *로 가져오는 방식으로 동작

import myCalc as mc
print(mc.get_plus(1,2))
print(mc.get_minus(1,2))
print(mc.get_mul(1,2))
print(mc.get_division(1,2))

from myCalc import get_plus, get_minus, get_mul # get_division
print(get_plus(1,2))
print(get_minus(1,2))
print(get_mul(1,2))
print(get_division(1,2))

from myCalc import *
print(get_plus(1,2))
print(get_minus(1,2))
print(get_mul(1,2))
print(get_division(1,2))

