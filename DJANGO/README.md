<참조링크>
* http://pythonstudy.xyz/python/article/307-Django-%ED%85%9C%ED%94%8C%EB%A6%BF-Template
* https://docs.djangoproject.com/
* https://wikidocs.net/70736
* https://velog.io/@hokim/%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EC%8B%9C%EC%9E%91%ED%95%98%EA%B8%B0%EC%95%B1%EC%83%9D%EC%84%B1%EA%B3%BC-%EB%AA%A8%EB%8D%B8-%EC%97%B0%EA%B2%B0


### 목차
1. 개발환경 준비
    * 가상환경(python)
    * Django 설치
2. Django 훑어보기
    * 프로젝트
    * 웹페이지 구동 흐름
    * APP
    * View
    * URL
    * 데이터베이스
    * 모델
    
---

1. 가상환경 설치 및 프로젝트 생성하기
    * 가상환경 설치
        ```
            -- 설치할 디렉토리 생성
            C:\> mkdir venvs       

            -- 파이썬 가상환경 등록
            C:\venvs> python -m venv mysite

            -- 가상환경 로드 및 종료
                설치경로/Script activate OR deacitvate
        ```

    * Django 설치
        ```
            pip install django==3.1.3
            python.exe -m pip install --upgrade pip
            (pip 업그레이드 필요시)
        ````
---

2. Django 흝어보기
* 프로젝트
    * 내용: 웹페이지 구축의 가장 큰 작업 단위, \
            Django 인스턴의 초기설정(DB구성, APP설정 등) 모음집
    * 생성
        * 수행 방법
        ```
            mkdir -p project/mysite
            cd project/mysite
            django-admin startproject config .

            # django-admin startproject '적용할 경로' (폴더가 생성됨), 하지만 이렇게하면 중복된 이름 폴더생성
            
        ```
        * 수행 결과
            ```
            project/mysite/
                - manage.py (Django 프로젝트와 다양한 방법으로 상호작용 하는 커맨드라인의 유틸리티)
                ./config/ (디렉토리 내부에 프로젝트를 위한 실제 Python 패키지들이 저장)
                    - __init__.py (이 디렉토리를 패키지처럼 다루라고 알려주는 용도의 빈 파일)
                    - settings.py (현재 Django 프로젝트의 환경 및 구성을 저장)
                    - urls.py (Django project 의 URL 선언을 저장)
                    - asgi.py (현재 프로젝트를 서비스하기 위한 ASGI 호환 웹 서버의 진입점)
                    - wsgi.py (현재 프로젝트를 서비스하기 위한 WSGI 호환 웹 서버의 진입점)
            ```

    * 웹페이지 접속하기
        ```
            python manage.py runserver
            # Starting development server at http://127.0.0.1:8000/
            # cntl + 주소 클릭
        ```
    * 관리자 만들기
        * 방법
        ```
            python manage.py createsuperuser
        ```
---

* 웹페이지 구동 흐름
    1. URL 요청 발생
        * 브라우저에서 로컬 서버로 "특정앱의 페이지"를 요청
    2. urls.py
        * 요청된 request URLpattern을 찾아, view에 요청 파라메터를 전달
    3. views.py
        * 요청된 정보를 반환   

---

* APP
    * 내용: 한 프로젝트를 구성하는 하위 단위모듈
    * 구성: 자기 자신만의 모델, 뷰, 탬플릿, URL 매핑등을 독자적으로 가지고 있음
    * 생성
        * 수행방법: 
        ```
            ./manage.py startapp 적용경로 or django-admin startapp 적용경로
        ```
        * 생성내용:
        ```
            ./적용경로/
                - __init__.py
                - admin.py
                - apps.py

                ./migrations/
                    - __init__.py
    
                - models.py
                - tests.py
                - views.py
        ```
        * 앱추가
        ``` 
            ./settings.py
                INSTALLED_APPS = [ "테이블을 연동시킬 앱의 모델?" ]
---

* View(view.py)
    * 내용: 작동함수를 통해 요청에 대한 응답 페이지를 반환
        * 요청된 URL 파라메터를 입력받음
        * 모델을 이용해 정보를 생산
        * tamplate을 사용하면 template에 정보를 삽입하여 출력할 html을 생산
        * 출력할 tamplate를 rendering
    * view.year_archive 예
    
        ```python
        from django.shortcuts import render
        from .models import Article
        
        def year_archive(request, year):
            a_list = Article.objects.filter(pub_date__year=year)
            context = {"year": year, "article_list": a_list}
            return render(request, "news/year_archive.html", context)
        ```
        * render(request요청된객체,템플릿,선택적인수)
                * request(??)

---

