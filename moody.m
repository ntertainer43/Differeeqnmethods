clear
clc
re = 1000;
rough = [500,100, 50,10,5,1,.5,.1]* 10^-4;

error =1;
a = 0;

for i = 3: 7
    for j = 1:10
        Re(j+ 10*(i-3),1) = j* 10^i;
    end
end
%fric(1: length(Re),1: length(rough)) = .1;
fric(1: length(Re),1) = .1;
for r= 1: length(rough)
    for i = 1: length(Re)
        while error >0.00001
            temp = fric(i,r)
            inter = -2* log((3.7* rough(r))^-1 + (2.51/Re(i) * fric(i,r)^.5))
            fric(i,r) = inter ^-2
            error = temp - fric(i,r)
            
        end
        error =1;
    end 
end

loglog(Re, fric, 'x')
%plot(Re, fric, '*')
% while error >0.00001
%     temp = fric
%     inter = -2* log((3.7* rough)^-1 + (2.51/re * fric^.5))
%     fric = inter ^-2
%     error = temp - fric
%     a = a + 1;
% end
% fric
% a
