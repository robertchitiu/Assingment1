clf; %clear pre existing plots

numpart=5000; 
color=['k' 'b' 'g' 'r' 'm'];
x0=2*rand(1,numpart)/10^7; %starting points
y0=1*rand(1,numpart)/10^7;

watchers = randi(numpart, 5,1);

Kb=1.38 * 10^ -23;%boltzman contant
T=300;%tempurature in K
m=0.26 * 9.1 * 10^ -31;%mass of electron
dt=0.05*10^-13;%change in time 0.1 ps

%velocities of the particle
Vth=sqrt(3*Kb*T/m);%thermal velocity
Vran=Vth*randn(1,numpart);
o=rand(1,numpart)*2*pi; %angle of movement
Vx=Vran.*sin(o);
Vy=Vran.*cos(o);

To=0.2*10^-12; %mean time between colision
Pscat=(1 - exp(dt/To)); %probability of scattering
random=rand(1,numpart); %random value for each electron
time=0; 

%Mean free path
d = 2.82*10^-15; %radius of electron
Vol = 200*10^-9*100*10^-9; %area of silicon
landa = Vol/(sqrt(2)*numpart*pi*d^2);


%tempurature plot
tempa=0;
temp = (Vran.^2 * m)/(3*Kb);
for q=1:numpart 
   tempa = tempa + temp(q);
end
tempave= tempa/numpart;

plot(0) 
xlim([0, 200*10^-9]);
ylim([0, 100*10^-9]);


%figure(2)
%histogram(Vran)
    
for i=2:1000
    x1=x0+Vx*dt;
    y1=y0+Vy*dt;
    time = time+dt;
   
    Vran(Pscat>random)=Vth*randn();
    o(Pscat>random)=rand()*2*pi;
    Vx(Pscat>random) = Vran(Pscat>random).*sin(o(Pscat>random));
    Vy(Pscat>random) = Vran(Pscat>random).*cos(o(Pscat>random));
    random= rand(1,numpart);
   
   
    %top bondary condition
    Vy(y1>=100*10^-9)=-1*Vy(y1>=100*10^-9);
    x1(y1>=100*10^-9)=(100*10^-9-y0(y1>=100*10^-9)).*(x1(y1>=100*10^-9)-x0(y1>=100*10^-9))./(y1(y1>=100*10^-9)-y0(y1>=100*10^-9)) + x0(y1>=100*10^-9);
    y1(y1>=100*10^-9)=100*10^-9;
    %bottom Bondary condition
    Vy(y1<=0)=-1*Vy(y1<=0);
    x1(y1<=0)=(0-y0(y1<=0)).*(x1(y1<=0)-x0(y1<=0))./(y1(y1<=0)-y0(y1<=0)) + x0(y1<=0);
    y1(y1<=0)=0;
    %left bondary condition
    y1(x1<0)=(y1(x1<0)-y0(x1<0))./(x1(x1<0)-x0(x1<0)).*(0-x0(x1<0))+y0(x1<0);
    x1(x1<0)=0;
    %right bondary condition
    y1(x1>200*10^-9)=(y1(x1>200*10^-9)-y0(x1>200*10^-9))./(x1(x1>200*10^-9)-x0(x1>200*10^-9)).*(200*10^-9-x0(x1>200*10^-9))+y0(x1>200*10^-9);
    x1(x1>200*10^-9)=200*10^-9; 
    
    
    %{
    %tempurature plot
    temp = (Vran.^2 * m)/(3*Kb);
    for q=1:numpart 
        
        tempa = tempa + temp(q);
    end
    tempave= tempa/numpart;
    tempa=0;
    plot(time,tempave, 'o')
    hold on;
    %}
    
    
    for j=1:5
        plot([x0(watchers(j)) x1(watchers(j))], [y0(watchers(j)) y1(watchers(j))],color(j),'linewidth',1)
        hold on
    end
    
   %Left side condition
    x1(x1==200*10^-9 & Vx>0)=0;
    %Right side condition
    x1(x1==0 & Vx<0)=200*10^-9;
    
    x0=x1;y0=y1;
    pause(0.1);
end

