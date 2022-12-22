%% Data validation script
% This Matlab script calculates a histogram of differences of our surface velocity data to the
% surface velocities obtained by Millan et al. (2022).
% Difference data were obtained in QGIS.
% With this script, Fig. 6.12 of the thesis was generated.
%%

% set datapaths
path='Path to velocity difference field (tif file)'

% replace unrealistically high values with NaN 
[diff_dataset,R]=geotiffread(path);
ind = find(diff_dataset==diff_dataset(1,1));
diff_dataset(ind)=NaN;

% make histogram
figure(1);
nbins=500;
h=histogram(diff_dataset,nbins,'FaceColor','r','EdgeColor','none')
xlabel('velocity difference [m/year]');
ylabel('frequency');
a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',16,'FontWeight','bold');
