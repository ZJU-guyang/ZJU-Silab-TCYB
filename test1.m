clc; clear; close all
%% 基本参数
nPop = 20;              % 种群规模
Max_iter = 1000;        % 最大迭代次数
dim = 20;               % 维度（CEC2022函数：2,10,20）
run_times = 20;         % 算法总运行次数
Function_name = 1;
[lb, ub, dim, fobj] = Get_Functions_cec2022(Function_name, dim);

%% 调用算法部分
Optimal_results = cell(5, 6);  % 额外增加一行用于保存策略组合编号

for run_time = 1:run_times
    % ===== 前五组：随机组合策略 =====
    for i = 1:5
        pop_index   = randi([1, 10]);
        sele_index  = randi([1, 10]);
        cross_index = randi([1, 10]);
        mut_index   = randi([1, 10]);

        [Best_score, Best_pos, cg_curve] = RLAEGA(nPop, Max_iter, lb, ub, dim, fobj, ...
                                                  pop_index, sele_index, cross_index, mut_index);

        Optimal_results{1,i} = sprintf("GA-randomised strategies %d", i);
        Optimal_results{2,i}(run_time,:) = cg_curve;
        Optimal_results{3,i}(run_time,:) = Best_score;
        Optimal_results{4,i}(run_time,:) = Best_pos;
        Optimal_results{5,i}(run_time,:) = [pop_index, sele_index, cross_index, mut_index];  % 记录策略组合
    end

    % ===== 第六组：固定“最优组合” =====
    pop_index   = 4;
    sele_index  = 4;
    cross_index = 10;
    mut_index   = 8;

    [Best_score, Best_pos, cg_curve] = RLAEGA(nPop, Max_iter, lb, ub, dim, fobj, ...
                                              pop_index, sele_index, cross_index, mut_index);

    Optimal_results{1,6} = "GA-optimal strategies";
    Optimal_results{2,6}(run_time,:) = cg_curve;
    Optimal_results{3,6}(run_time,:) = Best_score;
    Optimal_results{4,6}(run_time,:) = Best_pos;
    Optimal_results{5,6}(run_time,:) = [pop_index, sele_index, cross_index, mut_index];  % 固定策略也记录
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
    %0.1, 0.5, 0.2;
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
% %% ———— 计算并保存平均值和方差 ————
% nAlgs = size(Optimal_results, 2);
% mean_scores = zeros(1, nAlgs);
% var_scores  = zeros(1, nAlgs);
% 
% for i = 1:nAlgs
%     % 提取第 i 个算法所有 run 的最优值 (1×run_times)
%     scores = Optimal_results{3, i};
%     % 计算
%     mean_scores(i) = mean(scores);
%     var_scores(i)  = std(scores, 1);   % 用 1/N 求方差，也可以用 var(scores) 默认 N-1
%     % 存回 Optimal_results：
%     Optimal_results{5, i} = mean_scores(i);
%     Optimal_results{6, i} = var_scores(i);
% end
% 
% %% ———— 打印汇总表 ————
% alg_names   = Optimal_results(1, :)';
% mean_scores = mean_scores'; 
% var_scores  = var_scores';
% 
% T = table(alg_names, mean_scores, var_scores, ...
%     'VariableNames', {'Algorithm', 'MeanBestScore', 'VarBestScore'});
% disp(T);

