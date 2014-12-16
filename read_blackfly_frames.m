%% Create AVIs from fly antenna motion frames

basedir = 'C:\tmp\';

clear mdata;
search_path = ['both_air_0_5_suction'];
files = dir([basedir search_path '.tiff']);
        
for i=1:size(files,1)
    filename = files(i).name;    
    mdata(:,:,k) = double(imread([basedir filename], i));
end