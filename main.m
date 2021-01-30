close all;clc;
im_plate=imread('car_license_plate.bmp');
im_template=imread('alphanumeric_templates .bmp');
[str] = detect_car_license_plate(im_plate, im_template);
disp(str)
