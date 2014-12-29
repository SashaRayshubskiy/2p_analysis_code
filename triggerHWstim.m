function [ ] = triggerHWstim(eventName, eventData)

global state gh;

cur_sasha_hw_frame_cnt = -1;
if (isfield(state.sasha,'hw_frame_cnt'))
    cur_sasha_hw_frame_cnt = state.sasha.hw_frame_cnt;
end

FR = 7.8;
TRIGGER_TIME  = 11.0;
TRIGGER_FRAME = floor(FR*TRIGGER_TIME);

if (cur_sasha_hw_frame_cnt == TRIGGER_FRAME)
    
    % This assumes the needle is placed at the appropriate position for
    % trial    
    state.sasha.hw_dev_x.MoveJog( 1, state.sasha.hw_direction ); 

    dir_str = 'right';
    if( state.sasha.hw_direction == 2 )
        dir_str = 'left';
    end
    
    disp(['MoveJog(' dir_str 1 ') triggered on frame: ' num2str(cur_sasha_hw_frame_cnt)]);
    
    state.sasha = rmfield(state.sasha, 'hw_frame_cnt');    
end

if (isfield(state.sasha,'hw_frame_cnt'))
    state.sasha.hw_frame_cnt = state.sasha.hw_frame_cnt + 1;
    disp(['state.sasha.hw_frame_cnt: ' num2str(state.sasha.hw_frame_cnt)]);
end

end

