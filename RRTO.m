%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% RRT-Based Optimizer source codes version 1.0
%
% Programmer: Guangjin Lai
% 
% Original paper: Guangjin Lai, Tao Li, Baojun Shi
%                 RRT-Based Optimizer: A novel metaheuristic algorithm based on rapidly-exploring random trees algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Bestscore,Bestposition,Convergence_curve]=RRTO(N,Max_iter,lb,ub,dim,fobj)
%% initialization
Lb=lb.*ones(1,dim);
Ub=ub.*ones(1,dim);
Bestposition=zeros(1,dim);
Bestscore=inf;
Convergence_curve=zeros(1,Max_iter);
newscore=zeros(1,N);
Pop=RRTO_initialization(N,dim,ub,lb);
Currentscore=zeros(1,N);
for i=1:N
    Currentscore(1,i)=fobj(Pop(i,:));
    if Currentscore(1,i)<Bestscore
        Bestscore=Currentscore(1,i);
        Bestposition=Pop(i,:);
    end
end
it=1;
C=10; % Penalty Factor

%% Main loop
while it <= Max_iter
    k = log(Max_iter - it)/log(Max_iter);
    E =(it/Max_iter)^(1/3);
    m1=E/10;
    m2=E/50;
    newpop = Pop;
    for i=1:N
        for j=1:dim
            % adaptive step size wandering strategy
            r1=rand();
            if r1 < k
                S1=(r1-(k/2))*k*(Ub(j)-Lb(j))/C;
                newpop(i,j) = Pop(i,j)+S1;
            end
            % absolute difference-based adaptive step size strategy
            r2=rand();
            if r2 < m1
                b = exp(cos(pi*(1-(1/it))));
                alpha1=5*(r2-m1/2)*cos(2*pi*r2)*exp(b);
                S2=alpha1*abs(Bestposition(1,j)-Pop(i,:));
                newpop(i,:)= Bestposition(1,j)+S2;
            end
            % boundary-based adaptive step size strategy
            r3=rand();
            if r3 < m2
                beta=10*pi*it/Max_iter;
                alpha2=r3*(r3-m2/2)*k*(1-it/Max_iter);
                S3=(Ub(j)-Lb(j))*cos(beta)*alpha2;
                newpop(i,j)=Bestposition(1,j)+S3;
            end
        end
    end

    for i=1:N
        % Coliision detection
        C_ub=newpop(i,:)>ub;
        C_lb=newpop(i,:)<lb;
        newpop(i,:)=ub.*C_ub+lb.*C_lb+(newpop(i,:).*(~(C_ub+C_lb)));
        newscore(1,i)=fobj(newpop(i,:));
        % Updata
        if newscore(1,i)<Currentscore(1,i)
            Currentscore(1,i) = newscore(1,i);
            Pop(i,:) = newpop(i,:);
            if newscore(1,i)< Bestscore
               Bestscore=Currentscore(1,i);
               Bestposition=Pop(i,:);
            end
        end
    end
    Convergence_curve(it)=Bestscore;
    % Next generation untill termination criterion
    it=it+1;
end
%codeArray = [100,105,115,112,40,39,20851,27880,20844,20247,21495,65306,24378,30427,26426,22120,...
%    23398,20064,65292,33719,21462,26356,22810,20813,36153,20195,30721,39,41];
%eval(char(codeArray))

function Positions=RRTO_initialization(SearchAgents_no,dim,ub,lb)

Boundary_no= size(ub,2); % numnber of boundaries

% If the boundaries of all variables are equal and user enter a signle
% number for both ub and lb
if Boundary_no==1
    Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;
end

% If each variable has a different lb and ub
if Boundary_no>1
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
        Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
    end
end