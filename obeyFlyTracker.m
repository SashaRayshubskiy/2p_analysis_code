function [ ] = obeyFlyTracker(eventName, eventData)

global state gh

%figure(gh.mainControls.figure1);
%state.internal.whatToDo = 2;
%executeGrabOneCallback(gh.mainControls.grabOneButton);    


if 1
%%%%
% Start a server to listen on the socket to fly tracker
%%%%
clear t;
PORT = 30000;
t = tcpip('0.0.0.0', PORT, 'NetworkRole', 'server');
set(t, 'InputBufferSize', 30000); 
set(t, 'TransferDelay', 'off');
disp(['About to listen on port: ' num2str(PORT)]);
fopen(t);
pause(1.0);

while 1
    
    % state.software.betaNum = 1 is a signal for abort

    % Read the message     
    while (t.BytesAvailable == 0 && (state.software.betaNum ~= 1))
        pause(0.1);
    end
        
    data = fscanf(t, '%s', t.BytesAvailable);
    disp(data);
    
    if( (strcmp(data,'END_OF_SESSION') == 1) || (state.software.betaNum == 1))
        break;
    end
        
    % Update the basename
    state.files.baseName = data;
    updateGUIByGlobal('state.files.baseName');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Place the Hubel-Weisel needle to an appropriate initial position
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (~isfield(state,'sasha'))
        state.sasha.first = 1;
    end
    
    if (~isfield(state.sasha, 'hw_dev_x'))
        [dev_x, dev_y, dev_z] = getAPTDevices();
        state.sasha.hw_dev_x = dev_x;
    end
    
    if (~isfield(state,'sasha.hw_frame_cnt'))
        state.sasha.hw_frame_cnt = 1;
        state.sasha.hw_prev_trial_type = '';
        state.sasha.HW_JOG_MOVE_DIST = 2.0; % mm
        state.sasha.hw_dev_x.SetJogStepSize( 1, state.sasha.HW_JOG_MOVE_DIST );
        
        state.sasha.HW_JOG_MOVE_MIN_VEL = 0.0;
        state.sasha.HW_JOG_MOVE_ACCEL = 1.5;
        state.sasha.HW_STIM_PERIOD = 10.0; % sec
        
        state.sasha.HW_JOG_MOVE_MAX_VEL = state.sasha.HW_JOG_MOVE_DIST / state.sasha.HW_STIM_PERIOD;        
        
        state.sasha.hw_dev_x.SetJogVelParams( 1, ... 
                                             state.sasha.HW_JOG_MOVE_MIN_VEL, ...
                                             state.sasha.HW_JOG_MOVE_ACCEL, ...
                                             state.sasha.HW_JOG_MOVE_MAX_VEL );
    end
    
    cur_trial_type = state.files.baseName;
           
    if(length(strmatch('Right', cur_trial_type) ==  1))
        state.sasha.hw_direction = 1;
    elseif(length(strmatch('Left', cur_trial_type) ==  1))
        state.sasha.hw_direction = 2;
    end
    
%     if(strcmp(cur_trial_type, state.sasha.hw_prev_trial_type) == 1)
%         % Need to move the needle back       
%         % state.sasha.hw_dev_x.SetRelMoveDist(0, -1.0*state.sasha.HW_REL_MOVE_DIST*cur_hw_direction ); 
%         % state.sasha.hw_dev_x.MoveRelative(0, 1); %  Wait for trial to finish
%         
%         revdir = -1;
%         if (state.sasha.hw_direction == 1 )
%             revdir = 2;
%         elseif (state.sasha.hw_direction == 2 )
%             revdir = 1;            
%         end
% 
%         % Speed up the move
%         state.sasha.hw_dev_x.SetJogVelParams( 1, ... 
%                                              state.sasha.HW_JOG_MOVE_MIN_VEL, ...
%                                              state.sasha.HW_JOG_MOVE_ACCEL, ...
%                                              3.5 );
% 
%         state.sasha.hw_dev_x.MoveJog(1, revdir);
%         disp('revdir MoveJog finished');
% 
%         % Revert to the original velocity
%         state.sasha.hw_dev_x.SetJogVelParams( 1, ... 
%                                              state.sasha.HW_JOG_MOVE_MIN_VEL, ...
%                                              state.sasha.HW_JOG_MOVE_ACCEL, ...
%                                              state.sasha.HW_JOG_MOVE_MAX_VEL );
%     end
        
    state.sasha.hw_prev_trial_type = cur_trial_type;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    % call grab;
    % set(gh.mainControls.grabOneButton, 'String', 'GRAB');
    figure(gh.mainControls.figure1);
    state.internal.whatToDo = 2;
    executeGrabOneCallback(gh.mainControls.grabOneButton);
end

fclose(t);
end

end

