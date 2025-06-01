%  Superb Fairy-wren Optimization Algorithm: a novel metaheuristic algorithm for solving feature selection problems(SFOA)
%
%  Source codes demo version 1.0                                                                      
%                                                                                                     
%  The 11th Gen Intel(R) Core(TM) i7-11700 processor with the primary frequency of 2.50GHz, 16GB memory, and the operating system of 64-bit windows 11 using matlab2021a.                                                                
%                                                                                                     
%  Author and programmer: Heming Jia,Xuelian Zhou,Jinrui Zhang,Seyedali Mirjalili                                                                          
%         e-Mail: jiaheminglucky99@126.com;lianlianz66@163.com                                                                                                                                                                                                                                                                                                     
%                                   
%                                                                                                                                                   
%_______________________________________________________________________________________________
% You can simply define your cost function in a seperate file and load its handle to fobj 
% The initial parameters that you need are:
%__________________________________________
% fobj = @YourCostFunction
% dim = number of your variables
% T = maximum number of iterations
% N = number of search agents
% lb=[lb1,lb2,...,lbn] where lbn is the lower bound of variable n
% ub=[ub1,ub2,...,ubn] where ubn is the upper bound of variable n
% If all the variables have equal lower bound you can just
% define lb and ub as two single numbers
function[best_fitness,best_position,curve]=SFOA(N,MaxFEs,lb,ub,dim,fobj)
curve=zeros(1,MaxFEs);
X=initialization(N,dim,ub,lb);
Xnew=zeros(N,dim);
best_fitness = inf;
best_position = zeros(1,dim);
fitness=zeros(1,N);
FEs=1;
LB=ones(1,dim).*(lb);             % Lower limit for variables
UB=ones(1,dim).*(ub);             % Upper limit for variables
for i=1:N
    fitness(i)=fobj(X(i,:));
    if fitness(i)<best_fitness
        best_fitness=fitness(i);
        best_position=X(i,:);
    end
    FEs=FEs+1;
    curve(FEs)=best_fitness;
end

while(FEs<=MaxFEs)
    C=0.8;
    r1=rand;
    r2=rand;
    w=(pi/2)*(FEs/MaxFEs);
    k=0.2*sin(pi/2-w);
    l=0.5*levy(N,dim,1.5);
    y=randi(N);
    c1=rand;
    T=0.5;
    m=FEs/MaxFEs*2;
    p = sin(UB-LB)*2+(UB-LB)*m;
    Xb=best_position;
    XG=best_position*C;
    for i=1:N
        if T<c1
            Xnew(i,:)=X(i,:)+(LB+(UB-LB).*rand(1,dim));
        else
            s=r1*20+r2*20;
            if s>20
                Xnew(i,:)=Xb+X(i,:).*l(y,:)*k;
            else
                Xnew(i,:)=XG+(Xb-X(i,:)).*(p);
            end
        end
    end
    X=Xnew;
    for i=1:N
        Xnew(i,:) = max( Xnew(i,:),lb);
        Xnew(i,:) = min( Xnew(i,:),ub);
        fitness(i)=fobj(Xnew(i,:));
        if fitness(i)<best_fitness
            best_fitness=fitness(i);
            best_position=Xnew(i,:);
        end
        FEs=FEs+1;
        curve(FEs)=best_fitness;
        if FEs>=MaxFEs
            break;
        end
    end
    if FEs>=MaxFEs
        break;
    end
    
end

end

function X=initialization(N,Dim,UB,LB)

B_no= size(UB,2); % numnber of boundaries

if B_no==1
    X=rand(N,Dim).*(UB-LB)+LB;
end

% If each variable has a different lb and ub
if B_no>1
    for i=1:Dim
        Ub_i=UB(i);
        Lb_i=LB(i);
        X(:,i)=rand(N,1).*(Ub_i-Lb_i)+Lb_i;
    end
end
end

function [z] = levy(n,m,beta)

    num = gamma(1+beta)*sin(pi*beta/2); % used for Numerator 
    den = gamma((1+beta)/2)*beta*2^((beta-1)/2); % used for Denominator
    sigma_u = (num/den)^(1/beta);% Standard deviation

    u = random('Normal',0,sigma_u,n,m); 
    
    v = random('Normal',0,1,n,m);

    z =u./(abs(v).^(1/beta));

  
  end
