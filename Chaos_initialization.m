%Copyright (c) 2025 Yang Gu

%This code is provided for academic and non-commercial research purposes only.
%Use, reproduction, or modification of this code for commercial purposes is prohibited without explicit written permission.

%If you use this code in your work, please cite the following paper:
%"Joint Time and Energy Efficient Routing Optimisation Framework for Offshore Wind Farm Inspection Using an Unmanned Surface Vehicles", IEEE Transactions on Cybernetics, under review.
%Contact: yanggu[at]zju.edu.cn

function Positions=Chaos_initialization(SearchAgents_no,dim,ub,lb,index)
% index 用于选择对应的混沌函数 
lb=lb.*ones(1,dim);
ub=ub.*ones(1,dim);

for  i=1:dim
    ub_i=ub(i);
    lb_i=lb(i);
    chaos_value= chaos(index,rand(1),SearchAgents_no); % 生成混沌值
    if index==17 % henon 映射在（-1.5，1.5），较为特殊，如果chaos.m里更改了henon 映射的序号，这里也要一起修改
        chaos_value = mapminmax(chaos_value,0,1); % 采用了归一化处理
        Positions(:,i)=chaos_value.*(ub_i-lb_i)+lb_i;
    else        
        Positions(:,i)=abs(chaos_value).*(ub_i-lb_i)+lb_i;
    end
    
end
