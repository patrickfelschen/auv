%created by Patrick Felschen, Julian Voss
%Lecture: Audio und Videotechnik
clc;
clear;
close all;

%% Einlesen
video_in = VideoReader('car.mp4');
video_out = VideoWriter('result.mp4','MPEG-4');

block_size = 40;
search_size = 20;
threshold = 0.8;

A = block_size*ones(1,video_in.height/block_size);
B = block_size*ones(1,video_in.width/block_size);

%% Schema Motion Estimation
last_i_frame = read(video_in, 1);
open(video_out);

for i=1:video_in.NumFrames
    current_frame = read(video_in, i);
    
    % naechstes I-Frame speichern
    if mod(i,5) == 0
        last_i_frame = current_frame;
    end
    
    % differenz zum letzten I-Frame
    diff_to_i_frame = imabsdiff(last_i_frame, current_frame);
    
    % in 40x40 Bloecke einteilen
    diff_i_frame_blocks = mat2cell(diff_to_i_frame, A, B, 3);
    current_frame_blocks = mat2cell(current_frame, A, B, 3);
    
    i_frame_blocks = mat2cell(last_i_frame, A, B, 3);
    
    for j=1 : size(diff_i_frame_blocks, 1)
        for k=1 : size(diff_i_frame_blocks, 2)
            
            % durchschnittliche Abweichung des Differenzbilds
            mean_block = mean(mean(mean(diff_i_frame_blocks{j, k})));

            if(mean_block > 0)
                immse_block = immse(i_frame_blocks{j, k}, current_frame_blocks{j, k});

                if(immse_block > threshold)
                    
                    % bestmoegliche Verschiebung mit search_size
                    x_offset = j*block_size + 1;
                    y_offset = k*block_size + 1;
                    
                    for x=x_offset : x_offset+search_size

                        for y=y_offset : y_offset+search_size
                                %x = ?;
                                %y = ?;
                        end

                    end

                end

            end
            
        end
        
    end
    
    % Ergebnisvideo aus verschobenen Bloecken des I-Frames
        % Mean Square Error
        %immse ?
        %writeVideo(video_out, frame);
    
end

close(video_out);