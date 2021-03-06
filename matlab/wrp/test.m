%Main program of hologram generation by wavefront recording plane method
%by Openholo library project
%2017-10-30 update
%
addpath('D:\Mathlab\wrp\data_scaled');
addpath('D:\Mathlab\libs') ; 
clc;clear;close all;
%% papilon
% papilon 
% obj(:,1) = obj(:,1)/2.25;
% obj(:,2) = obj(:,2)/2.25;
% obj(:,3) = obj(:,3)/40 ;
% highest 125 segmentation can be done
%% highest 138 segmentation can be done
zhao %maximum 120 wrp
obj(:,1) = (obj(:,1)/450);
obj(:,2) = (obj(:,2)/450);
obj(:,3) = (obj(:,3)/20);

%% %highest 59 segmentation can be done
% three_object 
% obj(:,1) = obj(:,1)*1.5; 
% obj(:,2) = obj(:,2)*1.5;  
% obj(:,3) = obj(:,3)*50;   

%% %highest 22 segmentation can be done
% cup_cube
% obj(:,1) = ((obj(:,1) )/750);
% obj(:,2) = ((obj(:,2)+0.50)/900);
% obj(:,3) = (obj(:,3))/20;
% max(obj)
% min(obj)



% *11980*1024
% obj(:,1) = ((obj(:,1) )/250);
% obj(:,2) = ((obj(:,2)+0.50)/500);
% obj(:,3) = (obj(:,3))/20;
% max(obj)
% min(obj)
%% 
% maximum 59 segmentation
% four_items
% obj(:,1) = ((obj(:,1) )/600);
% obj(:,2) = ((obj(:,2)  )/1000);
% obj(:,3) = (obj(:,3))/30;
% max(obj)
% min(obj)
% 
%1980*1024
% obj(:,1) = ((obj(:,1) )/300);
% obj(:,2) = ((obj(:,2)  )/500);
% obj(:,3) = (obj(:,3))/30;
% max(obj)
% min(obj)
 
%% 205 segmentation

% me_cube2
% obj(:,1) = ((obj(:,1) )/450);
% obj(:,2) = ((obj(:,2)+0.15 )/600);
% obj(:,3) = (obj(:,3))/40;

% 
% max(obj)
% min(obj)


%1980*1024
% me_cube2
% obj(:,1) = ((obj(:,1) )/400);
% obj(:,2) = ((obj(:,2)+0.15 )/350);
% obj(:,3) = (obj(:,3))/40;
% 
% 
% max(obj)
% min(obj)
%% 


% me_cube 
% obj(:,1) = ((obj(:,1) )/450);
% obj(:,2) = ((obj(:,2)+0.15 )/600);
% obj(:,3) = (obj(:,3))/40;
% 
% 
% max(obj)
% min(obj)


%% 





file_type = '.bmp';
project_name = mfilename;

Hologram_resolution_x = 1980;  
Hologram_resolution_y = 1024;  % Hologram resolution  
Hologram_resolution = strcat(num2str(Hologram_resolution_x),'X', num2str(Hologram_resolution_y)) ;
Hologram_sampling_interval = 7.4e-6;%8.4e-6; %;            % Hologram sampling interval



% Hologram_wrp  =( zeros(Hologram_resolution, Hologram_resolution, 3));  %( zeros(Hologram_resolution));

lambda = [632.8e-9 532e-9 473e-9]; %RGB; 
 

obj_z = sort(obj(:,3));

 
Cut = sort(unique(obj_z)); 

ROWS= Hologram_resolution_x;                                     
COLS= Hologram_resolution_y;
v=Hologram_sampling_interval.*(ones(COLS,1)*(-ROWS/2:ROWS/2-1))';
h=Hologram_sampling_interval.*(ones(ROWS,1)*(-COLS/2:COLS/2-1));

 
obj_depth = max(obj(:,3)) -min(obj(:,3))
d = 0.35;


%d = max(obj(:,3)) + max(obj(:,3)) - min((obj(:,3)))
% d2 = d+0.002 - 7*0.0002;

Nx = ( round(obj(:,1)./Hologram_sampling_interval)+(Hologram_resolution_x)/2);  
Ny = (round (obj(:,2)./Hologram_sampling_interval)+(Hologram_resolution_y)/2 );

max_counter= 0;

