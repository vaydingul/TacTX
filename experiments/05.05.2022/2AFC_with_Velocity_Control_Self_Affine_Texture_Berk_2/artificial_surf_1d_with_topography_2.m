function [z , PixelWidth , PSD] = artificial_surf_1d_with_topography(sigma, H, L, n, topography, qr, qLimit)
% Generates artifial randomly rough surfaces with given parameters.
% In other words, generates fractal topographies with different fractal
% dimensions.

% ======================= inputs
% parameters (in SI units)
% sigma: standard deviation , i.e. root-mean-square roughness Rq(m)
% H: Hurst exponent (roughness exponent), 0<= H <= 1
% It relates to the fractal dimension of a surface by D = 3-H.
% L: length of topography in x direction.
% m: number of pixels in x

% !!! please note that setting x and y to be a power of 2 will reduce
% computing time, like using the numbers (256,512,1024,2048,...)
% !!! a normal desktop computer cannot handle pixels above 2048
% !!! you can increase resolution (i.e. pixelwidth) by increasing n and m,
% or reducing size of final topography (reducing L)

% qr (((OPTIONAL parameter)))):
% cut-off wavevector or roll-off wavevector (1/m), it relates to
% roll-off wavelength by qr = (2*pi)/lambda_r, where lambda_r is the
% roll-off wavelength. Check the image that I uploaded to Mathworks for its
% meaning.
% !!! note that qr cannot be smaller than image size, i.e. qr > (2*pi/L)
% where L is the length of image in x and/or y direction ( L and Ly ).
% Also, qr cannot be bigger than Nyquist frequency qr < (pi/PixelWidth)

% ======================== outputs
% z : the surface height profile of a randomly rough surface (m)
% PixelWidth : spatial resolution, i.e. the distance between each two points
% in the generated height topography z (m). This directly relates to the size
% of generated surface by the relation L = (m-1) * PixelWidth
% PSD: this is a radially averaged power spectrum  of the generated surface.
% To check your results,when you have generated the surface z, again apply
% power spectrum technique to z topography by code:
% http://se.mathworks.com/matlabcentral/fileexchange/54297-radially-averaged-surface-roughness-power-spectrum--psd-
% then compare it the PSD output here. They must be the same!

% ======================== plot the topography
% [n,m] = size(z);
% x = linspace(0,(m-1) * PixelWidth , m);
% y = linspace(0,(n-1) * PixelWidth , n);
% [X,Y] = meshgrid(x,y);
% mesh(X,Y,z)
% colormap jet
% axis equal

% =========================== example inputs
% [z , PixelWidth, PSD] = artificial_surf(0.5e-3, 0.8, 0.1, 512 , 512);
% generates surface z with sigma = 0.5 mm, H = 0.8 Hurst exponent
% [i.e. a surface with fractal dimension D = 2.2], L = 10 cm [the size of
% topography in x direction], m = n = 512 [results in a square surface,
% i.e. L = Ly = 10 cm]. With these parameters simply the Pixel Width of
% the final topography is L/(m-1) = 1.96e-4.

% [z , PixelWidth] = artificial_surf(1e-3, 0.7, 0.1, 1024 , 512, 1000);
% generated surface z with sigma = 1 mm, H = 0.7 (i.e. D = 2.3) with L =
% 10 cm. Pixelwidth = L / (m-1) = 9.8e-5 m.
% Since m and n are not equal, the surface is rectangular (not square) and
% Ly = n * Pixelwidth = 5 cm. The surface has a roll-off wavevector
% ar qr = 1000 (1/m) which is equal to lambda_r = (2*pi/qr) = 6.3 mm.
% !!! Play with qr to realize its physical meaning in a topography

% =========================== general notes
% !!! note that the code assumes same pixel width in x and y direction,
% which is typical of measurement instruments

% !!! The generated surface could be rectangular (if n =~ m)

% !!! L = m * PixelWidth; % image length in x direction
% !!! Ly = n * PixelWidth; % image length in y direction

% =========================================================================
% make surface size an even number
if mod(n,2)
    n = n -1;
end

% =========================================================================
PixelWidth = L/n;

L = n * PixelWidth; % image length in x direction

% =========================================================================
% Wavevectors (note that q = (2*pi) / lambda; where lambda is wavelength.
% qx
q = zeros(n,1);
% After this for loop, 
% q will be equal to:
% q = [0 ... 2*pi]
for k = 0:n-1
    q(k+1)=(2*pi/n)*(k);
end

q = (unwrap((fftshift(q))-2*pi))/PixelWidth;

% =========================================================================
% handle qr case
 if ~exist('qr','var')
     % default qr
      qr = 0; % no roll-off
 end

% 2D matrix of Cq values
C = zeros(n, 1);
    for j = 1:n
        if abs(q(j)) < qr
            
            C(j) = qr ^ (-2*(H+1));
            
        elseif abs(q(j)) > qr && abs(q(j)) < qLimit
            
            C(j) = abs(q(j)) .^(-2*(H+1));
        else
            
            C(j) = 0;

        end
    end

% =========================================================================
% applying rms
C(n/2+1) = 0; % remove mean
RMS_F2D = sqrt((sum(C))*(2*pi/L));
alfa = sigma/RMS_F2D;
C = C.*alfa^2;


% =========================================================================
% reversing opertation: PSD to fft
Bq = sqrt(C./(PixelWidth/(2 * pi * n)));

% =========================================================================
Bq(1) = 0;
Bq(n/2+1) = 0;
Bq(2:end) = rot90(Bq(2:end),2);
Bq(n/2+2:end) = rot90(Bq(2:n/2),2);

% =========================================================================
% defining a random phase between -pi and phi (due to fftshift,
% otherwise between 0 and 2pi)
phi = topography;
% phi = -pi + (pi + pi) * pearsrnd(0, 1, 0.2, 3, n, m);
% =========================================================================
% apply conjugate symmetry to phase
phi(1) = 0;
phi(n/2+1) = 0;
phi(2:end) = -rot90(phi(2:end),2);
phi(n/2+2:end) = -rot90(phi(2:n/2),2);

% =========================================================================
% Generate topography
[a,b] = pol2cart(phi,Bq);
Hm = complex(a, b); % Complex Hm with 'Bq' as abosulte values and 'phi' as
% phase components.

z = ifft(ifftshift((Hm))); % generate surface

PSD.q = q;
PSD.Bq = Bq;
PSD.C = C;
