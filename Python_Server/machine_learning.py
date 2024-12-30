from fastapi import APIRouter
import numpy as np
import ml_predict

router = APIRouter()

# 날짜가 선택될 때 실행
# 리턴 값 = list(dict)
# [
#     {
#         "20대" : int,
#         "30대" : int,
#         "40대" : int,
#         "50대" : int,
#         ...
#     }
# ]
@router.get("/jamsil_all_time")
async def jamsilAllTimePredict(year: int = None, month :int = None, day :int = None):
    results = [ml_predict.jamsil(year, month, day, time) for time in list(range(5, 24)) + [0]]
    for i, result in enumerate(results):
        result["시간대"] = i+5
    return results

@router.get("/jamsil")
async def jamsilPredict(year: int = None, month :int = None, day :int = None, time :int = None):
    predict = ml_predict.jamsil(year, month, day, time)
    return [predict]

@router.get("/hongdae_all_time")
async def hongdaeAllTimePredict(year: int = None, month :int = None, day :int = None):
    results = [ml_predict.hongdae(year, month, day, time) for time in list(range(5, 24)) + [0]]
    for i, result in enumerate(results):
        result["시간대"] = i+5
    return results

@router.get("/hongdae")
async def hongdaePredict(year: int = None, month :int = None, day :int = None, time :int = None):
    predict = ml_predict.hongdae(year, month, day, time)
    return [predict]

@router.get("/gangnam_all_time")
async def gangnamAllTimePredict(year: int = None, month :int = None, day :int = None):
    results = [ml_predict.gangnam(year, month, day, time) for time in list(range(5, 24)) + [0]]
    for i, result in enumerate(results):
        result["시간대"] = i+5
    return results

@router.get("/gangnam")
async def gangnamPredict(year: int = None, month :int = None, day :int = None, time :int = None):
    predict = ml_predict.gangnam(year, month, day, time)
    return [predict]