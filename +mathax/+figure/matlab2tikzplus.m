function [ ] = matlab2tikzplus( filename )
% MATLAB2TIKZPLUS Convert figure to TiKz file, with predefined parameters
matlab2tikz('checkForUpdates',false,'showInfo', false,'parseStrings', false, 'width','0.8\columnwidth',filename);
end

