%% Mean velocity and flow direction
% This script plots the mean velocity field and the flow vectors as
% obtained from GIV.
% With the help of this script, Fig. 6.8 of the thesis was generated.  
%%
% set paths and filenames
path = 'Path to georeferenced mean velocity and flow direction (tif files)';
flow_dir = 'Mean Flow Direction.tif';
veloc = 'Mean Velocity.tif';

path_veloc = [path,veloc];
path_flow_dir = [path,flow_dir];

% read in tif images with geotiffread
[flow_dir_field,R_flow] = geotiffread(path_flow_dir);
[veloc_field,R_veloc] = geotiffread(path_veloc);

% transfer flow direction field from degrees against north (clockwise)
% to degrees against x-axis and get x and y directions of flow field

flow_dir_field_new = -flow_dir_field+450;

flow_x = cosd(flow_dir_field_new);
flow_y = sind(flow_dir_field_new);

% get corner coordinates and coordinate spacing for plotting
% from R-object (generated with geotiffread)

x_limit_1 = R_veloc.XWorldLimits(1);
x_limit_2 = R_veloc.XWorldLimits(2);
x_lim = [x_limit_1,x_limit_2];

y_limit_1 = R_veloc.YWorldLimits(1);
y_limit_2 = R_veloc.YWorldLimits(2);
y_lim = [y_limit_2,y_limit_1];

spacing_x = R_veloc.SampleSpacingInWorldX;
spacing_y = R_veloc.SampleSpacingInWorldY;

x=x_limit_1:spacing_x:x_limit_2;
y=y_limit_1:spacing_y:y_limit_2;

% flip y vector to make it the same way our projected coordinate system
% works
y = fliplr(y);

% make meshgrid

[X,Y] = meshgrid(x,y);

% do the plotting
imagesc(x_lim,y_lim,veloc_field);
set(gca, 'YDir', 'normal');
colormap jet;
caxis([0,550]);
cmap = jet(256);
cmap(1,:)=1;
colormap(cmap);
set(gca,'xticklabel',{[]},'yticklabel',{[]})
hold on;

% plot flow direction field as vectors (quiver) on top
% of mean velocity field
h1 = quiver(X,Y,flow_x,flow_y,'r');
set(h1,'AutoScale','on','AutoScaleFactor',0.8)
