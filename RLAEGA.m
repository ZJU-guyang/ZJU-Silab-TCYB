function [Best_score, Best_pos, cg_curve] = RLAEGA(nPop, Max_iter, lb, ub, dim, fobj, pop_index,sele_index,cross_index,mut_index)
%GA 遗传算法求解框架（调用 mutations_operator 做变异）
%
% 输入：
%   nPop, Max_iter, lb, ub, dim, fobj — 同前
% 输出：
%   Best_score, Best_pos, cg_curve — 同前

    %% 参数
    Pc         = 0.9;      % 交叉概率
    %pop_index  = 5;        % 种群算子编号
    %sele_index = 10;       % 选择算子编号
    %cross_index= 1;        % 交叉算子编号
    %mut_index  = 1;        % 变异算子编号

    %% 1. 初始化种群
    pop = Chaos_initialization(nPop, dim, ub, lb, pop_index);

    %% 2. 评估初始种群
    fitness = arrayfun(@(i) fobj(pop(i,:)), (1:nPop)') ;

    %% 记录全局最优
    [Best_score, bestIdx] = min(fitness);
    Best_pos = pop(bestIdx,:);
    cg_curve = zeros(Max_iter+1,1);
    cg_curve(1) = Best_score;

    %% 3. 迭代主循环
    for iter = 1:Max_iter
        %—— 3.1 选择 ——————————————
        [matingPool, ~] = selection_operator(pop, fitness, sele_index, iter, Max_iter);

        %—— 3.2 交叉 ——————————————
        offspring = zeros(nPop, dim);
        perm = randperm(nPop);
        for k = 1:2:nPop
            p1 = matingPool(perm(k), :);
            p2 = matingPool(perm(k+1), :);
            if rand < Pc
                offspring(k,   :) = crossover_operator(p1, p2, cross_index, iter, Max_iter, lb, ub);
                offspring(k+1, :) = crossover_operator(p2, p1, cross_index, iter, Max_iter, lb, ub);
            else
                offspring(k,   :) = p1;
                offspring(k+1, :) = p2;
            end
        end

        %—— 3.3 变异（调用 mutations_operator） ——————————
        mutants = zeros(nPop, dim);
        for i = 1:nPop
            % x_all 传入当前子代集合 offspring
            mutants(i,:) = mutations_operator( ...
                offspring(i,:), ...   % x
                offspring, ...        % x_all
                Best_pos, ...         % xbest
                lb, ub, dim, ...      
                iter, Max_iter, ...
                mut_index);           % index
        end

        %—— 3.4 评估新一代 ——————————————
        newFitness = arrayfun(@(i) fobj(mutants(i,:)), (1:nPop)') ;

        %—— 3.5 精英保留环境选择 ——————————
        allPop     = [pop;    mutants];
        allFitness = [fitness; newFitness];
        [allFitness, order] = sort(allFitness);
        pop     = allPop(order(1:nPop), :);
        fitness = allFitness(1:nPop);

        % 更新全局最优
        if fitness(1) < Best_score
            Best_score = fitness(1);
            Best_pos   = pop(1,:);
        end
        cg_curve(iter+1) = Best_score;
    end
end
