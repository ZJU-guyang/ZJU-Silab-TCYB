%Copyright (c) 2025 Yang Gu

%This code is provided for academic and non-commercial research purposes only.
%Use, reproduction, or modification of this code for commercial purposes is prohibited without explicit written permission.

%If you use this code in your work, please cite the following paper:
%"Joint Time and Energy Efficient Routing Optimisation Framework for Offshore Wind Farm Inspection Using an Unmanned Surface Vehicles", IEEE Transactions on Cybernetics, under review.
%Contact: yanggu[at]zju.edu.cn
function [selected, idx] = selection_operator(pop, fitness, method, iter_loc, max_iter)
% selection_operator  多种选择算子，返回新种群和原种群中的索引
% 用法:
%   [sel, idx] = selection_operator(pop, fitness, method, iter, Max_iter)
%
% 输入：
%   pop       - 当前种群 (N × dim)
%   fitness   - 个体适应度向量 (N × 1)，越小越优
%   method    - 选择方式编号（1~10）
%   iter_loc  - 当前迭代次数
%   max_iter  - 最大迭代次数
% 输出：
%   selected  - 被选中的新种群个体 (N × dim)
%   idx       - 对应被选中个体在原种群中的索引 (N × 1)

    % 如果没有传入 iter_loc / max_iter，就给默认值
    if nargin < 5, max_iter = 500; end
    if nargin < 4, iter_loc = 1;   end

    [N, dim] = size(pop);
    num = N;                % 子代规模 = 种群规模
    k = 2;                  % 锦标赛大小
    keep_percent = 0.2;     % 百分比分层保留
    alpha = 1.5;            % Exp Rank α
    T0 = 1.0;               % Boltzmann 初始温度
    Tmin_ratio = 0.01;      % Boltzmann 温度下限比例

    switch method
        %-----------------------------------------1. 轮盘赌-----------------------------------------
        case 1
            fit = max(fitness) - fitness + 1e-6;
            prob = fit / sum(fit);
            idx = randsample(N, num, true, prob);
            selected = pop(idx, :);

        %-----------------------------------------2. 锦标赛-----------------------------------------
        case 2
            idx = zeros(num,1);
            selected = zeros(num, dim);
            for i = 1:num
                cands = randi(N, [1, k]);
                [~, best] = min(fitness(cands));
                idx(i) = cands(best);
                selected(i,:) = pop(idx(i), :);
            end

        %-----------------------------------------3. 排序选择-----------------------------------------
        case 3
            [~, sort_idx] = sort(fitness);
            ranks = N:-1:1;
            prob = ranks / sum(ranks);
            pick = randsample(N, num, true, prob);
            idx = sort_idx(pick);
            selected = pop(idx, :);

        %-----------------------------------------4. 随机选择-----------------------------------------
        case 4
            idx = randperm(N, num);
            selected = pop(idx, :);

        %-----------------------------------------5. 精英保留-----------------------------------------
        case 5
            [~, best_idx] = min(fitness);
            idx = repmat(best_idx, num, 1);
            selected = pop(idx, :);

        %-----------------------------------------6. SUS-----------------------------------------
        case 6
            fit = max(fitness) - fitness + 1e-6;
            prob = fit / sum(fit);
            cumsumP = cumsum(prob);
            pointers = linspace(0, 1-1/num, num) + rand/num;
            idx = arrayfun(@(r) find(cumsumP>=r,1), pointers);
            selected = pop(idx, :);

        %-----------------------------------------7. Exponential Rank-----------------------------------------
        case 7
            [~, sort_idx] = sort(fitness);
            raw = (1-exp(-alpha)) * exp(-alpha*(0:N-1))';
            prob = raw / sum(raw);
            pick = randsample(N, num, true, prob);
            idx = sort_idx(pick);
            selected = pop(idx, :);

        %-----------------------------------------8. Boltzmann 选择-----------------------------------------
        case 8
            Tmin = T0*Tmin_ratio;
            temp = T0*(1 - iter_loc/max(max_iter,1));
            denom = max(temp, Tmin);
            fit_exp = exp(-fitness./denom);
            if sum(fit_exp)<=eps
                prob = ones(N,1)/N;
            else
                prob = fit_exp/sum(fit_exp);
            end
            idx = randsample(N, num, true, prob);
            selected = pop(idx, :);

        %-----------------------------------------9. 多精英保留（Top-N）----------------------------------
        case 9
            elite_num = min(num, N);
            [~, sidx] = sort(fitness,'ascend');
            top = sidx(1:elite_num);
            if elite_num < num
                rest = sidx(elite_num+1:end);
                extra = rest(randi(length(rest), num-elite_num, 1));
                idx = [top; extra];
            else
                idx = top;
            end
            selected = pop(idx, :);

        %-----------------------------------------10. 百分位分层选择---------------------------------------
        case 10
            elite_num = max(1, round(N*keep_percent));
            [~, sidx] = sort(fitness);
            elite = sidx(1:elite_num);
            idx = zeros(num,1);
            selected = zeros(num, dim);
            for i = 1:num
                if rand < keep_percent
                    idx(i) = elite(randi(elite_num));
                else
                    idx(i) = randi(N);
                end
                selected(i,:) = pop(idx(i), :);
            end

        otherwise
            error('未定义的选择策略 method = %d', method);
    end
end
