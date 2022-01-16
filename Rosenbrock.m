function Cost = Rosenbrock(x)

    n = numel (x);
    
    Cost = 0;
    for i = 1:n-1
        
       Cost = Cost + 100*(x(i+1)-x(i)^2)^2 + (1-x(i))^2;
        
    end


end