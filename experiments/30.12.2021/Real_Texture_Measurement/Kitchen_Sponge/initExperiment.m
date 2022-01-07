screenSize = get(0, 'screensize');

CONFIG.SCREEN_SIZE_IN_PIXELS = screenSize(3:4);
CONFIG.SCREEN_DPI = 90;
CONFIG.INCH_TO_CM = 2.54;

CONFIG.SLIDING_DISTANCE = 8;
CONFIG.SLIDING_DISTANCE_IN_PIXELS = (CONFIG.SCREEN_DPI / CONFIG.INCH_TO_CM) * CONFIG.SLIDING_DISTANCE;

CONFIG.SAMPLE_RATE = 5000;

CONFIG.SCANS_AVAILABLE_FUNCTION_COUNT = 500;

CONFIG.PRACTICE_MODE = false;
CONFIG.PRACTICE_MODE_NUMBER_OF_FORCE_PRACTICES = 2;
CONFIG.PRACTICE_MODE_MAGNITUDE_OF_FORCE_PRACTICES = 0.5; % N
CONFIG.PRACTICE_MODE_NUMBER_OF_VELOCITY_PRACTICES = 1;
CONFIG.PRACTICE_MODE_MAGNITUDE_OF_VELOCITY_PRACTICES = 4; % cm/s

CONFIG.EXPERIMENT_MODE = ~CONFIG.PRACTICE_MODE;
