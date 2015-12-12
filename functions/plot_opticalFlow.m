
function plot_opticalFlow(flow)

[N,M,C] = size(flow);

x=1:20:N;
y=1:20:M;

quiver(flow(x,y,1),flow(x,y,2))