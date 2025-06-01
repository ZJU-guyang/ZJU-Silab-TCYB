%Copyright (c) 2025 Yang Gu

%This code is provided for academic and non-commercial research purposes only.
%Use, reproduction, or modification of this code for commercial purposes is prohibited without explicit written permission.

%If you use this code in your work, please cite the following paper:
%"Joint Time and Energy Efficient Routing Optimisation Framework for Offshore Wind Farm Inspection Using an Unmanned Surface Vehicles", IEEE Transactions on Cybernetics, under review.
%Contact: yanggu[at]zju.edu.cn
function mx=mutations_operator(x,x_all,xbest,lb,ub,dim,iter,max_iter,index)
% 输入：
% x        变异前的个体，一维
% x_all   所有个体
%xbest  最优个体，一维
% lb       变量的下界
% ub      变量的上界
% dim    变量维度
% iter     当前迭代
% max_iter 最大迭代次数
% index  用于选择变异策略
% 输出：
% mx     变异后的个体

% 变异策略种的参数 可根据需求修改

lb=lb.*ones(1,dim);
ub=ub.*ones(1,dim);

switch index
    
    %-----------------------------------------高斯变异---------------------------------------------------
    case 1
        p=0.5; % 选择概率
        if rand>p
            mu=(lb+ub)/2; % 高斯函数的均值，按需修改
            sigma=(ub-lb)/6; % 高斯函数的方差，按需修改
            mx=normrnd(mu,sigma);  % % 高斯函数生成数值
        else
            mx=x;
        end
        % 边界检查，防止超出 变量范围
        Flag4ub=mx>ub;
        Flag4lb=mx<lb;
        mx=(mx.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        %-----------------------------------------高斯精英变异---------------------------------------------
    case 2
        p=0.5; % 选择概率
        if rand>p
            mu=xbest; % 以最优解 作为高斯函数的均值
            sigma=(ub-lb)./6; % 按需修改
            r=normrnd(mu,sigma);  % % 高斯函数生成数值
            mx=r.*x; % 变异后的个体
        else
            mx=x;
        end
        % 边界检查，防止超出 变量范围
        Flag4ub=mx>ub;
        Flag4lb=mx<lb;
        mx=(mx.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        %-----------------------------------------柯西变异---------------------------------------------------
    case 3
        p=0.5; % 选择概率
        if rand>p
            mu=0; % 以最优解 和 当前解 作为高斯函数的均值
            sigma=1; % 按需修改
            r=(sigma./((x-mu).^2+sigma^2))/pi;% 柯西分布的概率密度函数生成数值
            mx=xbest+r.*xbest; % 以 xbest最优解作为参考 获取变异后的个体
            %         mx=x+r.*x; % 还可以以 x 作为参考 获取变异后的个体
        else
            mx=x;
        end
        % 边界检查，防止超出 变量范围
        Flag4ub=mx>ub;
        Flag4lb=mx<lb;
        mx=(mx.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        %-----------------------------------------柯西逆累计分布变异-------------------------------------
    case 4
        p=0.5; % 选择概率
        if rand>p
            a=0; %
            b=1; %
            rp=randn(1,dim);%
            mx=a+b*tan(pi*(rp-1/2)); %柯西逆累计分布函数生成数值
        else
            mx=x;
        end
        % 边界检查，防止超出 变量范围
        Flag4ub=mx>ub;
        Flag4lb=mx<lb;
        mx=(mx.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        %-----------------------------------------t分布变异-------------------------------------
    case 5
        p=0.5; % 选择概率
        if rand>p
            mx=xbest+xbest.*trnd(iter); % 以 xbest 最优解作为参考 获取变异后的个体
            %             mx=x+x.*trnd(iter); % 以 x 作为参考 获取变异后的个体
        else
            mx=x;
        end
        % 边界检查，防止超出 变量范围
        Flag4ub=mx>ub;
        Flag4lb=mx<lb;
        mx=(mx.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        %-----------------------------------------自适应t分布变异-------------------------------------
    case 6
        % 使用算法的迭代次数 作为t分布的自由度参数
        p=0.5; % 选择概率
        tf = exp((iter/max_iter)^2); % 自由度参数 随迭代次数 呈非线性增长
        % 注意：这里只简单举例了非线性公式用法，非线性公式有很多，可以自由创作
        if rand>p
            mx=xbest+xbest.*trnd(tf); % 以 xbest 最优解作为参考 获取变异后的个体
            %             mx=x+x.*trnd(tf); % 以 x 作为参考 获取变异后的个体
        else
            mx=x;
        end
        % 边界检查，防止超出 变量范围
        Flag4ub=mx>ub;
        Flag4lb=mx<lb;
        mx=(mx.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        %-----------------------------------------正态云变异-------------------------------------
        % 参考文献：张铸,姜金美,张小平.改进灰狼优化算法的永磁同步电机多参数辨识[J].电机与控制学报,2022,26(10):119-129.
    case 7
        
        p=0.5; % 选择概率
        Ex=xbest;               %正态云期望
        En=exp(iter/max_iter);   %正态云熵
        He=En/10^(-3);      %正态云超熵
        if rand>p
            E_n = normrnd(En,He); % 生成正态分布随机数
            ra= normrnd(Ex,abs(E_n)); % 生成正态随机数
            mx=exp(-(ra-Ex).^2/(2*E_n^2)); % 计算隶属度函数
        else
            mx=x;
        end
        % 边界检查，防止超出 变量范围
        Flag4ub=mx>ub;
        Flag4lb=mx<lb;
        mx=(mx.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        %-----------------------------------------周期变异-------------------------------------
        % 参考文献：DOI： 10.1109/TEVC.2012.2196047
    case 8
        
        A=1; % 变异幅度
        AT=5; % 变异周期
        if mod(iter,AT)==0
            mx=x.*(1+A*(0.5-rand(1,dim)));
        else
            mx=x;
        end
        % 边界检查，防止超出 变量范围
        Flag4ub=mx>ub;
        Flag4lb=mx<lb;
        mx=(mx.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        %-----------------------------------------DE/best/1-------------------------------------
    case 9
        
        p=0.5; % 选择概率
        F=rand; % 缩放因子,rand函数随机生成
        npop = size(x_all,1); % 种群数
        if rand>p
            mx=xbest+F*(x_all(randi(npop),:)-x_all(randi(npop),:));
        else
            mx=x;
        end
        % 边界检查，防止超出 变量范围
        Flag4ub=mx>ub;
        Flag4lb=mx<lb;
        mx=(mx.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;        
        
         %-----------------------------------------DE/rand-to-best/1-------------------------------------
    case 10
        
        p=0.5; % 选择概率
        F=rand; % 缩放因子,rand函数随机生成
        npop = size(x_all,1); % 种群数
        if rand>p
            mx=x+F*(xbest-x)+F*(x_all(randi(npop),:)-x_all(randi(npop),:));
        else
            mx=x;
        end
        % 边界检查，防止超出 变量范围
        Flag4ub=mx>ub;
        Flag4lb=mx<lb;
        mx=(mx.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;                  
end
