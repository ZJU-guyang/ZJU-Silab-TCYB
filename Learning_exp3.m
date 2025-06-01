% runExp3GA.m
clear; clc;
%% ———— 问题定义 ————
dim           = 20;
Function_name = 1;
[lb,ub,dim,fobj] = Get_Functions_cec2022(Function_name,dim);

nPop      = 20;
Max_iter  = 1000;     % GA 内部迭代次数
T_trials  = 3000;     % Exp3 总轮数

%% ———— Exp3 参数 ————
gamma      = 0.1;    % 探索参数
% 各类算子可选编号
K_pop      = 10;
K_sel      = 10;
K_cross    = 10;
K_mut      = 10;

% 多次运行 GA 的次数
run_times  = 20;

% 初始权重
w_pop   = ones(K_pop,1);
w_sel   = ones(K_sel,1);
w_cross = ones(K_cross,1);
w_mut   = ones(K_mut,1);

% 记录历史
history = struct('pop',[],'sel',[],'cr',[],'mut',[],'score',[]);

for t = 1:T_trials
    %—— 1. 归一化成概率分布 —————————
    p_pop   = (1-gamma)*(w_pop/sum(w_pop))   + gamma/K_pop;
    p_sel   = (1-gamma)*(w_sel/sum(w_sel))   + gamma/K_sel;
    p_cross = (1-gamma)*(w_cross/sum(w_cross)) + gamma/K_cross;
    p_mut   = (1-gamma)*(w_mut/sum(w_mut))   + gamma/K_mut;
    
    %—— 2. 按概率采样算子编号 —————————
    pop_index   = randsample(K_pop,1,true,p_pop);
    sele_index  = randsample(K_sel,1,true,p_sel);
    cross_index = randsample(K_cross,1,true,p_cross);
    mut_index   = randsample(K_mut,1,true,p_mut);
    
    %—— 3. 多次运行 GA 并求平均最优 —————————
    scores = zeros(run_times,1);
    for i = 1:run_times
        [Best_score, ~, ~] = RLSGA( ...
            nPop, Max_iter, lb, ub, dim, fobj, ...
            pop_index, sele_index, cross_index, mut_index );
        scores(i) = Best_score;
    end
    avgScore = mean(scores);
    
    %—— 4. 计算奖励（GA 最小化，故反向映射）—————
    reward = 1 / (1 + avgScore);
    
    %—— 5. Exp3 权重更新 ——————————————
    w_pop(pop_index) = w_pop(pop_index) * ...
        exp( gamma * (reward / p_pop(pop_index)) / K_pop );
    w_sel(sele_index) = w_sel(sele_index) * ...
        exp( gamma * (reward / p_sel(sele_index)) / K_sel );
    w_cross(cross_index) = w_cross(cross_index) * ...
        exp( gamma * (reward / p_cross(cross_index)) / K_cross );
    w_mut(mut_index) = w_mut(mut_index) * ...
        exp( gamma * (reward / p_mut(mut_index)) / K_mut );
    
    %—— 6. 记录历史 ———————————————
    history(t).pop   = pop_index;
    history(t).sel   = sele_index;
    history(t).cr    = cross_index;
    history(t).mut   = mut_index;
    history(t).score = avgScore;
    
    fprintf('Trial %3d: pop=%d sel=%d cr=%d mut=%d  avgBest=%.4e\n', ...
            t, pop_index, sele_index, cross_index, mut_index, avgScore);
end

%% ———— 最终推荐 ————
[~,bestTrials] = sort([history.score]);
best = history(bestTrials(1));
fprintf('\n推荐的最佳组合： init=%d, sel=%d, cross=%d, mut=%d, avgScore=%.4e\n', ...
        best.pop, best.sel, best.cr, best.mut, best.score);
