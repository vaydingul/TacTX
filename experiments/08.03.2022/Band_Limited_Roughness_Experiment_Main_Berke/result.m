dir_content = dir("./");

positive = 0;
negative = 0;

for k = 1:length(dir_content)
   
    if startsWith(dir_content(k).name, 'experiment_trial') && endsWith(dir_content(k).name, '.mat')
    
       load(dir_content(k).name);
       
       if tactx.Config.CURRENT_USER_INPUT == 1 
           
          if  tactx.Config.CURRENT_SIGNAL_PARAMETER_1 == 1
              
              positive = positive + 1;
              
          else
              
              negative = negative + 1;
              
          end
          
       elseif tactx.Config.CURRENT_USER_INPUT == 2 
           
           if  tactx.Config.CURRENT_SIGNAL_PARAMETER_2 == 1
              
              positive = positive + 1;
              
          else
              
              negative = negative + 1;
              
           end
          
       end
        
    end
end