function print_bb_with_id( frame, id, x1, y1, width, heigth )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    box_color = {'red'};

    for index_id = 1 : length(id)

        text_str = ['ID:', num2str(id(index_id))];
        text_position = [x1(index_id) y1(index_id) - 20];

        output_frame = insertText(frame, text_position, text_str, 'FontSize',14,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');

    end

    figure(1);
    imshow(output_frame); title('Red box shows object region');
    hold on;
        for index_id = 1 : length(id)

            bb_position = [x1(index_id), y1(index_id), width(index_id), heigth(index_id)];

            rectangle('Position', bb_position, 'EdgeColor','r','LineWidth',2 )
        end
    hold off;
    drawnow;
end

