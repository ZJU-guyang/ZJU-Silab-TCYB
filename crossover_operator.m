function child = crossover_operator(parent1, parent2, method, iter_loc, max_iter, lb, ub)
% crossover_operator 多种交叉算子，返回一个子代
% 输入:
%   parent1, parent2 - 父代个体 (1×dim)
%   method           - 交叉策略编号 (1~10)
%   iter_loc         - 当前迭代次数 (可选)
%   max_iter         - 最大迭代次数 (可选)
%   lb, ub           - 决策变量边界 (1×dim) (可选)
% 输出:
%   child            - 生成的子代个体 (1×dim)

    %--- 参数默认值 ---
    if nargin < 4, iter_loc = 1; end  % 当前迭代
    if nargin < 5, max_iter = 500; end % 最大迭代

    dim = numel(parent1);  % 基因长度

    % 读取边界（优先输入参数，其次 base workspace，否则不约束）
    if nargin < 7
        if evalin('base', 'exist(''lb'',''var'')') && evalin('base','exist(''ub'',''var'')')
            lb = evalin('base','lb(:).''');
            ub = evalin('base','ub(:).''');
        else
            lb = -inf(1, dim);
            ub =  inf(1, dim);
        end
    end

    % 默认返回 parent1
    child = parent1;

    switch method
        case 1  % 均匀交叉
            mask = rand(1,dim) > 0.5;
            child(mask) = parent2(mask);

        case 2  % 单点交叉
            cp = randi([1, dim-1]);
            child = [parent1(1:cp), parent2(cp+1:end)];

        case 3  % 两点交叉
            pts = sort(randperm(dim,2));
            child = parent1;
            child(pts(1):pts(2)) = parent2(pts(1):pts(2));

        case 4  % SBX
            eta = 2;
            u = rand(1,dim);
            beta = ((2*u).^(1/(eta+1))).*(u<=0.5) + ((2*(1-u)).^(-1/(eta+1))).*(u>0.5);
            child = 0.5*((1+beta).*parent1 + (1-beta).*parent2);

        case 5  % 算术交叉
            alpha = rand;
            child = alpha*parent1 + (1-alpha)*parent2;

        case 6  % BLX-alpha
            alpha = 0.5;
            mn = min(parent1,parent2);
            mx = max(parent1,parent2);
            rngv = mx - mn;
            child = mn - alpha*rngv + rand(1,dim).*((1+2*alpha).*rngv);

        case 7  % 平均交叉
            child = (parent1 + parent2) / 2;

        case 8  % 线性交叉
            a = rand;
            child = a*parent1 + (1-a)*parent2;

        case 9  % 自适应交叉
            a = iter_loc / max(max_iter,1);
            child = a*parent1 + (1-a)*parent2;

        case 10 % 高斯扰动
            mu    = (parent1 + parent2) / 2;
            sigma = abs(parent1 - parent2) / 2;
            child = mu + sigma .* randn(1,dim);

        otherwise
            warning('未知交叉策略 method = %d，返回 parent1', method);
    end

    % 边界约束
    child = max(min(child, ub), lb);
end
