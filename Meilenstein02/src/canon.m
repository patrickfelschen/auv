clear;

%% Reading the CFA Image into MATLAB
filename = "./raw_dng/canon.dng"; % Put file name here
warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning
t = Tiff(filename,"r");
offsets = getTag(t,"SubIFD");
setSubDirectory(t,offsets(1));
raw = read(t); % Create variable ’raw’, the Bayer CFA data
close(t);
meta_info = imfinfo(filename);
% Crop to only valid pixels
x_origin = meta_info.SubIFDs{1}.ActiveArea(2)+1; % +1 due to MATLAB indexing
width = meta_info.SubIFDs{1}.DefaultCropSize(1);
y_origin = meta_info.SubIFDs{1}.ActiveArea(1)+1;
height = meta_info.SubIFDs{1}.DefaultCropSize(2);
raw = double(raw(y_origin:y_origin+height-1,x_origin:x_origin+width-1));

%% Linearizing
if isfield(meta_info.SubIFDs{1},"LinearizationTable")
    ltab = meta_info.SubIFDs{1}.LinearizationTable;
    raw = ltab(raw+1);
end

black = meta_info.SubIFDs{1}.BlackLevel(1);
saturation = meta_info.SubIFDs{1}.WhiteLevel;
lin_bayer = (raw-black)/(saturation-black);
lin_bayer = max(0,min(lin_bayer,1));

%% White Balancing
wb_multipliers = (meta_info.AsShotNeutral).^-1;
wb_multipliers = wb_multipliers/wb_multipliers(2);
mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,"rggb");
balanced_bayer = lin_bayer .* mask;

%% Demosaicing
temp = uint16(balanced_bayer/max(balanced_bayer(:))*2^16);
lin_rgb = double(demosaic(temp,"rggb"))/2^16;

%% Color Space Conversion
xyz2cam = reshape(meta_info.ColorMatrix2, 3, 3);
rgb2xyz = [0.4124564, 0.3575761,0.1804375; 0.2126729, 0.7151522, 0.0721750; 0.0193339, 0.1191920, 0.9503041];

rgb2cam = xyz2cam * rgb2xyz; % Assuming previously defined matrices
rgb2cam = rgb2cam ./ repmat(sum(rgb2cam,2),1,3); % Normalize rows to 1
cam2rgb = rgb2cam^-1;
lin_srgb = apply_cmatrix(lin_rgb, cam2rgb);
lin_srgb = max(0,min(lin_srgb,1)); % Always keep image clipped b/w 0-1

%% Brightness and Gamma Correction
grayim = rgb2gray(lin_srgb);
grayscale = 0.25/mean(grayim(:));
bright_srgb = min(1,lin_srgb*grayscale);

nl_srgb = bright_srgb.^(1/2.2);

%% Show Image
figure;
imshow(nl_srgb);


%% Functions
function colormask = wbmask(m,n,wbmults,align)
% COLORMASK = wbmask(M,N,WBMULTS,ALIGN)
%
% Makes a white-balance multiplicative mask for an image of size m-by-n
% with RGB while balance multipliers WBMULTS = [R_scale G_scale B_scale].
% ALIGN is string indicating Bayer arrangement: ’rggb’,’gbrg’,’grbg’,’bggr’
colormask = wbmults(2)*ones(m,n); %Initialize to all green values
switch align
case "rggb"
colormask(1:2:end,1:2:end) = wbmults(1); %r
colormask(2:2:end,2:2:end) = wbmults(3); %b
case "bggr"
colormask(2:2:end,2:2:end) = wbmults(1); %r
colormask(1:2:end,1:2:end) = wbmults(3); %b
case "grbg"
colormask(1:2:end,2:2:end) = wbmults(1); %r
colormask(1:2:end,2:2:end) = wbmults(3); %b
case "gbrg"
colormask(2:2:end,1:2:end) = wbmults(1); %r
colormask(1:2:end,2:2:end) = wbmults(3); %b
end
end

function corrected = apply_cmatrix(im,cmatrix)
% CORRECTED = apply_cmatrix(IM,CMATRIX)
%
% Applies CMATRIX to RGB input IM. Finds the appropriate weighting of the
% old color planes to form the new color planes, equivalent to but much
% more efficient than applying a matrix transformation to each pixel.
if size(im,3)~=3
error("Apply cmatrix to RGB image only.")
end
r = cmatrix(1,1)*im(:,:,1)+cmatrix(1,2)*im(:,:,2)+cmatrix(1,3)*im(:,:,3);
g = cmatrix(2,1)*im(:,:,1)+cmatrix(2,2)*im(:,:,2)+cmatrix(2,3)*im(:,:,3);
b = cmatrix(3,1)*im(:,:,1)+cmatrix(3,2)*im(:,:,2)+cmatrix(3,3)*im(:,:,3);
corrected = cat(3,r,g,b);
end