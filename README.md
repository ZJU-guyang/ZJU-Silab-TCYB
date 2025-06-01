# ZJU-Silab-TCYB

This repository provides the source code and benchmark materials for the manuscript:

**"Joint Time and Energy Efficient Routing Optimisation Framework for Offshore Wind Farm Inspection Using an Unmanned Surface Vehicles"**  
Submitted to *IEEE Transactions on Cybernetics*  
Authors: Yang Gu, Shujie Yang, Weibo Zhong, Zili Tang, and Yunlin Si

## 🔍 Description

This repository includes:

- Implementations of the proposed RL-driven adaptive GA enhancement framework (e.g., `RLAEGA.m`)
- Baseline algorithms for comparison (`GA.m`, `NRBO.m`, `TOC.m`, `SFOA.m`, etc.)
- Benchmark test functions from CEC2022 (`Get_Functions_cec2022.m`, `cec22_func.cpp`)
- Operator modules (`selection_operator.m`, `crossover_operator.m`, `mutations_operator.m`)
- Chaos-enhanced initialization methods (`chaos.m`, `Chaos_initialization.m`)
- Supporting files for testing and performance evaluation (`test1.m`, `test2.m`, `best_combinations.csv`)

## 📁 Folder Structure
ZJU-Silab-TCYB/
├── RLAEGA.m # Our proposed RL-enhanced GA

├── benchmark files # CEC2022 test functions

├── mutation/crossover/... # Strategy operator

├── compared algorithms # GA, NRBO, TOC, SFOA, etc.

├── test1.m, test2.m # Test scripts

├── README.md # This file

## 🔐 Access Policy of the proposed RLAEGA
The proposed RLAEGA and joint optitimsation framework is currently private during the manuscript review stage.
If you are an editor or reviewer and wish to access the code, please contact the corresponding author:  
📧 yanggu@zju.edu.cn or yulinsi@zju.edu.cn

The complete code will be released publicly after acceptance.

## ⚠️ License & Usage
This repository is shared **for academic and non-commercial use only**.  
If you use this code or any part of the framework, **please cite our paper** as follows:

> Yang Gu, Shujie Yang, Weibo Zhong, Zili Tang, and Yunlin Si,  
> "*Joint Time and Energy Efficient Routing Optimisation Framework for Offshore Wind Farm Inspection Using an Unmanned Surface Vehicles*,"  
> *IEEE Transactions on Cybernetics*, under review, 2025.

