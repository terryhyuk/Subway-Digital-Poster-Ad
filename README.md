# Subway Digital Poster Ad

[![SwiftUI](https://img.shields.io/badge/SwiftUI-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://developer.apple.com/xcode/swiftui/)
[![UIKit](https://img.shields.io/badge/UIKit-2396F3?style=for-the-badge&logo=uikit&logoColor=white)](https://developer.apple.com/documentation/uikit/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white)](https://firebase.google.com/)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white)](https://jupyter.org/)
[![scikit-learn](https://img.shields.io/badge/scikit--learn-F7931E?style=for-the-badge&logo=scikit-learn&logoColor=white)](https://scikit-learn.org/)
[![Notion](https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white)](https://www.notion.so/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/)
[![Figma](https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white)](https://figma.com/)
[![Miro](https://img.shields.io/badge/Miro-050038?style=for-the-badge&logo=miro&logoColor=white)](https://miro.com/)

---

## Table of Contents

- [Overview](#overview)
- [Demo Video](#demo-video)
- [Features](#features)
- [My Contributions](#my-contributions)
- [Tech Stack](#tech-stack)
- [System Architecture](#system-architecture)
- [Database](#database)
- [Screen Flow Diagram](#screen-flow-diagram)
- [Screenshots](#screenshots)
- [Data Analysis](#data-analysis)
- [How to Run](#how-to-run)
- [Contact](#contact)

---

## Overview

Subway Digital Poster Ad is an iOS application developed using SwiftUI to optimize subway advertisement targeting.  
The project analyzes passenger data by location, time slot, and demographics, and includes a user-friendly registration system for enhanced user experience.

- **Team Size:** 5 members  
- **Project Duration:** January 10, 2025 – February 5, 2025

---

## Demo Video

- [Demo Video](https://youtu.be/1IkXuh4D-f0)

---

## Features

- **Registration System**:  
  - ID duplication check and email format validation  
  - Password validation logic with success/error popups
- **Ad Targeting**:  
  - Analyzed subway station data to optimize ad targeting  
  - Developed predictive models for effective ad placement

---

## My Contributions

- Designed a user-friendly registration page with input validation
- Implemented ID duplication check and email format validation
- Added password validation logic with success/error popups
- Analyzed subway station data to optimize advertisement targeting  
  > *Note: No significant patterns were found in the data, so the analysis was not reflected in the final app, but the full analysis process is included for reference.*

---

## Tech Stack

- **Frontend**: SwiftUI (iOS app development)
- **Backend**: FastAPI (API design and server-side integration)
- **Data Analysis**: Python (data preprocessing and machine learning model development)
- **Database**: Firebase

---

## System Architecture

![System Architecture](image/system_architecture.png)

---

## Database

### Firebase Structure  
![Firebase Structure](image/Firebase.png)

---

## Screen Flow Diagram

![Screen Flow Diagram](image/SFD.png)

---

## Screenshots

### Main Screenshots (Features I Developed)

![Signup Page](image/singup.png)

---

## Data Analysis

The full data analysis process (PDF) is available here:  
- [Data Analysis Report (PDF)](image/data_analysis.pdf)

> The analysis included data preprocessing and exploration, but no distinct patterns were found for ad targeting.

---

## How to Run

### iOS App

1. Clone the repository  
   `git clone https://github.com/terryhyuk/Subway-Digital-Poster-Ad`
2. Open the project in Xcode
3. Install dependencies using CocoaPods (if needed)
4. Run the app on a simulator or a physical device

### Backend (FastAPI)

1. Go to the `Python_Server` directory:  
   `cd Python_Server`
2. (Optional) Create and activate a virtual environment:  
   `python3 -m venv venv`  
   `source venv/bin/activate`
3. Install dependencies (requirements.txt is in the project root):  
   `pip install -r ../requirements.txt`
4. Run the FastAPI server:  
   `uvicorn ad_subway:app --reload`

- The server will start at [http://127.0.0.1:8000](http://127.0.0.1:8000)
- Interactive API docs available at [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

---

## Contact

For questions, contact:  
**Terry Yoon**  
yonghyuk.terry.yoon@gmail.com
