%% Velocity differences (anomalies) and percentage velocity change 
% This script works on the georeferenced monthly velocity maps 
% generated from GIV. 
% Differences of a reference year (e.g. year with volcanic activity)
% to year without volcanic activity are calculated 
% (see equation 6.1 in thesis).
% Also, percentage velocity change is calculated 
% (see equation 6.2 in thesis).
% Both datasets are exported as geotiff to 'path_out'.
% With this script, Fig. 6.17, Fig. 6.18, Figure 4 (Appendix) and 
% Figure 5 (Appendix) were generated.

%%
% set datapaths
path='path to georeferenced monthly velocity maps (tif files)'
path_out='path of your choice (tif files)'

% set reference year (e.g. with volcanic activity) and months
act_year = 2018;
years=[2016,2017,2018,2019,2020,2021,2022];
months=["Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"];

% only take years not equal to reference year
years = years(years~=act_year);

% set reference year as string and coordRefSysCode for Veniaminof
% region
act_year = num2str(act_year);
coordRefSysCode = 32604;


% loop over years and months
for i=years;
year = num2str(i);
    for j = 1:1;
        
    month=months(j);
    month_num = num2str(j);
    
    % import monthly average velocity field for respective month in
    % year with activity (act_year)
    formatSpec_act_data = 'Average velocity for %s %s_(Moderate Reliability data).tif';
    file_act_data = sprintf(formatSpec_act_data,month_num,act_year);
    act_data_path = [path,file_act_data];
    [act_dataset,R]=geotiffread(act_data_path);
    

    % import monthly average velocity field for respective month in all
    % years different from activity year
    formatSpec_in='Average velocity for %s %s_(Moderate Reliability data).tif';
    file_in=sprintf(formatSpec_in,month_num,year);
    path_join_in = [path,file_in];

    % check if monthly velocity field exists
        if exist(path_join_in)
    
            % read in monthly velocity field, calculate difference to
            % reference year and percentage difference
            data_in = geotiffread(path_join_in);
            diff_data = act_dataset-data_in;
            perc_difference = (diff_data./data_in)*100;
            
            % build datapaths and write datasets to geottiff
            formatSpec_out='%s_minus_%s_month_%s.tif';
            formatSpec_perc_out='perc_difference_%s_minus_%s_month_%s.tif'
            file_out=sprintf(formatSpec_out,act_year,year,month);
            file_perc_out=sprintf(formatSpec_perc_out,act_year,year,month);
            path_join_out = [path_out,file_out];
            path_join_perc_out = [path_out,file_perc_out];
            
            geotiffwrite(path_join_out,diff_data,R,'CoordRefSysCode', coordRefSysCode);
            geotiffwrite(path_join_perc_out,perc_difference,R,'CoordRefSysCode', coordRefSysCode);
    end
    end
end

