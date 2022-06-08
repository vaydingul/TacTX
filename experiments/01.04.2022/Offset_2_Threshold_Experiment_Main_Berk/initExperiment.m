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

CONFIG.EXPLORATION_DURATION = 10; %sec

CONFIG.INITIAL_SCALE_FACTOR = 1.5;
CONFIG.INITIAL_STEP_SIZE = 0.2;
CONFIG.MAX_REVERSAL = 16;

CONFIG.REVERSAL_RULE_1 = 3;
CONFIG.REVERSAL_RULE_2 = 6;
CONFIG.REVERSAL_RULE_3 = CONFIG.MAX_REVERSAL;

CONFIG.STEP_SIZE_1 = CONFIG.INITIAL_STEP_SIZE;
CONFIG.STEP_SIZE_2 = 0.1;
CONFIG.STEP_SIZE_3 = 0.04;

CONFIG.SKEWNESS = 'NEGATIVE'; % 'NEGATIVE'

CONFIG.DOWNSTAIR = 2;
CONFIG.UPSTAIR = 1;