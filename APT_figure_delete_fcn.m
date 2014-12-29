function APT_figure_delete_fcn
%% Identification
% David Krause
% Queen's University
% October 18, 2006
% Clean up that APT window

%% Get the UserData
ud = get(gcbo, 'UserData');

%% Clean up the objects
% Clean up the NanoTraks
% Clean up the motors
try
    
    ud.dev_x.StopCtrl;
    ud.dev_x.delete;

    ud.dev_y.StopCtrl;
    ud.dev_y.delete;
    
    ud.dev_z.StopCtrl;
    ud.dev_z.delete;    
catch
    fprintf('Tried to close and delete Motor controls, problem!\n');
end

% Clean up the main control
try
    ud.h_Ctrl.StopCtrl;
    ud.h_Ctrl.delete
catch
    fprintf('Tried to close the main APT control, problem!\n');
end

fprintf('APT Interface Closed.\n');