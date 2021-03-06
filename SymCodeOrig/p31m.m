function image = p31m(N,n)

% close all
% clear all
% N=1024;
% 
% n = 64;
% base tile triangle to be 3 times size it should be, as then enforce
% rotations
s = round(n*sqrt(12/sqrt(3)));
a = floor(s/2)-1;
h = round(sqrt(s^2-(s/2)^2));
tile = rand(s);
% tile(1,:) = 1;
% tile(s,:) = 1;
% tile(:,1) = 1;
% % tile(:,s) = 1;
% tile(:,(a-1):(a+1)) =1;
% tile(100:120, 10:20) = 1;
magfactor = 8;
tile = imresize(tile, magfactor, 'nearest');
n=magfactor*n;
s = round(n*sqrt(12/sqrt(3)));
a = floor(s/2)-1;
h = round(sqrt(s^2-(s/2)^2));
% make triangular tile
for y=1:s
    for x=1:floor(s/2)
        if (x<y*tand(60))
            tile(x,y) = 0;
        end
    end
    for x=ceil(s/2):s
        if ((s-x)<y*tand(60))
            tile(x,y) = 0;
        end
    end
end

% subplot(1,2,1)
% imshow(tile)

% enforce 60deg rotations
% subplot(1,2,2)
% tile = trim(tile);
tile120 = trim(imrotate(tile, 120));
tile240 = trim(imrotate(tile, 240));

tile240(size(tile240,1),:) = [];
tile(:,1) = [];
tile120 = [tile120, zeros(size(tile120,1), size(tile,2)-size(tile120,2))];
tile120 = [tile120; zeros(2,size(tile120,2))];
tile240 = [tile240, zeros(size(tile240,1), size(tile,2)-size(tile240,2))];
tile240 = [zeros(3,size(tile240,2)); tile240];
a = size(tile,1)-size(tile120)+1;
tile(a:size(tile,1), :) = max(tile(a:size(tile,1), :), tile120);
tile(1:size(tile240,1),:) = max(tile(1:size(tile240,1),:), tile240);
clear tile120 tile240

tile = trim(tile);
% tile
a = size(tile,1);
b = size(tile,2);
tileflip = tile(:,size(tile,2):-1:1);
% tile2 = [tile, tileflip];
tile = max(tile,circshift(tileflip, [round(size(tileflip,1)/2),0])); 

tile2 = [tile, circshift(tile, [round(size(tile,1)/2),0])];
tile = imresize(tile2, 1/magfactor);
n=n/magfactor;
I = repmat(tile, [N/(2*n), N/(2*n)]);
% imwrite(I(1:N,1:N), 'p31m.png');
image = I(1:N,1:N);
end

function tile = trim(tile)
linesum = sum(tile(1,:));
while(linesum==0)
    tile(1, :) = [];
    linesum = sum(tile(1, :));
end
linesum = sum(tile(:, 1));
while(linesum==0)
    tile(:, 1) = [];
    linesum = sum(tile(:, 1));
end
linesum = sum(tile(size(tile, 1), :));
while(linesum==0)
    tile(size(tile,1), :) = [];
    linesum = sum(tile(size(tile, 1),:));
end
linesum = sum(tile(:, size(tile ,2)));
while(linesum==0)
    tile(:, size(tile,2)) = [];
    linesum = sum(tile(:, size(tile, 2)));
end
end
