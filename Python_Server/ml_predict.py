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
    weekend = 1 if selectDate.weekday() >= 5 else 0,
    return (y,m,d,w,h,holi,weekend)

def jamsil(year, month, day, time):
    """
    머신러닝의 잠실의 승하차 예측 수를 리턴하는 함수
    Parameter : 년, 월, 일, 시간대
    return : dict
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

    y,m,d,w,h,holi,weekend = getDateInfo(selectDate)

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
    age_group_dict['30/40대'] = 0
    age_group_dict = {key: (value if value >= 0 else 0) for key, value in age_group_dict.items()}
    return age_group_dict

def hongdae(year, month, day, time):
    """
    머신러닝의 홍대의 이용객 수를 예측한 값을 리턴하는 함수
    Parameter : 년, 월, 일, 시간대
    return : dict
    """

    foreigner_youth = joblib.load("model/hongdae/gradient_boosting.joblib")
    norm_woo = joblib.load("model/hongdae/random_forest.joblib")
    
    selectDate = datetime(year,month,day,time)

    y,m,d,w,h,holi,weekend = getDateInfo(selectDate)
    
    vac = 1 if month in [1, 2, 7, 8] else 0

    foreigner_youth_result = foreigner_youth.predict(np.array([year, month, w, time, vac]).reshape(-1,5))
    norm_woo_result = norm_woo.predict(np.array([year, month, w, time, vac]).reshape(-1,5))
    # print(foreigner_youth_result[0])
    # print([round(foreigner_youth_result[0][i]) for i in [0,2]]) # 외국인 청소년
    # print(norm_woo_result[0])
    # print([round(norm_woo_result[0][i]) for i in [1, 3, 4, 5]]) # 20, 30/40, 50
    keys = ["우대권", "20대", "30/40대", "50대", "외국인", "청소년"]
    result_list = [round(norm_woo_result[0][i]) for i in [1, 3, 4, 5]] + [round(foreigner_youth_result[0][i]) for i in [0,2]]
    age_group_dict = {key: round(value) for key, value in zip(keys, result_list)}
    age_group_dict['30대'] = 0
    age_group_dict['40대'] = 0
    age_group_dict = {key: (value if value >= 0 else 0) for key, value in age_group_dict.items()}
    return age_group_dict

def gangnam(year, month, day, time):
    """
    머신러닝의 강남의 이용객 수를 예측한 값을 리턴하는 함수
    Parameter : 년, 월, 일, 시간대
    return : dict
    """
    selectDate = datetime(year,month,day,time)
    y,m,d,w,h,holi,weekend = getDateInfo(selectDate)

    gangnam_model = joblib.load("model/gangnam/model.joblib")

    # print(year, month, day, time, w, weekend, holi)
    gangnam_result = gangnam_model.predict(np.array([year, month, day, time, w, weekend[0], holi]).reshape(-1,7))
    # print(gangnam_result)
    keys = ["청소년", "20대", "30대", "40대", "50대", "우대권", "외국인"]
    age_group_dict = {key: round(value) for key, value in zip(keys, gangnam_result[0])}
    age_group_dict['30/40대'] = 0
    age_group_dict = {key: (value if value >= 0 else 0) for key, value in age_group_dict.items()}
    return age_group_dict
