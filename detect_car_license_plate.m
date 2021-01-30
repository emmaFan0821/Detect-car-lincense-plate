function [str] = detect_car_license_plate(im_plate, im_template)
%% edge detection
gray_plate=rgb2gray(im_plate);
thresh=graythresh(gray_plate);  % threshold
bi_plate=im2bw(gray_plate,thresh); % binarize
figure (1);subplot(2,2,1);imshow(bi_plate);title('1.binarize');
edge_plate=edge(bi_plate,'canny'); % edge detection
figure (1);subplot(2,2,2);imshow(edge_plate);title('2.edge detection');

%% closing & bwareaopen
SE2=strel('rectangle', [37,25]);
cls_plate=imclose(edge_plate,SE2);
figure (1);subplot(2,2,3);imshow(cls_plate);title('3.closing');
rm_border = bwareaopen(cls_plate,1000,4);  % Eliminate the remaining border of the license plate
figure (1);subplot(2,2,4);imshow(rm_border);title('4.remove the border');

%% Locate the license plate, similar with cutedge function
[m,n]=size(rm_border);
top=1;bottom=m;left=1;right=n;   
while sum(rm_border(top,:))==0 && top<=m     %Cut out the white area (crosscut)
    top=top+1;
end
while sum(rm_border(bottom,:))==0 && bottom>1   
    bottom=bottom-1;
end

while sum(rm_border(:,left))==0 && left<n        %Cut out white areas (longitudinally)
    left=left+1;
end
while sum(rm_border(:,right))==0 && right>=1
    right=right-1;
end
w=right-left;
h=bottom-top;
crop_plate=imcrop(bi_plate,[left top w h]); % the only difference between c
figure(2);subplot(1,2,1),imshow(crop_plate);title('cut edge once'); % Cut once,mainly positioning
crop_plate=cutedge(crop_plate);
figure(2),subplot(1,2,2),imshow(crop_plate),title('cut edge twice') % cut twice,cut off the black edge of E
%% plate segmentation
word=cell(1,8);
after_cut=crop_plate;
plate_name=('1':'8');
pointer=0;
figure(3),
for j=1:8
    [word{j},pointer]=cutplate(after_cut,pointer);% Cut out the first character
    imwrite(word{j},[plate_name(j),'.jpg']);
    subplot(1,8,j),imshow(word{j})
end

%% model segementation
gray_temp=rgb2gray(im_template);
bi_temp=im2bw(gray_temp,thresh);
bi_temp=1-bi_temp; %change background to black, foreground to white
% figure(1);subplot(1,3,1);title('alphanumeric_templates after binarization');imshow(bi_temp)
block_temp=cuttemplate(bi_temp);

%% match model and plate letter
letter_set=char(['0':'9' 'A':'Z']);% Sort by Model folder， 0-9 are 1-10, A-Z is 11-36;
num=1;  
 for i=1:8
    bi_word=double(word{i});
    bi_word=im2bw(bi_word,thresh);  
    
    k=1;
    difference=zeros(1,36);
    for j=1:36
        fname = strcat('model\',letter_set(j),'.jpg');  % find template block in model folder
        bi_block = imread(fname);
        bi_block = im2bw(bi_block,thresh);  
        
        count=0;
        subtract=zeros(30, 20);
        % Subtract the plate letter image from the template image,count the number of different pixels
        for h = 1:30
            for w = 1:20
                subtract(h, w)=bi_word(h, w)-bi_block(h ,w);
                if subtract(h,w)~=0
                    count=count+1; 
                end
            end
        end
        difference(k) = count;
        k=k+1;
    end
    
    match_word=find(difference==min(difference)); % Find the most match image with the fewest differences   
    str(num*2-1)=letter_set(match_word);
    if letter_set(match_word)=='O'
        str(num*2-1)=letter_set(match_word+2);
    end
    str(num*2)=' ';
    num=num+1;
 end
msgbox(str,'The license number is:');
end