clc; clear; close all;


%% User Inputs

% Function Inputs
User.Function = 'Sphere';
User.NumbVars = 4;
User.RangeVars = [-20,20];

% FireFly Inputs
User.NumbPop = 20;
User.MaxIter = 1000;

% Attraction Equation Inputs
User.Beta0 = 1;
User.Gamma = 1;
User.Alpha = 0.2;
User.m = 2;

% Damping Equation
User.Damp = 0.99;

%% Initializing the FireFly Algorithm
SampleFireFly.Position = [];
SampleFireFly.Cost = [];
FireFly = repmat(SampleFireFly,User.NumbPop,1);

BestFireFly.Cost = inf;
for i = 1:User.NumbPop
    
   FireFly(i).Position = ...
       unifrnd(User.RangeVars(1),User.RangeVars(2),[1,User.NumbVars]);    
   FireFly(i).Cost = feval(User.Function,FireFly(i).Position);
   
   if FireFly(i).Cost <= BestFireFly.Cost
       BestFireFly = FireFly(i);
   end
    
end

%% MainLoop of FireFly Algorithm
BestFireFlyCost = zeros(User.MaxIter,1);
for Iter = 1:User.MaxIter
NewFireFly = FireFly;
for i = 1:User.NumbPop
   for j = 1:User.NumbPop 
    if FireFly(j).Cost <= FireFly(i).Cost
    
        Distance = norm(FireFly(i).Position - FireFly(j).Position);
        
        Beta = User.Beta0*exp(-User.Gamma*Distance^User.m);
        
        e = unifrnd(-0.05*(User.RangeVars(2)-User.RangeVars(1))...
            ,0.05*(User.RangeVars(2)-User.RangeVars(1))...
            ,[1,User.NumbVars]);
        
        NewFireFly(i).Position = FireFly(i).Position...
            +Beta*(FireFly(j).Position - FireFly(i).Position)...
            +User.Alpha*e;
        
        NewFireFly(i).Position = max(NewFireFly(i).Position...
            ,User.RangeVars(1));
        NewFireFly(i).Position = min(NewFireFly(i).Position...
            ,User.RangeVars(2));
        
        NewFireFly(i).Cost = feval(User.Function...
            ,NewFireFly(i).Position);
        if NewFireFly(i).Cost <= BestFireFly.Cost
            BestFireFly = NewFireFly(i);
        end
    end
   end
end

    FireFly = [NewFireFly
               FireFly
               BestFireFly];%#ok
   [~,SortOrder] = sort([FireFly.Cost]);
   FireFly = FireFly(SortOrder);
   FireFly = FireFly(1:User.NumbPop);
   
   User.Alpha = User.Alpha * User.Damp;
   
   BestFireFlyCost(Iter) = BestFireFly.Cost;
   
   disp(['Iteration',num2str(Iter)...
       ,':BestCost = ',num2str(BestFireFlyCost(Iter))]);
end


figure;
% plot(BestFireFlyCost,'LineWidth',2);
semilogy(BestFireFlyCost,'LineWidth',2);
xlabel('Iteration');
ylabel('BestCost');








