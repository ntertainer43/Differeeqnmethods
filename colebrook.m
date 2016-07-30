function Colebrook
%COLEBROOK'S DIAGRAM
%Relative roughness
r= [0,1e-5,5e-5,1e-4,2e-4:2e-4:1e-3,2e-3:2e-3:1e-2,1.5e-2,2e-2:1e-2:5e-2];
R=logspace(3,8,100);                 %Reynold's No.
L= 600:2300;                         %Laminar Flow
T= 2300:R(R>2300);                   %Turbulent Flow
% Friction factor curves
for i=1:length(L)
loglog(L(i),64/L(i),'b','linewidth',1)
end
for i=1:length(r)
 for j=1:length(R)
 loglog(T(j),colebrook(T(j),r(i)),'b','linewidth',1)
 end
end
figure(1), clf, cf=gcf; ca=gca;
set(cf,'PaperOrientation','landscape',...
  'name','MoodyDiagram','PaperUnits','points');
set(ca,'xscale','log','yscale','log','box','on',...
  'fontsize',8,'DefaultTextFontSize',8);
axis([600,1e8,0.008,0.1]); pbaspect([13.5,9.5,1]); hold on

% Units and paper size
u='imp'; p='Letter';
if nargin
  if strcmpi(units,'si')
    u='si'; p='A4';
  end
  if nargin>1
    if strcmpi(paper,'a4')
      p='A4';
    else
      p='Letter';
    end
  end
end
units=u; paper=p; white=[1 1 1];

% Critical zone patch
patch([2e3,2e3,4e3,4e3],[8e-3,1e-1,1e-1,8e-3],0.96*white)

% Grid
logminorgrid('y',7,40,1)
logmajorgrid('y',1,0.1)
logminorgrid('x',7,0.0003,0)
logmajorgrid('x',0,0.1)
logmajorgrid('x',-1,0.4)
end

function f=colebrook(T,r)
% Colebrook Equation
%   f = Darcy-Weisbach friction factor
%   R = Reynolds number
%   r = relative roughness

 f0=0.04
for i=1:length(r)
  for j=1:length(T)  
    f0=(2*log10(r(i)/3.7+2.51/T(j)/sqrt(f0)))^-2;
  end
  f(i)=f0;
end
end





%-------------------------------------------------------------------------
function logmajorgrid(xystr,space,width)
% Log Major Grid
%   xystr = 'x' for x axis grid
%           'y' for y axis grid
%   space = -1 for sparse grid
%            0 for normal grid
%            1 for dense  grid
%   width = grid line width

v=axis;
if strcmp(xystr,'y'), v=[v(3) v(4) v(1) v(2)]; end
switch space
case -1
  tk=1;
case 0
  tk=1:9;
case 1
  tk=[1:0.5:5.5,6:9];
end
for i=floor(log10(v(1))):ceil(log10(v(2)))
  for k=1:length(tk)  % grid lines only
    tk10=tk(k)*10^i;
    if tk10 < v(2) && tk10 > v(1)
      if strcmp(xystr,'x')
        plot(tk10*[1,1],[v(3),v(4)],'k-','linewidth',width)
      else
        plot([v(3),v(4)],tk10*[1,1],'k-','linewidth',width)
      end
    end
  end
end
end

%-------------------------------------------------------------------------
function logminorgrid(xystr,fntsz,off,space)
% Log Minor Grid
%   xystr = 'x' for x axis grid
%           'y' for y axis grid
%   fntsz = font size
%   off   = text offset
%   space = -1 for sparse grid
%            0 for normal grid
%            1 for dense  grid

v=axis; grey=0.5*[1,1,1];
if strcmp(xystr,'y'), v=[v(3) v(4) v(1) v(2)]; end
switch space
case -1
  tk=[1.2:0.2:1.8,2.5:1:3.5]; tx=2:5;
case 0
  tk=[1.2:0.2:2.8,3.5:1:5.5]; tx=2:8;
case 1
  tk=[1.1:0.1:5.9,6.2:0.2:6.8,7.5:1:9.5];
  tx=[1.2:0.2:1.8,2:0.5:6,7,8,9];
end
for i=floor(log10(v(1))):ceil(log10(v(2)))
  for j=1:length(tx)  % grid labels
    tx10=tx(j)*10^i;
    if tx10 < 1.01*v(2) && tx10 > 0.99*v(1)
      if strcmp(xystr,'x')
        text(tx10,v(3)-off,num2str(tx(j)),'fontsize',fntsz,...
          'horizontalalignment','center')
      else
        text(v(3)-off,tx10,num2str(tx(j)),'fontsize',fntsz,...
          'horizontalalignment','right')
      end
    end
  end
  for k=1:length(tk)  % grid lines
    tk10=tk(k)*10^i;
    if tk10 < v(2) && tk10 > v(1)
      if strcmp(xystr,'x')
        plot(tk10*[1,1],[v(3),v(4)],'-','linewidth',0.1,'color',grey)
      else
        plot([v(3),v(4)],tk10*[1,1],'-','linewidth',0.1,'color',grey)
      end
    end
  end
end
end
