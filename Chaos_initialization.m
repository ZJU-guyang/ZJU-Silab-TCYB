% This function initialize the first population of search agents
%% ��ע΢�Ź��ںţ��Ż��㷨��   Swarm-Opti
% https://mbd.pub/o/author-a2mVmGpsYw==
function Positions=Chaos_initialization(SearchAgents_no,dim,ub,lb,index)
% index ����ѡ���Ӧ�Ļ��纯�� 
lb=lb.*ones(1,dim);
ub=ub.*ones(1,dim);

for  i=1:dim
    ub_i=ub(i);
    lb_i=lb(i);
    chaos_value= chaos(index,rand(1),SearchAgents_no); % ���ɻ���ֵ
    if index==17 % henon ӳ���ڣ�-1.5��1.5������Ϊ���⣬���chaos.m�������henon ӳ�����ţ�����ҲҪһ���޸�
        chaos_value = mapminmax(chaos_value,0,1); % �����˹�һ������
        Positions(:,i)=chaos_value.*(ub_i-lb_i)+lb_i;
    else        
        Positions(:,i)=abs(chaos_value).*(ub_i-lb_i)+lb_i;
    end
    
end