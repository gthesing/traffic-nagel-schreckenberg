% Multi-lane traffic modeling with the Nagel-Schrekenberg Model

clear
clc
close all

figure('Position',[100 500 1700 300])
H=line('Color',[1 0 0],'Marker','.','MarkerSize',20,'EraseMode','normal');

axis([0,100,-10,10])
hold on
x=0:0.1:100;
Y=zeros(2,1001);
Y(1,:)=-1;
Y(2,:)=1;
plot(x,Y(1,:),'b',x,Y(2,:),'b');

% Things that can be varied
cells=100; 
car=15;
max_v=10;
step=100;
%
dt=0.05;
X=zeros(step,car);
V=zeros(step,car);
V(1,:)=3;      %initial velocity of each car
% initial positions, somewhat equally spread out
space=floor(cells/car);
X(1,1)=1;
for m=2:1:car
    X(1,m)=X(1,m-1)+space;
end

%%%   Process for each step   %%%

for q=2:1:step
    for i=1:1:car
        
        % Acceleration
        if V(q-1,i)<max_v
            V(q,i)=V(q-1,i)+1;
        else
            V(q,i)=V(q-1,i);
        end
        
        % Deceleration 
        C=zeros(1,car);
        for b=1:car
            num=X(q-1,b);
            for k=1:car
                if X(q-1,k)<num
                    C(1,k)=X(q-1,k)+cells;
                else
                    C(1,k)=X(q-1,k);
                end
            end
            A=sort(C);
            dis=A(2)-A(1);
                    if dis<max_v && V(q,b)>dis
                        V(q,b)=dis;
                    else
                        V(q,b)=V(q,b);
                    end
        end
        
        % Randomization
        p=10*rand(1);
        if V(q,i)>1
            if p>3
                V(q,i)=V(q,i)-1;
            end
        else
            V(q,i)=V(q,i);
        end
        
        % Assure non-negative velocity 
        % Decide if 0 velocity is alright
        if V(q,i)<1
            V(q,i)=1;
        else
        end
        
        % Movement
        X(q,i)=X(q-1,i)+V(q,i);
        if X(q,i)>cells
            X(q,i)=X(q,i)-cells;
        else
            X(q,i)=X(q,i);
        end
    end
    % Animation time
    Y=zeros(1,car);
    hold on 
    set(H,'xdata',X(q-1,:),'ydata',Y(:),'LineStyle','none');
    pause(dt);
end



    
    
    
