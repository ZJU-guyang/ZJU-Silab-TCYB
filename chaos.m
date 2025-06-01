function O=chaos(index,Initial_Value,N)
% 初始值 Initial_Value 可以选择0和1之间的任意数字 (或-1和1 , 取决于混沌映射的范围)
% 但是，需要注意的是，初始值可能会对某些混沌图的波动模式产生重大影响
% O=zeros(1,N);
x(1)=Initial_Value;
switch index
    %Chebyshev map
    case 1
        a=4;
        for i=1:N
            x(i+1)=cos(a*acos(x(i)));
        end
    case 2
        % Gauss/mouse map
        for i=1:N
            if x(i)==0
                x(i+1)=0;
            else
                x(i+1)=mod(1/x(i),1);
            end
        end
    case 3
        % Logistic map
        a=4;
        for i=1:N
            x(i+1)=a*x(i)*(1-x(i));
        end
    case 4
        % Piecewise map
        P=0.4;
        for i=1:N
            if x(i)>=0 && x(i)<P
                x(i+1)=x(i)/P;
            end
            if x(i)>=P && x(i)<0.5
                x(i+1)=(x(i)-P)/(0.5-P);
            end
            if x(i)>=0.5 && x(i)<1-P
                x(i+1)=(1-P-x(i))/(0.5-P);
            end
            if x(i)>=1-P && x(i)<=1
                x(i+1)=(1-x(i))/P;
            end
        end
    case 4
       % Singer map
        u=1.07;
        for i=1:N
            x(i+1) = u*(7.86*x(i)-23.31*(x(i)^2)+28.75*(x(i)^3)-13.302875*(x(i)^4));
        end
    case 5
       % Sinusoidal map
        for i=1:N
            x(i+1) = 2.3*x(i)^2*sin(pi*x(i));
        end
    case 6
        % Tent map
%                 x(1)=0.6;
        for i=1:N
            if x(i)<0.7
                x(i+1)=x(i)/0.7;
            end
            if x(i)>=0.7
                x(i+1)=(10/3)*(1-x(i));
            end

        end
    case 7
        % SPM map
        eta=0.4;
        u=0.3;
        for i=1:N
            if x(i)>=0 && x(i)<eta
                x(i+1)=mod(x(i)/eta+u*sin(pi*x(i))+rand,1);
            end
            if x(i)>=eta && x(i)<0.5
                x(i+1)=mod((x(i)/eta)/(0.5-eta)+u*sin(pi*x(i))+rand,1);
            end
            if x(i)>=0.5 && x(i)<1-eta
                x(i+1)=mod(((1-x(i))/eta)/(0.5-eta)+u*sin(pi*(1-x(i)))+rand,1);
            end
            if x(i)>=1-eta && x(i)<1
                x(i+1)=mod((1-x(i))/eta+u*sin(pi*(1-x(i)))+rand,1);
            end
        end

    case 8
        % ICMIC map
        a =4;
        for i=1:N
             x(i+1) = sin(a/x(i));            
        end
    case 9
        %Tent-Logistic-Cosine map
        r=rand; % 0~1
        for i=1:N
            if x(i)<0.5
                x(i+1)=cos(pi*(2*r*x(i)+4*(1-r)*x(i)*(1-x(i))-0.5));
            else
                x(i+1)=cos(pi*(2*r*(1-x(i))+4*(1-r)*x(i)*(1-x(i))-0.5));
            end
        end
    case 10
        %Sine-Tent-Cosine map
        r=rand; % 0~1
        for i=1:N
            if x(i)<0.5
                x(i+1)=cos(pi*(r*sin(pi*x(i))+2*(1-r)*x(i)-0.5));
            else
                x(i+1)=cos(pi*(r*sin(pi*x(i))+2*(1-r)*(1-x(i))-0.5));
            end
        end
    case 11
        %Logistic-Sine-Cosine map
        r=rand; % 0~1
        for i=1:N
            x(i+1)=cos(pi*(4*r*x(i)*(1-x(i))+(1-r)*sin(pi*x(i))-0.5));
        end    
end
O=x(1:N);
end
