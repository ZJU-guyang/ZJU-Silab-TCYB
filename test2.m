%Copyright (c) 2025 Yang Gu

%This code is provided for academic and non-commercial research purposes only.
%Use, reproduction, or modification of this code for commercial purposes is prohibited without explicit written permission.

%If you use this code in your work, please cite the following paper:
%"Joint Time and Energy Efficient Routing Optimisation Framework for Offshore Wind Farm Inspection Using an Unmanned Surface Vehicles", IEEE Transactions on Cybernetics, under review.
%Contact: yanggu[at]zju.edu.cn
clc;clear;close all
%% 基本参数
nPop = 20; % 种群数
Max_iter = 1000; % 最大迭代次数
dim = 20; % cec2022函数维度只能选 2, 10, 20
run_times = 20; % 算法总运行次数
Function_name = 8;
[lb,ub,dim,fobj] = Get_Functions_cec2022(Function_name,dim);
%% 调用算法部分
Optimal_results={}; % Optimal results用以保存结果
for run_time=1:run_times

    [Best_score,Best_pos,cg_curve]=TOC(nPop,Max_iter,lb,ub,dim,fobj);
    Optimal_results{1,1}="TOC";
    Optimal_results{2,1}(run_time,:)=cg_curve;
    Optimal_results{3,1}(run_time,:)=Best_score;
    Optimal_results{4,1}(run_time,:)=Best_pos;

    [Best_score,Best_pos,cg_curve]=OOA(nPop,Max_iter,lb,ub,dim,fobj);
    Optimal_results{1,2}="OOA";
    Optimal_results{2,2}(run_time,:)=cg_curve;
    Optimal_results{3,2}(run_time,:)=Best_score;
    Optimal_results{4,2}(run_time,:)=Best_pos;

    [Best_score,Best_pos,cg_curve]=SFOA(nPop,Max_iter,lb,ub,dim,fobj);
    Optimal_results{1,3}="SFOA";
    Optimal_results{2,3}(run_time,:)=cg_curve;
    Optimal_results{3,3}(run_time,:)=Best_score;
    Optimal_results{4,3}(run_time,:)=Best_pos;

    [Best_score,Best_pos,cg_curve]=RRTO(nPop,Max_iter,lb,ub,dim,fobj);
    Optimal_results{1,4}="RRTO";
    Optimal_results{2,4}(run_time,:)=cg_curve;
    Optimal_results{3,4}(run_time,:)=Best_score;
    Optimal_results{4,4}(run_time,:)=Best_pos;

    [Best_score,Best_pos,cg_curve]=NRBO(nPop,Max_iter,lb,ub,dim,fobj);
    Optimal_results{1,5}="NRBO";
    Optimal_results{2,5}(run_time,:)=cg_curve;
    Optimal_results{3,5}(run_time,:)=Best_score;
    Optimal_results{4,5}(run_time,:)=Best_pos;

    [Best_score,Best_pos,cg_curve]=GA(nPop,Max_iter,lb,ub,dim,fobj);
    Optimal_results{1,6}="GA";
    Optimal_results{2,6}(run_time,:)=cg_curve;
    Optimal_results{3,6}(run_time,:)=Best_score;
    Optimal_results{4,6}(run_time,:)=Best_pos;
   
    pop_index = 1;    
    sele_index = 9;    
    cross_index = 10;   
    mut_index = 8;     
    [Best_score,Best_pos,cg_curve] = RLAEGA(nPop, Max_iter, lb, ub, dim, fobj, pop_index,sele_index,cross_index,mut_index);
    Optimal_results{1,7}="RLAEGA";
    Optimal_results{2,7}(run_time,:)=cg_curve;
    Optimal_results{3,7}(run_time,:)=Best_score;
    Optimal_results{4,7}(run_time,:)=Best_pos;
end           
figure(1);
set(gcf, 'Color', 'w'); % 白色背景
hold on;

% 指定的颜色顺序
colors = [
    0,   1,   0;     % green
    0,   0,   0;     % black
    0,   0,   1;     % blue
    0.5, 0.5, 0.5;   % gray
    1,   0.5, 0;     % orange
    0.1, 0.5, 0.2;
    1,   0,   0      % red
];

for i = 1:size(Optimal_results, 2)
    c = colors(mod(i-1, size(colors,1)) + 1, :);
    %semilogy(Optimal_results{2, i}(end,:),'Linewidth',1.5,'color',c) % 选择收敛曲线对应的一行
    semilogy(mean(Optimal_results{2, i}),'Linewidth',1.5,'color',c) % 选择收敛曲线对应的一行
    hold on
end

% 设置坐标轴风格
ax = gca;
ax.FontName   = 'CMU Serif';
ax.FontSize   = 16;
ax.TickLabelInterpreter = 'latex';
ax.LineWidth  = 1.5;

ax.YScale = 'log';
ax.YAxis.Exponent = 3; % 不自动设置指数
ax.YTickLabelMode = 'auto';  % 允许手动格式化
ax.YRuler.TickLabelFormat = '%.0f';  % 强制科学计数法，e.g., 1e-2 -> 1×10^{-2}


%ax.YAxis.Exponent = 0;
%ax.YAxis.TickLabelFormat = '%.0f';  % 避免每个刻度都写 ×10^x
%ax.YRuler.Exponent = 3;             % 显示为 ×10^3（根据你的数据范围选择）
%ax.YAxis.TickLabelMode = 'auto';  % 自动模式开启时，结合上方设置效果最佳

xlabel('Iterations', ...
      'FontName', 'CMU Serif', 'FontSize', 16, 'Interpreter', 'latex');
ylabel(['Function value F', num2str(Function_name)], ...
      'FontName', 'CMU Serif', 'FontSize', 16, 'Interpreter', 'latex');

title(['Benchmark Function: F', num2str(Function_name)], ...
      'FontName', 'CMU Serif', 'FontSize', 16, 'Interpreter', 'latex');

xlim([0 Max_iter]);
grid on; box on;

% 添加 legend
lg = legend(Optimal_results(1,:), ...
    'Interpreter','latex', ...
    'FontName','CMU Serif', ...
    'FontSize',14, ...
    'Location','northeast');
set(lg, 'Color', 'w');

% 设置图窗大小
set(gcf, 'Position', [100 100 600 400]);
hold off;
%% ———— 计算并保存平均值和标准差 ————
nAlgs = size(Optimal_results, 2);
mean_scores = zeros(1, nAlgs);
var_scores  = zeros(1, nAlgs);

for i = 1:nAlgs
    % 提取第 i 个算法所有 run 的最优值 (1×run_times)
    scores = Optimal_results{3, i};
    % 计算
    mean_scores(i) = mean(scores);
    var_scores(i)  = std(scores, 1);   % 用 1/N 求方差，也可以用 var(scores) 默认 N-1
    % 存回 Optimal_results：
    Optimal_results{5, i} = mean_scores(i);
    Optimal_results{6, i} = var_scores(i);
end

%% ———— 打印汇总表 ————
alg_names   = Optimal_results(1, :)';
mean_scores = mean_scores'; 
var_scores  = var_scores';

T = table(alg_names, mean_scores, var_scores, ...
    'VariableNames', {'Algorithm', 'MeanBestScore', 'VarBestScore'});
disp(T);

