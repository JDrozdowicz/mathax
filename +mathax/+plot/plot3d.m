function Selected = plot3d(varargin) %x_axis, y_axis, z_axis, image_3d)


switch (nargin)
    case 1
        image_3d = varargin{1};
        x_axis = 1:size(image_3d,1);
        y_axis = 1:size(image_3d,2);
        z_axis = 1:size(image_3d,3);
        p_x = repmat(x_axis.',1,size(y_axis,2),size(z_axis,2));
        p_y = repmat(y_axis,size(x_axis,2),1,size(z_axis,2));
        p_z = repmat(permute(z_axis,[3,1,2]),size(x_axis,2),size(y_axis,2),1);
    case 2
        p_x = varargin{1}(1,:);
        p_y = varargin{1}(2,:);
        p_z = varargin{1}(2,:);
        image_3d = varargin{2};
    case 4
        x_axis = varargin{1};
        y_axis = varargin{2};
        z_axis = varargin{3};
        image_3d = varargin{4};
        p_x = repmat(x_axis.',1,size(y_axis,2),size(z_axis,2));
        p_y = repmat(y_axis,size(x_axis,2),1,size(z_axis,2));
        p_z = repmat(permute(z_axis,[3,1,2]),size(x_axis,2),size(y_axis,2),1);
end

normalize = @(x) (abs(x)-min(abs(x(:))))./(max(abs(x(:)))-min(abs(x(:))));

% 

p_x_vect = p_x(:);
p_y_vect = p_y(:);
p_z_vect = p_z(:);


% tutaj zrob skalowanie obrazka

npoints = 200000;
db_limit = -10;
scale = 100;
pwr = 1;
image_vect = image_3d(:);
result_vect = image_vect./(max(abs(image_vect)));


% w skali log
result_vect_db = db(result_vect);
result_ind_a = find(result_vect_db > db_limit);

% nie wyswietlaj za duzo punktow
result_npoints_over = numel(result_ind_a);
result_ind = result_ind_a(1:ceil(result_npoints_over/npoints):end);

data_x = p_x_vect(result_ind);
data_y = p_y_vect(result_ind);
data_z = p_z_vect(result_ind);
data_s = scale*normalize(result_vect(result_ind))+1;
data_c = p_x_vect(result_ind);


h = scatter3(data_x,data_y,data_z,data_s,data_c,'filled');
title(['lim = ', num2str(db_limit), ' dB']);
colormap('cool');


set(gca,'XDir','Reverse');
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;

 
% xlim(1.5.*[x_axis(1),x_axis(end)]);
% ylim(1.5.*[y_axis(1),y_axis(end)]);
% zlim(1.5.*[z_axis(1),z_axis(end)]);



view(105,30);

Selected = [];

% hb1 = uicontrol('Style', 'PushButton', 'String', 'Next', ...
% 	'Callback', @NextBtnCB);
% hb3 = uicontrol('Style', 'PushButton', 'String', 'Prev', ...
% 	'Callback', @PrevBtnCB);
hb2 = uicontrol('Style', 'PushButton', 'String', 'Store', ...
	'Callback', @StoreBtnCB);
hb4 = uicontrol('Style','slider', 'min',-50, 'max',0, ...
    'Value', db_limit, 'Callback', @XSldrCB);
hb5 = uicontrol('Style','edit', ...
    'String', '1', 'Callback', @XTxtCB);


% hb1.Position(2) = hb2.Position(2)+1.1*hb2.Position(4);
% hb3.Position(2) = hb1.Position(2)+1.1*hb1.Position(4);
hb4.Position(1) = hb2.Position(1)+1.1*hb2.Position(3);
hb4.Position(3) = hb2.Position(3)*5;
hb5.Position(2) = hb2.Position(2)+1.1*hb2.Position(4);

h.XDataSource = 'data_x';
h.YDataSource = 'data_y';
h.ZDataSource = 'data_z';
h.SizeDataSource = 'data_s';
h.CDataSource = 'data_c';


% while isempty(Selected)
% 	pause(.1);
% end

% 	function NextBtnCB(src, evnt)
% 		if count<size(image_3d, 1)
% 			count = count + 1;
% 			h.CData = (squeeze(image_3d(count,:,:)).');
%             title(['x = ', num2str(x_axis(count))]);
% 		end
%     end
%     function PrevBtnCB(src, evnt)
% 		if count > 1
% 			count = count - 1;
% 			h.CData = (squeeze(image_3d(count,:,:)).');
%             title(['x = ', num2str(x_axis(count))]);
% 		end
% 	end
    function XSldrCB(src, evnt)
        db_limit = src.Value;
        hb5.String = num2str(db_limit);
        result_ind_a = find(result_vect_db > db_limit);

        % nie wyswietlaj za duzo punktow
        result_npoints_over = numel(result_ind_a);
        result_ind = result_ind_a(1:ceil(result_npoints_over/npoints):end);
        data_x = p_x_vect(result_ind);
        data_y = p_y_vect(result_ind);
        data_z = p_z_vect(result_ind);
        data_s = scale*normalize(result_vect(result_ind))+1;
        data_c = p_x_vect(result_ind);
        refreshdata(h,'caller');

        
	end
    function XTxtCB(src, evnt)
        db_limit = str2double(src.String);
        db_limit = max(min(db_limit,0),-50);
        hb4.Value = db_limit;
        hb5.String = num2str(db_limit);
        result_ind_a = find(result_vect_db > db_limit);

        % nie wyswietlaj za duzo punktow
        result_npoints_over = numel(result_ind_a);
        result_ind = result_ind_a(1:ceil(result_npoints_over/npoints):end);
        data_x = p_x_vect(result_ind);
        data_y = p_y_vect(result_ind);
        data_z = p_z_vect(result_ind);
        data_s = scale*normalize(result_vect(result_ind))+1;
        data_c = p_x_vect(result_ind);
        refreshdata(h,'caller');
		
	end

	function StoreBtnCB(src, evnt)
		Selected = db_limit;
	end
end