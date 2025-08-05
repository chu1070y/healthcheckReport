## 사전 설치
```bash
# python 설치
yum install python39 python39-pip
 
python3.9 --version
 
# python 모듈 설치
python3.9 -m pip install -r requirements.txt
```

## 스크립트 실행
```bash
# 설정 내용 변경
vi config/config.ini
 
 
# 점검보고서 스크립트 실행
./start.sh
```

## 점검보고서 사용 프로세스
1. 점검보고서 스크립트 다운로드
2. sample/collect.sh 스크립트를 이용해 데이터 수집
3. 수집한 로그를 점검보고서 스크립트 서버에 업로드  
    a. ⚠️주의사항!

        1) 로그 업로드한 디렉토리에는 로그 파일만 넣을 것!  
        2) 동일 서버의 여러 개의 과거 로그들을 한번에 실행하고 싶은 경우, *로그 파일 확장자명*을 과거 날짜 순 또는 과거 순서대로 변경해서 로그 업로드 할 것!

4. 점검보고서 스크립트 실행