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
    return results


@router.get("/jamsil")
async def jamsilPredict(year: int = None, month :int = None, day :int = None, time :int = None):
    predict = ml_predict.jamsil(year, month, day, time)
    return [predict]

