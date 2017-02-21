function [sys,x0]=animation_poleCart(t, x, u, flag, ts); %u is [x theta]

% IPM Animation					 		                                          % 



% ---------------- %
% DECLARATION PART %
% ---------------- %


% global variables
global  hLEG hTYRE1 hTYRE2 hCART hGROUND % IPM Leg and Center of Mass

l = 1;

w = 0.4*l;
h = 0.25*w;
r_tyre = 0.08*w;
% ------------ %
% PROGRAM PART %
% ------------ %

% see Matlab S-Function Manual for the structuring of S-functions.

switch flag,
  

  
  % --------------
  % Initialization
  % --------------

  case 0,
     
    % create animation figure
    figure(1)
    clf
    axes
    axis image
    hold on
   
    
    % set axis range in meters
    axis([-3 3 -3 3])
    
    center1 = [-w*0.4 r_tyre];
    center2 = [w*0.4 r_tyre];
    
    
    % initialize plot handles
    
    hTYRE1 = rectangle('Position',[center1-r_tyre, 2*r_tyre 2*r_tyre] ,'Curvature',[1 1], 'FaceColor', [0.4 0.4 0.4], 'Edgecolor','none');
    hTYRE2 = rectangle('Position',[center2-r_tyre, 2*r_tyre 2*r_tyre] ,'Curvature',[1 1], 'FaceColor', [0.4 0.4 0.4], 'Edgecolor','none');
    hCART = rectangle('Position',[-w/2 2*r_tyre w h], 'FaceColor', [0 0.6 0], 'Edgecolor','none');
    hLEG  = plot( [0 0], [h/2+2*r_tyre (l+h/2+2*r_tyre)], 'Color', 'k', 'LineWidth', 4);
    hGROUND = plot([-10 10], [0 0], 'Color', 'k', 'LineWidth', 1);
%     M(k) = getframe(gcf);
%     k = k+1;
    
    % Simulink interaction
    % --------------------
    
    % set io-data: .  .  .  number of Simulink u(i)-inputs  .  .
    sys = [0 0 0 2 0 0];
    
    % return intial conditions
    x0 = [];
%     theta = u(1);
%     x = u(2);
 



  % ------------
  % Modification
  % ------------

  case 2, 

    % update Tyres of cart by updating the center position
    center1 = [(-w*0.4 + u(1)) r_tyre];
    center2 = [(w*0.4+ u(1)) r_tyre];
    hTYRE1.Position = [center1-r_tyre, 2*r_tyre 2*r_tyre];
    hTYRE2.Position = [center2-r_tyre, 2*r_tyre 2*r_tyre];

    %update cart position
    hCART.Position = [(-w/2+u(1)) 2*r_tyre w h];
    
    % update LEG xy-vector data
    set(hLEG, 'XData', [u(1) (u(1)+l*sin(u(2)))], 'YData', [h/2+2*r_tyre (l*cos(u(2))+h/2+2*r_tyre)]);
    
    % force plot
    drawnow
    
    
    %no simulink interaction
    sys = []; 



  % -------------------
  % Output to Simulink 
  % ------------------
  
  case 3,             
      
    sys = []; %no outputs

   
    


  % ----------------------
  % Time of Next Execution
  % ----------------------
  
  case 4,

    % time simulation time for animation plot
  	sys = t + ts;




  % ----
  % Exit
  % ----
  
  case 9,
     
    sys=[]; %no interaction


end %switch
