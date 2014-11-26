%% Socket test

clear t;

PORT = 30000;

t = tcpip('0.0.0.0', PORT, 'NetworkRole', 'server');

set(t, 'InputBufferSize', 30000); 
% set(t, 'RecordStatus', 'on'); 

set(t, 'TransferDelay', 'off');

disp(['About to listen on port: ' num2str(PORT)]);
fopen(t);

pause(1.0);

disp(['Bytes available: ' num2str(t.BytesAvailable)]);

%data = fread(t, t.BytesAvailable);
%disp(char(data));

data = fscanf(t,'%s', t.BytesAvailable);
disp(data);

fclose(t);

