function [ ] = montyhall(n,d,s)
%montyhall(n,d,s) 
%   
%                Simulates n rounds of the Monty Hall problem and
%                 plots the cumulative ratio of wins/total times played
%
%                n   : Number of rounds to simulate (Any positive integer)
%                d   : Number of doors (Positive integer >= 3)
%                s=0 : Always switches
%                s=1 : Switches with probability N-1/N
%                s=2 : Switches with probability 1/2
%                s=3 : Always stays
%
% All parameters are optional
%                For more information on the Monty Hall problem go to 
%                 http://en.wikipedia.org/wiki/Monty_Hall_problem.
%------------------------%


%-- Check variables and set to defaults
if exist('n','var')~=1, n=1; end
if exist('d','var')~=1 || d<3 || d~=round(d), d=3; end
if exist('s','var')~=1, s=0; end

%-- Holds player victories 
Monty=zeros(n,1);

for i = 1:n
    %-- Picks a random door for the car to be behind
    Car = randi(d);
    %-- Player picks a random door
    Choose = randi(d);
%     %-- Monty has opened 0 doors so far
%     Monty =0;
%     %-- represents which doors Monty won't open
%     doors = zeros(d,1);
% 
%     doors(Car)=1;
%     doors(Choose)=1;
%     %-- In the end the player must have 2 doors to chose either to stay
%     %or to switch
%     while Monty<d-2
%         Open = randi(d)
%         if doors(Open)==0
%             %-- the 
%             doors(Open)=1;
%             Monty = Monthy + 1;
%         end
%     end
    %-- Applies picking strategy
    switch s
        case 0
            if Choose~=Car 
                Monty(i)=1;
            end
        case 1
            if (rand() <= (n-1.0)/n)
                if (Choose~=Car),Monty(i)=1;end;
            else
                if (Choose==Car),Monty(i)=1;end; 
            end
        case 2
            if (rand() <= 0.5) 
                if (Choose~=Car),Monty(i)=1;end;
            else
                if (Choose==Car),Monty(i)=1;end; 
            end
        case 3
            if (Choose==Car)
                 Monty(i)=1;
            end  
    end
end

for i = 2:n
    Monty(i) = (Monty(i)+Monty(i-1));
end
for i = 2:n
    Monty(i) = (Monty(i)/i);
end

%-- Plotting phase

figurePlot=figure;
f =plot(Monty);
figureName='';
switch s
        case 0
            title('Monty Hall Simulation - Strategy: Always Switches')
            figureName='MontyHall_AlwaysSwitches';
        case 1
            title('Monty Hall Simulation - Strategy: Mixed strategy where the player switches with probability (N-1)/N')
            figureName='MontyHall_Switches(N-1)InNTimes';
        case 2
            title('Monty Hall Simulation - Strategy: Mixed strategy where the player switches half the time')
            figureName='MontyHall_SwitchesHalfTheTimes'
        case 3
            title('Monty Hall Simulation - Strategy: Always Stays')
            figureName='MontyHall_AlwaysStays'
end

axis([1,n,0,1])
ylabel('P(win)')
xlabel('N');

%-- First get the figure's data-cursor mode, activate it, and set some of its properties
cursorMode = datacursormode(gcf);
set(cursorMode, 'enable','on', 'UpdateFcn',@setDataTipTxt, 'NewDataCursorOnClick',false);
hTarget = handle(f);
hDatatip = cursorMode.createDatatip(hTarget);
 
%-- Create a copy of the context menu for the datatip:
set(hDatatip,'UIContextMenu',get(cursorMode,'UIContextMenu'));
set(hDatatip,'HandleVisibility','off');
set(hDatatip,'Host',hTarget);
set(hDatatip,'ViewStyle','datatip');
 
%-- Set the data-tip orientation to top-right rather than auto
set(hDatatip,'OrientationMode','manual');
set(hDatatip,'Orientation','top-left');
 
%-- Update the datatip marker appearance
set(hDatatip, 'MarkerSize',5, 'MarkerFaceColor','none', ...
              'MarkerEdgeColor','k', 'Marker','o', 'HitTest','off');
 
%-- Move the datatip to the right-most data vertex point
position = [n,Monty(n),1; n,Monty(n),-1];
update(hDatatip, position);
set(figurePlot, 'Position', [100, 100, 1000, 600]);
saveas(figurePlot,figureName,'png')

end

function text_to_display = setDataTipTxt(cursorMode,eventData)
   pos = get(eventData,'Position');
   text_to_display = {['N: ',num2str(pos(1))], ...
                      ['P(win): ',num2str(pos(2))]};
end

      