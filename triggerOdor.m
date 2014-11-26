function [ ] = triggerOdor(eventName, eventData)
% This function sends a trigger to the master 8 through A01 channel of Dev2 
% 
% configure analog output
% ao=analogoutput('nidaq','dev3');
% addchannel(ao,1);
% set(ao, 'SampleRate', 10000);
% set(ao, 'TriggerType', 'Manual');
% 
% make column vector for use as master8 trigger
% Master8Trigger = [ 6*ones(100,1); zeros(100,1)];
%  
% 
% Queue Data
% putdata(ao, Master8Trigger)
% 
% Start ao object and clear when done
%  start(ao)
%  trigger(ao)
%  wait(ao,1)
%  delete(ao)
%  clear ao

s = daq.createSession('ni');
s.addAnalogOutputChannel('Dev2','ao1', 'Voltage');
s.Rate=10000;

% make column vector for use as master8 trigger
Master8Trigger = [ 6*ones(100,1); zeros(100,1)];

%Queue output data
s.queueOutputData(Master8Trigger);

%start trigger
s.startForeground();



end

