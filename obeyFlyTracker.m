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
    
    % call grab;
    % set(gh.mainControls.grabOneButton, 'String', 'GRAB');
    figure(gh.mainControls.figure1);
    state.internal.whatToDo = 2;
    executeGrabOneCallback(gh.mainControls.grabOneButton);
end

fclose(t);
end

end

