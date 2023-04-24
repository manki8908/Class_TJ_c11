score = int(input('점수를 입력해주세요: '))
grade = 'F'

if score >= 90:
    grade = 'A'
elif score >= 80:
    grade = 'B'
elif score >= 70:
   grade = 'C'

print("학점은: ", grade)