t = 0;
sub_dir = strcat(project_name,'\',obj_name,sprintf('_%0.9f',Hologram_sampling_interval),'\',num2str(Hologram_resolution),'\obj_depth',num2str(obj_depth),'\d_',num2str(d),'\layers_',sprintf('%d',length(Cut)));
% mkdir(sub_dir );
% 
file_name = strcat('again_time_',sprintf('%0.1f',Hologram_resolution),'.txt');
full_file_name = fullfile(sub_dir, file_name);
fileID = fopen(full_file_name,'w'); 


original = zeros(Hologram_resolution_x,Hologram_resolution_y,3);   



segmentation_number = 0;

for kk = 1: length(Cut)
     current_depth = Cut(kk);
     indexes = find(obj(:,3) == current_depth); %indexes with this number of object point    
     if length(indexes)<=5 && kk < length(Cut)
         obj(indexes,3) =  Cut(kk+1);
     end
end

obj_z = sort(obj(:,3));

while segmentation_number <138 %first step of segmentation
 if segmentation_number == 0
    [uv,~,idx] = unique(obj_z);
    n = accumarray(idx(:),1);
    X = [0,1,~diff(n',2)];
    [B,E] = regexp(char('0'+X),'0+1*');
    C = arrayfun(@(b,e){n(b:e)},B,E); 
 else
     
%      B_temp = B;
%      E_temp = E;
     [s,ddif] = cellfun(@size,C);
    [out,index_max] = max([s,ddif]);

    second_order_obj_z = uv(B(index_max):E(index_max));

    A = obj_z( ismember( obj_z, second_order_obj_z ) ); 

    [uv_temp,~,idx2] = unique(A);
    n = accumarray(idx2(:),1);
    X = [0,1,~diff(n',2)];
    [B_new,E_new] = regexp(char('0'+X),'0+1*');
    C_new = arrayfun(@(b,e){n(b:e)},B_new,E_new);

    B_new = B_new + E(index_max-1);
    E_new = E_new +  E(index_max-1);
    
%     
% n = [ 3 3 1 1 1 ];
% X = [0,1,~diff(n,2)];

 
     
    B_temp = [B(1:index_max-1), B_new(1:end), B(index_max+1:end)];
    E_temp = [E(1:index_max-1), E_new(1:end), E(index_max+1:end)];
    C_temp = {C{1:index_max-1},C_new{1:end}, C{index_max+length(C_new)-1:end}};
    C(1:end) = [];     B(1:end) = [];     E(1:end) = [];
    C = C_temp;  B = B_temp;  E = E_temp;
    
    if length(C) ~= length(B)
        disp("######");
        return;
    end
    
    
 end
 %% 
  
    segmentation_number = segmentation_number+1;

end

% s =0;
% for kk = 1: length(C)
%      s = s + sum(cell2mat(C(kk)));
% end



%  %% 

% end
%  C(12)=[];
%  C(139)=[];


C2 = vertcat(C{:});
  tic
  

for color_index = 1:length(lambda)  %iterate each color
    

    k = 2*pi/lambda(color_index); 
  
    WRPHologram =  zeros(Hologram_resolution_x,Hologram_resolution_y);
    
    counter = 0;
    for depth_range_index = 1:length(C)       %iterate each depth range
        WRP =  zeros(Hologram_resolution_x,Hologram_resolution_y);
 
        range_range_all_index = B(depth_range_index):E(depth_range_index) ;
        wrp_location = median(uv(range_range_all_index)) +0.000005;  %  WRP location 
     
        d_wrp_to_hologram = max(abs(d-wrp_location));  
        
        for depth_index =  range_range_all_index   %iterate each depth layer
            
            current_depth = uv(depth_index);
            indexes = find(obj(:,3) == current_depth); %indexes with this number of object point          
                     
            z =  ((wrp_location -  current_depth));
            color_for_this_depth = obj_c(indexes,color_index);
            active_area =  (round(abs(lambda(color_index).*z ./(Hologram_sampling_interval^2)/2)+0.5).*2-1 );        %sampling size of N 
            Nx_for_this_depth = Nx(indexes);
            Ny_for_this_depth = Ny(indexes);

%             
%             t = t+1;
%                 active_arr(t) = active_area;
%                 
                
            [y_run, x_run]= meshgrid((-(active_area-1)/2:(active_area-1)/2)*Hologram_sampling_interval,(-(active_area-1)/2:(active_area-1)/2)*Hologram_sampling_interval);
            r =  (sign(z)*sqrt(z^2 + y_run.^2 + x_run.^2)); 
            for Ni = 1 : length( indexes)   %iterate each object point
                counter = counter +1;
                fprintf('counter: %d color: %d seg:%d\n',counter ,color_index,segmentation_number);
                nx=Nx_for_this_depth(Ni); ny=Ny_for_this_depth(Ni);        
                Sub_hologram =  color_for_this_depth(Ni)*exp(-1j*2*rand*pi)*exp(1j*k*r)./r; %*exp(1j*2*pi)*
                WRP(nx:nx+active_area-1,ny:ny+active_area- 1)= WRP(nx:nx+active_area-1,ny:ny+active_area-1) + Sub_hologram;

            end 
        end
         WRPHologram = WRPHologram + FresnelPropagation((WRP), Hologram_sampling_interval, Hologram_sampling_interval, d_wrp_to_hologram, lambda(color_index));
     
    end
        close all    
           for p = 26%reconstructed
            d2 = d+0.002 - p*0.001
            original_red =  FresnelPropogation(k,v, h,-d2,WRPHologram);
            original_abs_red= abs((original_red)); 
            original(:,:,color_index)= 255.*(original_abs_red./max(max(original_abs_red))) ;
%              figure; imshow(rot90(abs(original(:,:,color_index)))*10,[]); title(p);
%              toc
%             
%              
%                   file_name = strcat('',project_name,'_color_',num2str(color_index),'_d_',num2str(d),'threshold_',num2str(length(C)),'_total_layer_',num2str(length(Cut)),'_recon_d_',num2str(d2),file_type);
%         fullFileName = fullfile(sub_dir,file_name); 
%          imwrite(rot90(abs(original(:,:,color_index)))*10,fullFileName);
%         save_hologram(gather(WRPHologram),fullFileName);
        end
%   toc

end
%  plot([1:123],(active_arr));
% title('Segmentation based on no. of points');
% xlabel('Depth layers')
% ylabel('Active area') 


%% reconstruction for red
end_time = toc
% figure; imshow(rot90(uint8((original*3 ))),[]);
file_name = strcat('person',project_name,'_d_',num2str(d),'WRP_',num2str(length(C)),'_total_layer_',num2str(length(Cut)),'_recon_d_',num2str(d2),file_type);
fullFileName = fullfile(sub_dir,file_name);
imwrite((uint8((original*2 ))),fullFileName);

fprintf(fileID,'%d %d %.3f \n ',length(C),segmentation_number, end_time);

 
%     segmentation_number = segmentation_number + 1;
% end
fclose(fileID); 
