import holidays
import joblib
import numpy as np
from datetime import datetime, date
import warnings
warnings.filterwarnings("ignore", message="X does not have valid feature names")

def getDateInfo(selectDate:datetime):
    """
    날짜 정보를 리턴하는 함수
    Parameter : datetime
    return : 연도, 월, 일, 요일, 시간, 공휴일
    """
    # 데이터 추출
    y = selectDate.year  # 연도
    m = selectDate.month  # 월
    d = selectDate.day  # 일
    w = selectDate.weekday() # 요일
    h = selectDate.hour  # 시간
    # 한국 공휴일 설정
    kr_holidays = holidays.KR(years=range(y,y+1))
    holi = selectDate.date() in kr_holidays  # 공휴일 여부
    return (y,m,d,w,h,holi)

def jamsil(year, month, day, time):
    """
    머신러닝의 잠실의 승하차 예측 수를 리턴하는 함수
    Parameter : 년, 월, 일, 시간대
    return : list(dict)
    """
    # Feature ["시간대","월","요일","공휴일여부","일"]] Target ['승객수']
    c_on = joblib.load("model/jamsil/cheong_on.pkl")
    # Feature ["시간대","월","요일","공휴일여부","일"] Target ['승객수']
    c_off = joblib.load("model/jamsil/cheong_off.h5")
    # Feature ["시간대","월","요일","공휴일여부", "년"] Target ['승차_우대권', '하차_우대권']
    woo = joblib.load("model/jamsil/woodae.h5")
    # Feature ['시간대', '월', '요일', '공휴일여부', '년'] Target ['승차_20대', '승차_30대', '승차_40대', '승차_50대','하차_20대', '하차_30대', '하차_40대', '하차_50대']
    norm = joblib.load("model/jamsil/normal.pkl")

    selectDate = datetime(year,month,day,time)

    y,m,d,w,h,holi = getDateInfo(selectDate)

    # 학습 Feature에 맞게 값 변화
    if h < 3:
        h = 24
    elif h < 5:
        h = 5

    # 값 예측하기
    result_list = [prd[i] + prd[i + 4] for prd in norm.predict(np.array([h, m, w, holi, d]).reshape(-1, 5)) for i in range(4)]
    result_list.append(c_on.predict(np.array([h,m,w,holi,d]).reshape(-1,5))[0] + c_off.predict(np.array([h,m,w,holi,d]).reshape(-1,5))[0])
    result_list.append(woo.predict(np.array([h,m,w,holi,d]).reshape(-1,5)).sum())


    keys = ["20대", "30대", "40대", "50대", "청소년", "우대권"]
    age_group_dict = {key: round(value) for key, value in zip(keys, result_list)}
    age_group_dict['외국인'] = 0
    
    return age_group_dict