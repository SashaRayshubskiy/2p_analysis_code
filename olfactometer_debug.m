%% 
clear data avg_data;
close all;
%basepath = '/Users/sasha/Documents/Wilson lab/Data/2p_olfactometer_test_2014_11_05/';
basepath = 'C:\Users\WilsonLab\Desktop\Sasha\2p_olfactometer_test_2014_11_09\';
%basepath = '/Users/sasha/Documents/Wilson lab/Data/2p_olfactometer_test_2014_11_07/';
cd(basepath)

%trial_types = { 'both_odor', 'left_odor', 'right_odor', 'both_air', 'left_air', 'right_air' };
trial_types = { 'both_odor_12', 'left_odor_12', 'right_odor_12', 'both_air_12', 'left_air_12', 'right_air_12' };
%trial_types = { 'left_air_7' };
FR = 7.8;
TPRE = 5;
STIM = 10.0;

for tt = 1:size(trial_types,2)
    
    search_path = ['*' trial_types{tt} '*'];
    files = dir([search_path '.tif']);
        
    for i=1:size(files,1)
        filename = files(i).name;
        
        info = imfinfo(filename);
        num_images = numel(info);
        for k = 1:num_images-2
            data(tt,i,:,:,k) = double(imread(filename, k));
        end
    end
    
    avg_data{tt} = squeeze(mean(squeeze(data(tt,:,:,:,:))));
end

%%
rois = get_rois(squeeze(data(1,:,:,:,:)));

left_roi  = rois{1};
right_roi = rois{2};

%%
tt = 1;
clicky_all_data_df_f_with_rois( squeeze(data(tt,:,:,:,:)), FR, TPRE, STIM, [basepath '/'], trial_types{tt}, rois );

%%
STIM = 10.0;
data(1,2,:,:,:) = data(1,1,:,:,:);
%clicky_all_data_df_f(squeeze(data(1,:,:,:,:)), FR, TPRE, STIM, [basepath '/' trial_types{tt}]);
clicky_all_data_df_f_with_rois( squeeze(data(1,:,:,:,:)), FR, TPRE, STIM, [basepath '/'], trial_types{tt}, rois );

%% 
STIM = 10.0;
clear intens_air intens_odor;
f = figure;
for tt=1:3
    tt_air = tt+3;
    intens_odor = clicky_all_data_df_f_with_rois( squeeze(data(tt,:,:,:,:)), FR, TPRE, STIM, [basepath '/'], trial_types{tt}, rois );
    close(gcf());
    intens_air = clicky_all_data_df_f_with_rois( squeeze(data(tt_air,:,:,:,:)), FR, TPRE, STIM, [basepath '/'], trial_types{tt_air}, rois );
    close(gcf());
    
    figure(f);
    subplot(1,3,tt);
    nframes = size(data,5);
    t = [0:nframes-1]./FR;
    
    hold on;
    bs_fr_end = floor(TPRE*FR);
    left_pc = (intens_odor(:,1)-intens_air(:,1))./ intens_air(:,1);
    left_pc_s = left_pc - (mean(left_pc(1:bs_fr_end)));    
    
    right_pc = (intens_odor(:,2)-intens_air(:,2))./ intens_air(:,2);
    right_pc_s = right_pc - (mean(right_pc(1:bs_fr_end)));
    
    p1 = plot( t', left_pc_s, 'b' );
    p2 = plot( t', right_pc_s, 'g' );
    legend([p1, p2], 'Left','Right');
    xlim([0 20]);
    ylim([-0.1 0.35]);
    title(['(' trial_types{tt} ' - ' trial_types{tt_air} ')/' trial_types{tt_air}],'Interpreter','none');
    xlabel('Time (s)');
    ylabel('% change');
end

saveas(f,[basepath '/odor_air_diff.fig']);
