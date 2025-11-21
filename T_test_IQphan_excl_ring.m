%% CBCT Time Stability – T-tests Internship IQPhan (incl. ring)
clear; clc; close all;

% Location of the file
filename = "C:\Users\pimja\OneDrive\Documents\Pim UTwente\Pim Master\IVD track\Internship\MST\Metingen\DATA\QA_Results_Analysis\IQPhan_incl_ring_Results_MATLAB.xlsx";

% Defined parameters
sheets = {'Noise', 'Uniformity', 'Low_Contrast', 'Sensitometry', 'Spatial_Resolution'};

% Defined devices
devices = {'sol_iCBCT','sol_iCBCTa','var_iCBCT','var_iCBCTa'};

%% Loop over all parameters
for s = 1:numel(sheets)
    sheetname = sheets{s};
    
    % Read data from Excel
    T = readtable(filename, 'Sheet', sheetname);
    session = T.Session;
    
    fprintf('\n===== T-tests for %s =====\n', sheetname);
    
    
    comparisons = {...
        {'sol_iCBCT','var_iCBCT'}, ...
        {'sol_iCBCTa','var_iCBCTa'}, ...
        {'sol_iCBCT','sol_iCBCTa'}, ...
        {'var_iCBCT','var_iCBCTa'} ...
        };
    
    for c = 1:numel(comparisons)
        dev1 = comparisons{c}{1};
        dev2 = comparisons{c}{2};
        
        data1 = T.(dev1);
        data2 = T.(dev2);
        
        
        data1 = data1(~isnan(data1));
        data2 = data2(~isnan(data2));
        
        % Checking normality
        [h_norm1, p_norm1] = kstest((data1 - mean(data1)) / std(data1));
        [h_norm2, p_norm2] = kstest((data2 - mean(data2)) / std(data2));
        
        fprintf('%s normality p = %.4f | %s normality p = %.4f\n', dev1, p_norm1, dev2, p_norm2);
        
        % Two-sample t-test 
        [h,p,ci,stats] = ttest2(data1, data2);
        
      
        fprintf('%s vs %s: p = %.4f, t = %.3f, df = %.1f -> %s\n', ...
            dev1, dev2, p, stats.tstat, stats.df, ...
            ternary(h==0,'No significant difference','Significant difference'));
    end
end

%%
function out = ternary(cond,valTrue,valFalse)
    if cond
        out = valTrue;
    else
        out = valFalse;
    end
end
