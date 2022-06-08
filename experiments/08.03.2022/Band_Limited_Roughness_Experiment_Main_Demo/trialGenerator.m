NBlock = 1;
N = 4;
maxNumberOfRepetition = 1;
trials = [];
for k = 1 : NBlock
    
   if k == 1
       
       block = generateBlock(N, maxNumberOfRepetition);
       
   else
   
   isWrong = true;
   while isWrong
       
       block = generateBlock(N, maxNumberOfRepetition);
       isWrong = block(1) == trials(end);
    
   end
   
   end
   
   trials = [trials; block];
  
    
end

 trials = [trials -trials];
 
 test = (sum(trials(:, 1)) == 0) && (sum(trials(:, 1) == 1) == NBlock * N / 2) && (sum(trials(:, 1) == -1) == NBlock * N / 2); 
 
 if test
 save('trials.mat', 'trials');
 else
     disp('There is something wrong!');
 end

function block = generateBlock(N, maxNumberOfRepetition)
    
    n = N / 2;
    isWrong = true;
    
    while isWrong
    
        trials = [ones(n, 1); -1*ones(n,1)];
        rp = randperm(N);
        trials = trials(rp);
        d = [true; diff(trials) ~= 0; true];
        repetitions = diff(find(d));
        
        isWrong = sum(find(repetitions > maxNumberOfRepetition)) > 0;
    
    end
    
    block = trials;

end