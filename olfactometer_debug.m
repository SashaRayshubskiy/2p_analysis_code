%% 
clear data avg_data;
close all;
%basepath = '/Users/sasha/Documents/Wilson lab/Data/2p_olfactometer_test_2014_11_05/';
basepath = 'C:\Users\WilsonLab\Desktop\Sasha\2p_olfactometer_test_2014_11_12\';
%basepath = '/Users/sasha/Documents/Wilson lab/Data/2p_olfactometer_test_2014_11_07/';
cd(basepath)

NUM = 4;
num_str = [ num2str( NUM ) '_'];
% trial_types = { 'both_odor', 'left_odor', 'right_odor', 'both_air', 'left_air', 'right_air' };
trial_types = { ['both_odor_' num_str], ['left_odor_' num_str], ['right_odor_' num_str], ['both_air_' num_str], ['left_air_' num_str], ['right_air_' num_str] };
%trial_types = { 'right_odor_3_' };
         
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
%data(1,2,:,:,:) = data(1,1,:,:,:);
rois = get_rois(squeeze(data(1,:,:,:,:)));

left_roi  = rois{1};
right_roi = rois{2};

%%
tt = 1;
clicky_all_data_df_f_with_rois( squeeze(data(tt,:,:,:,:)), FR, TPRE, STIM, [basepath '/'], trial_types{tt}, rois );

%%
STIM = 10.0;
cur_num = 30;
%data(1,2,:,:,:) = data(1,1,:,:,:);
%clicky_all_data_df_f(squeeze(data(1,:,:,:,:)), FR, TPRE, STIM, [basepath '/' trial_types{tt}]);
intens = clicky_all_data_df_f_with_rois( squeeze(data(1,:,:,:,:)), FR, TPRE, STIM, [basepath '/'], [trial_types{tt} '_' num2str(cur_num)], rois );

%% 
STIM = 10.0;
clear intens_air intens_odor;
f = figure;

SPACING = 0.01;
PADDING = 0;
MARGIN = 0.05;

f2 = figure;
f3 = figure;

cnt = 2;
cnt_str = [ '_' num2str(cnt) ];

for tt=1:3
    tt_air = tt+3;
    intens_odor = clicky_all_data_df_f_with_rois( squeeze(data(tt,:,:,:,:)), FR, TPRE, STIM, [basepath '/'], [trial_types{tt} cnt_str], rois );
    close(gcf());
    intens_air = clicky_all_data_df_f_with_rois( squeeze(data(tt_air,:,:,:,:)), FR, TPRE, STIM, [basepath '/'], [trial_types{tt_air} cnt_str], rois );
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
    % ylim([-0.1 0.35]);
    title(['(' trial_types{tt} ' - ' trial_types{tt_air} ')/' trial_types{tt_air}],'Interpreter','none');
    xlabel('Time (s)');
    ylabel('% change');
    
    side_str = {'left', 'right'};

    for side = 1:2
        if(side == 1)
            figure(f2);
        else
            figure(f3);            
        end
        
        BEGIN_TC = 1;
        END_TC = size(DATA,3);
        subaxis(2,3,tt, 'Spacing', SPACING, 'Padding', PADDING, 'Margin', MARGIN);
        DATA = squeeze(mean(squeeze(data(tt,:,:,:,:))));
        rho = corr(squeeze(intens_odor(:,side)), reshape(DATA(:,:,BEGIN_TC:END_TC), [size(DATA,1)*size(DATA,2) size(DATA(:,:,BEGIN_TC:END_TC),3) ])' );
        corr_img = reshape(rho', [size(DATA,1),  size(DATA,2)]);
        imagesc( corr_img ); axis image; axis off; colorbar;
        title(['Corr image ' side_str{side} ' side: ' trial_types{tt}])
        
        subaxis(2,3,tt_air, 'Spacing', SPACING, 'Padding', PADDING, 'Margin', MARGIN);
        DATA = squeeze(mean(squeeze(data(tt_air,:,:,:,:))));
        rho = corr(squeeze(intens_air(:,side)), reshape(DATA(:,:,BEGIN_TC:END_TC), [size(DATA,1)*size(DATA,2) size(DATA(:,:,BEGIN_TC:END_TC),3) ])' );
        corr_img = reshape(rho', [size(DATA,1),  size(DATA,2)]);
        imagesc( corr_img ); axis image; axis off;  colorbar;
        title(['Corr image ' side_str{side} ' side: ' trial_types{tt_air}])
    end
end

saveas(f2,[basepath '/corr_img_' num_str side_str{1} cnt_str '.fig']);
saveas(f2,[basepath '/corr_img_' num_str side_str{1} cnt_str '.png']);
saveas(f3,[basepath '/corr_img_' num_str side_str{2} cnt_str '.fig']);
saveas(f3,[basepath '/corr_img_' num_str side_str{2} cnt_str '.png']);
saveas(f,[basepath '/odor_air_diff' cnt_str '.fig']);

%% Corr image
DATA = avg_data{1};

f2 = figure;
rho = corr(squeeze(intens(:,1)), reshape(DATA(:,:,BEGIN_TC:END_TC), [size(DATA,1)*size(DATA,2) size(DATA(:,:,BEGIN_TC:END_TC),3) ])' );
corr_img = reshape(rho', [size(DATA,1),  size(DATA,2)]);
imagesc( corr_img );
axis image;
colorbar;

saveas(f2,[basepath '/' trial_types{1} '_corr_img.fig']);
saveas(f2,[basepath '/' trial_types{1} '_corr_img.png']);

%%
rois = get_rois(squeeze(data(1,:,:,:,:)), corr_img);

left_roi  = rois{1};
right_roi = rois{2};