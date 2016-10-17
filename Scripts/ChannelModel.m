clear, close, clc

data = readtable('Channel.csv'); %Read data as a table

%% Extract each column. data.X is equivallent to R's data$X
x = data.X*2.54; %Multiply by 2.54 to convert to cm
y = -data.Y*2.54; %Multiply by 2.54 and *1 to get cm and invert the direction in the plot
z = -data.Z; %Multuply by -1 to use as depth, not elevation

x = x(~isnan(x));
y = y(~isnan(y));
z = z(~isnan(z));


%% A preview of the data
%Each point represents one meassurement made
scatter(x,y)

%% Perform spatial interpolation of points
d = 10; %Points will be interpolated to the nearest centimeter

% Create vectors that cover the entire sampling area (min(x) and max(x) to
% min(y) and max(y), in an interval specified by d (see above)

x2 = (min(x):d:max(x)); %Distance from the bridge
y2 = (min(y):d:max(y)); %Distance between each profile

[X,Y] = meshgrid(x2,y2); %Create matrices of x2 and y2 (similar to expand() in R)

Z = griddata(x,y,z,X,Y, 'linear');

surf(X,Y,Z), shading interp, hold on, plot3(x,y,z,'.k'), colormap jet, colorbar, contour3(X,Y,Z,'k')

az = 0;
el = 90;
view([az,el])
degStep = 5;
detlaT = 0.1;
fCount = 71;
f = getframe(gcf);
[im,map] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,fCount) = 0;
k = 1;
%spin 45°
for i = 0:-degStep:-45
  az = i;
  view([az,el])
  f = getframe(gcf);
  im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
  k = k + 1;
end
%tilt down
for i = 90:-degStep:25
  el = i;
  view([az,el])
  f = getframe(gcf);
  im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
  k = k + 1;
end
% spin left
for i = az:-degStep:-360
  az = i;
  view([az,el])
  f = getframe(gcf);
  im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
  k = k + 1;
end
% % spin right
% for i = az:degStep:180
%   az = i;
%   view([az,el])
%   f = getframe(gcf);
%   im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
%   k = k + 1;
% end
% % spin left
% for i = az:-degStep:0
%   az = i;
%   view([az,el])
%   f = getframe(gcf);
%   im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
%   k = k + 1;
% end
% tilt up to original
for i = el:degStep:90
  el = i;
  view([az,el])
  f = getframe(gcf);
  im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
  k = k + 1;
end
imwrite(im,map,'Animation.gif','DelayTime',detlaT,'LoopCount',inf)
