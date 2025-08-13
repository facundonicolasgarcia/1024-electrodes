function spy2(S,arg2,arg3);
%SPY Visualize sparsity pattern.
%   SPY(S) plots the sparsity pattern of the matrix S.
%
%   SPY(S,'LineSpec') uses the color and marker from the line
%   specification string 'LineSpec' (See PLOT for possibilities).
%
%   SPY(S,markersize) uses the specified marker size instead of
%   a size which depends upon the figure size and the matrix order.
%
%   SPY(S,'LineSpec',markersize) sets both.

%   SPY(S,markersize,'LineSpec') also works.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.12 $  $Date: 1997/11/21 23:44:52 $

%declare globals
global REGION RASTER

cax = newplot;  
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

marker = '.'; color = 'k'; markersize = 3; linestyle = 'none';
if nargin >= 2
   if isstr(arg2), 
      [line,color,marker,msg] = colstyle(arg2); error(msg)
   else,
      markersize = arg2;
   end
end
if nargin >= 3
   if isstr(arg3),
      [line,color,marker,msg] = colstyle(arg3); error(msg)
   else,
      markersize = arg3;
   end
end
if isempty(marker), marker = '.'; end    %experimental change- it can also be marker = 'o'
if isempty(color), co = get(cax,'colororder'); color = co(1,:); end

[m,n] = size(S);
if marker~='.' & markersize==0,
   markersize = get(gcf,'defaultlinemarkersize');
end
if markersize == 0
   units = get(gca,'units');
   set(gca,'units','points');
   pos = get(gca,'position');
   markersize = max(4,min(14,round(6*min(pos(3:4))/max(m+1,n+1))));
   set(gca,'units',units);
end


[i,j] = find(S);
if isempty(i), i = NaN; j = NaN; end
if isempty(S), marker = 'none'; end
plot(j,i,'marker',marker,'markersize',markersize, ...
   'linestyle',linestyle,'color',color);

xlabel(['nz = ' int2str(nnz(S))]);
grid off
%set(gca,'xlim',[0 n+1],'ylim',[0 m+1], ...  %'ydir','reverse', ...  %I modified this on 10/23/01 so as not to reverse y axis
%   'plotboxaspectratio',[4*n+1 n+1 1]);
set(gcf,'renderer','painters')

if ~hold_state, set(cax,'NextPlot',next); end
