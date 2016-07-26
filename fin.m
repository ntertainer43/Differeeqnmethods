clc
clear
disp('A program to find temp distribution in fin')
disp('Select the type of fin:\n 1 for constant area \n 2 for conical fin')
choice = input('Your choice : ');

%the inputs
l = input('Enter the length fin');
d = input('Enter the inital diameter');
n = input('Enter the number of divisions you need');
h0 = 2000; %check this one
k = 377; %taken for copper
area = pi*d^2
%beta = input('Enter the value of beta'); %need to change this for formula
h = 1/n;

beta1 = h0/k * (2*(l/3+ 3*area/l))*(l/3)^2/area           %this  beta is for Q.no 4 where l and 3l comparision required


%define function for the A* and dA/dx
if choice == 1   % for the constant cross section fin
    fx = @(x) 1;
    dfdx = @(x) 0;
     beta = @(x) 4*  h0* l^2/(k*d)
     
elseif choice == 2  %for conical fin 
    fx = @(x) (1-x)^2;
    dfdx = @(x) -2*(1-x);
    fx(1)
    beta = @(x) h0/k *(pi*d*(1-x)*l^2)/area        %used P*L = curved surface area for cone
end

beta

%defining the diagonal elements for the given question
i =0;
for j = 1:n
    i = i+h;
    x(j,1) = i;
    d(j,1) = -4*fx(i) - 2*beta(i) * h^2;
    fx(i)
    if ~(i== n)
        u(j,1) = 2*fx(i) + dfdx(i) * h;
        l(j,1) = 2* fx(i+h)- dfdx(i+h) * h;
       
    end
end
d(j,1) = -4*fx(i-.05) - 2*beta(i-.051) * h^2;
l(n-1,1) = 4* fx(1);
b(1,1) = dfdx(0)*h - fx(0)*2 ; b(2:n,1)= 0        % innitial condition to be given here i.e 1
x

%making the augmented matrix for TDMA
for i = 1 : n
    A(i,i)= d(i,1);
    A(i,n+1) = b(i,1);
    if ~(i== n)
        A(i+1,i) = l(i,1);
        A(i,i+1) = u(i,1);end
        
end
A


%Thomas Algorithm
for i = 1:n-1
    A(i,:) = A(i,:)/A(i,i);  %Normalizing
   
    alpha = A(i+1,i);
    A(i+1,:) = A(i+1,:)- A(i,:)*alpha;
end
A
%Back Substitution
y(n,1) = A(n,n+1)/A(n,n);
for i = n-1:-1:1
    y(i,1)= A(i,n+1) - A(i,i+1)*y(i+1,1);
end
y

%analytical calculation for temperature distribution
if choice == 1
temp = cosh(beta(x)^.5*(1-x))/cosh(beta(x)^.5)
plot(x,y,'*',x,temp,'--')               %the plot doesnot give plot at x* = 0 as both give the same answer
legend('computed','analytical')
else
    plot(x,y)
end
xlabel('Non dimensional distance(x/l)')
ylabel('Non dimensional temperature(T/T0)')
title('Temperature distribution in fin')
summ = 0;

%for error calculation
if choice ==1
    for j = 1:n
        temporary = (y(j,1)- temp(j,1))^2;
        summ = summ + temporary;
    end
    error = (summ/n)^.5
end

conti = input('Press any key to continue');
%rate of heat dissipation calcution
if choice == 2
    temp = cosh((beta1)^.5*(1-x))/cosh((beta1)^.5)
    for i = 1: n-1
        %numerical differentiation interpolation type more accurate in 
        %smaller h
        Tslope(i,1) = (y(i+1)-y(i))/(x(i+1)-x(i));
        Tslope2(i,1) = (temp(i+1)- temp(i))/(x(i+1)-x(i));
        
        %heat dissipation through conduction only done
        %need to check properly
        fx(x(i));
        heatdisp(i,1) = -k*fx(x(i))* Tslope(i,1);
        heatdisp2(i,1) = -k*Tslope2(i,1);
    end
    %at x =1 rate=0 as dt/dx is 0
    heatdisp(n,1)= 0
    heatdisp2(n,1) =0
    plot(x,heatdisp,'--', x, heatdisp2,'*')
    title('Rate of heat dissipation in fins')
    xlabel('Non dimensional distance(x/l)')
    ylabel('Heat dissipation')
    legend('conical fin', 'circular fin')
end