* URL(urls.py)
    * 내용
        * view를 앱의 url에 연결
        * 사용자가 특정 URL을 요청하면 일치하는 패턴의 URL 정보를 콜백함수(view)에 전달
        
    * 사용 예:
    
        ```python
        from django.urls import path
        from . import views

            urlpatterns = [
            path("articles/<int:year>/", views.year_archive),
            path("articles/<int:year>/<int:month>/", views.month_archive),
            path("articles/<int:year>/<int:month>/<int:pk>/", views.article_detail),
            ]

            # path( "URL 경로"(route), 콜백함수(views), 키워드(kwrgs), 이름지정(name) )
        ```
---

* 데이터 베이스
    * 내용
        * 백엔드에 사용할 DB 설정
            ./mysite/settings.py
            ```python
                DATABASES = {
                    'default': {
                        'ENGINE': 'django.db.backends.sqlite3',
                        'NAME': BASE_DIR / 'db.sqlite3',
                                }
                            }
            ```
        * 기본엔진으로 SQLite를 사용(mysql, oracle, postgresql등 있음)
        * 한국시간 설정
        ```python
            TIME_ZONE = 'Asia/Seoul'
            USE_TZ = False

        ```
    * 연동방법: 
        * 모델에서 자세히 설명
        * settings.py의 앱리스트에 추가된 모델리스트들은\
        `   python manage.py migrate    `를 통해 DB 테이블이 생성됨

---



* 모델
    * 내용: Django는 sql 쿼리를 사용하지 않고 파이썬 객체를 통해 데이터베이스와 연동하는 기능
    * 설계: 
        * models.py에서 원하는 기능을 하는 class 생성
            ```python
                from django.db import models
                    class Question(models.Model):
                        question_text = models.CharField(max_length=200)
                        pub_date = models.DateTimeField("date published")

                    class Choice(models.Model):
                        question = models.ForeignKey(Question, on_delete=models.CASCADE)
                        choice_text = models.CharField(max_length=200)
                        votes = models.IntegerField(default=0)
            ```
    * 사용자 정의 모델 활성화

        1. settings.py의 INSTALLED_APPS에 정의 모델 추가
          
        2. 생성 가능한 모델을 찾아 테이블이 존재하지 않을 경우 마이그레이션을 생성 \
        --> `python manage.py makemigrations`

        3. 마이그레이션을 실행하고 사용자의 데이터베이스에 테이블을 생성 \
        --> `python manage.py migrate` 

    * 활성 모델 사용 예:
        ```python
            # Import the model classes we just wrote.
            from polls.models import Choice, Question  

            # No questions are in the system yet.
            Question.objects.all()


            # Create a new Question.
            from django.utils import timezone
            q = Question(question_text="What's new?", pub_date=timezone.now())
            
            # Save the object into the database. You have to call save() explicitly.
            >>> q.save()
            
            # Now it has an ID.
            >>> q.id
            1
            
            # Access model field values via Python attributes.
            q.question_text
            "What's new?"
            
            # Change values by changing the attributes, then calling save().
            q.question_text = "What's up?"
            q.save()
            
            # objects.all() displays all the questions in the database.
             Question.objects.all()
        ```
---

* 템플릿(template)
    * 사전적 의미: 어떤 특정한 모양을 만들기 위한 틀
    * 내용: 이미 구성된 웹페이지(html) 파일로서 view로부터 전달된 데이터를 적용하여 표출
    * View로부터 어떤 데이타를 전달받아 HTML 템플릿 안에 그 데이타를 동적으로 치환해서 사용 --> 템플릿 언어가 따로 있음\
        * 변수: {{변수명, 변수명.속성}}
        * 태그: {{% 템플릿 태그 %}} 
            ```
                {% if count > 0 %}
                    Data Count = {{ count }}
                {% else %}
                    No Data
                {% endif %}

                {% for item in dataList %}
                  <li>{{ item.name }}</li>
                {% endfor %}

                {% csrf_token %}
            ``` 
        * 필터: 
            ```
                날짜 포맷 지정
                {{ createDate|date:"Y-m-d" }}

                소문자로 변경
                {{ lastName|lower }}
            ```
        * 코멘트 
            * 한줄: {# 내용 #}
            * 여러줄: {% comment %}, {% endcomment %}
        * HTML escape: HTML 내용 중에 <, >, ', ", & 등과 같은 문자들이 있을 경우
            * autoescape 태그
                ```
                    {% autoescape on %}
                        {{ content }}
                    {% endautoescape %}
                ```
            * escape 필터
                ```
                    {{ content|escape }}
                ```

    * 템플릿 셋팅
        ```
            settings.py의 TEMPLATES 섹션
            BACKEND: django.template.backends.django.DjangoTemplate(기본)
            DIRS: [BASE_DIR / 'templates']
        ```
    * 보통 `(예: /home/templates/)` 와 같이 템플릿 모음 경로를 설정하고 각 앱에서 호출(중복 방지)
