%% Create the interface
% Create the figure
fig = figure('Position', [5 35 1272 912], 'HandleVisibility', 'off', 'IntegerHandle', 'off', ...
             'Name', 'APT Interface', 'NumberTitle', 'off', 'DeleteFcn', 'APT_figure_delete_fcn');
         
set(fig, 'Name', ['APT Interface, Handle Number ' num2str(fig, '%2.20f')]);

% Create the main control, ActiveX
% Consult the functions actxcontrolselect, actxcontrollist, methodsview
h_Ctrl = actxcontrol('MG17SYSTEM.MG17SystemCtrl.1', [0 0 100 100], fig);

% Start the control
h_Ctrl.StartCtrl;

% Prepare the user data
ud.h_Ctrl = h_Ctrl;
set(fig, 'UserData', ud);

% Start the motor controls
% Verify the number of motor controls
[temp, num_motor] = h_Ctrl.GetNumHWUnits(6, 0);
if num_motor ~= 3
    fprintf(['Check the number of Motor Controls (Found' num2str(num_motor) ')!\n']);
    return
end

% Get the serial numbers
for count = 1 : 3
    [temp, SN_motor{count}] = h_Ctrl.GetHWSerialNum(6, count - 1, 0); % Get the serial number of the devices
end

SN_motor

% Check to see that these match with:
% 12345678 (Left Pitch Roll), 12345678 (Left X Yaw), 12345678 (Left Y Z)
% 12345678 (Right Pitch Roll), 12345678 (Right X Yaw), 12345678 (Right Y Z)

% Start them up
MyBox = uicontrol(fig,'style','text');
set(MyBox,'String','X Control');
set(MyBox,'Position',[500,830,300,20]);
dev_x = actxcontrol('MGMOTOR.MGMotorCtrl.1', [500 610 300 200], fig);
SetMotor(dev_x, SN_motor{3});

MyBox = uicontrol(fig,'style','text');
set(MyBox,'String','Z Control');
set(MyBox,'Position',[500,530,300,20]);
dev_z = actxcontrol('MGMOTOR.MGMotorCtrl.1', [500 305 300 200], fig);
SetMotor(dev_z, SN_motor{1});

MyBox = uicontrol(fig,'style','text');
set(MyBox,'String','Y Control');
set(MyBox,'Position',[500,230,300,20]);
dev_y = actxcontrol('MGMOTOR.MGMotorCtrl.1', [500 0 300 200], fig);
SetMotor(dev_y, SN_motor{2});